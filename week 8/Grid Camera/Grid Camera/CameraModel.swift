import AVFoundation
import CoreImage
import Observation
import Photos

@Observable
final class CameraModel: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var previewImage: CGImage?
    var isReady = false
    var isRecording = false
    var isSaving = false
    var message = "Starting camera..."
    var exportURL: URL?

    // Camera, filters, and recording all run on this one queue.
    // Only the visible properties above are updated on the main queue.
    private let queue = DispatchQueue(label: "GridCamera.capture")
    private let session = AVCaptureSession()
    private let context = CIContext()
    @ObservationIgnored private var grid = GridFilter()
    @ObservationIgnored private var configured = false
    @ObservationIgnored private var wantsCamera = false
    @ObservationIgnored private var hasFrame = false
    @ObservationIgnored private var recording = false
    @ObservationIgnored private var finishing = false
    @ObservationIgnored private var movie: MovieWriter?

    func startCamera() {
        queue.async {
            guard !self.wantsCamera else { return }
            self.wantsCamera = true
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: self.configureAndStart()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    self.queue.async {
                        guard self.wantsCamera else { return }
                        if granted { self.configureAndStart() }
                        else { self.report("Allow camera access in Settings to use Grid Camera.") }
                    }
                }
            default: self.report("Allow camera access in Settings to use Grid Camera.")
            }
        }
    }

    private func configureAndStart() {
        if !configured {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                for: .video, position: .front) else {
                report("A front camera is required. Please run this app on an iPhone.")
                return
            }
            do {
                let input = try AVCaptureDeviceInput(device: device)
                let output = AVCaptureVideoDataOutput()
                output.alwaysDiscardsLateVideoFrames = true
                output.videoSettings = [
                    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
                ]
                output.setSampleBufferDelegate(self, queue: queue)
                session.beginConfiguration()
                // A small capture size keeps nine live effects manageable.
                if session.canSetSessionPreset(.vga640x480) { session.sessionPreset = .vga640x480 }
                guard session.canAddInput(input) else {
                    session.commitConfiguration()
                    report("Cannot connect to the camera.")
                    return
                }
                session.addInput(input)
                guard session.canAddOutput(output) else {
                    session.removeInput(input)
                    session.commitConfiguration()
                    report("Cannot receive camera frames.")
                    return
                }
                session.addOutput(output)
                if let connection = output.connection(with: .video) {
                    if connection.isVideoRotationAngleSupported(90) { connection.videoRotationAngle = 90 }
                    if connection.isVideoMirroringSupported {
                        connection.automaticallyAdjustsVideoMirroring = false
                        connection.isVideoMirrored = true
                    }
                }
                session.commitConfiguration()
                configured = true
            } catch {
                report("Cannot start the camera: \(error.localizedDescription)")
                return
            }
        }
        if !session.isRunning { session.startRunning() }
    }

    func stopCamera() {
        queue.async {
            self.wantsCamera = false
            self.finishRecording()
            if self.session.isRunning { self.session.stopRunning() }
            self.hasFrame = false
            DispatchQueue.main.async { self.isReady = false }
        }
    }

    func shuffleFilters() {
        queue.async { self.grid.shuffle() }
    }

    func startRecording() {
        queue.async {
            guard self.hasFrame, self.wantsCamera, !self.recording, !self.finishing else { return }
            self.recording = true
            DispatchQueue.main.async {
                self.isRecording = true
                self.message = "Recording silent video..."
            }
        }
    }

    func stopRecording() {
        queue.async { self.finishRecording() }
    }

    // The SAME composed image is used for both preview and recording.
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard wantsCamera, let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let image = grid.apply(to: CIImage(cvPixelBuffer: buffer))
        guard let preview = context.createCGImage(image, from: image.extent) else {
            report("Cannot process the camera image.")
            return
        }
        let firstFrame = !hasFrame
        hasFrame = true
        DispatchQueue.main.async {
            self.previewImage = preview
            self.isReady = true
            if firstFrame, !self.isRecording, !self.isSaving {
                self.message = "Nine regions, one continuous scene."
            }
        }
        if recording {
            do {
                let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                if movie == nil {
                    movie = try MovieWriter(width: CVPixelBufferGetWidth(buffer),
                        height: CVPixelBufferGetHeight(buffer), firstTime: time)
                }
                try movie?.append(image, at: time, context: context)
            } catch {
                movie?.cancel()
                movie = nil
                recording = false
                DispatchQueue.main.async { self.isRecording = false }
                report("Could not record: \(error.localizedDescription)")
            }
        }
    }

    private func finishRecording() {
        guard recording else { return }
        recording = false
        guard let movie else {
            DispatchQueue.main.async { self.isRecording = false }
            report("Recording was too short. Please try again.")
            return
        }
        finishing = true
        DispatchQueue.main.async {
            self.isRecording = false
            self.isSaving = true
            self.message = "Saving video..."
        }
        movie.finish { result in
            self.queue.async {
                self.movie = nil
                switch result {
                case .success(let url): self.saveToPhotos(url)
                case .failure(let error): self.finishSaving("Could not save: \(error.localizedDescription)")
                }
            }
        }
    }

    private func saveToPhotos(_ url: URL) {
        // Keep a shareable copy if Photos access is denied or saving fails.
        DispatchQueue.main.async { self.exportURL = url }
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized else {
                self.queue.async {
                    self.finishSaving("Photos access was denied. Use Share Last Video to keep your recording.")
                }
                return
            }
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            } completionHandler: { saved, _ in
                self.queue.async {
                    self.finishSaving(saved ? "Video saved to Photos." :
                        "Could not save to Photos. Use Share Last Video to keep your recording.")
                }
            }
        }
    }

    private func finishSaving(_ text: String) {
        finishing = false
        DispatchQueue.main.async {
            self.isSaving = false
            self.message = text
        }
    }

    private func report(_ text: String) {
        DispatchQueue.main.async { self.message = text }
    }
}
