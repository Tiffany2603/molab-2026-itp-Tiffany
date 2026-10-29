import AVFoundation
import CoreImage

// Like the class example, write processed frames with AVAssetWriter (no audio).
final class MovieWriter {
    let url: URL
    private let writer: AVAssetWriter
    private let input: AVAssetWriterInput
    private let adaptor: AVAssetWriterInputPixelBufferAdaptor
    private var frameCount = 0

    init(width: Int, height: Int, firstTime: CMTime) throws {
        url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
        writer = try AVAssetWriter(outputURL: url, fileType: .mp4)
        input = AVAssetWriterInput(mediaType: .video, outputSettings: [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width, AVVideoHeightKey: height
        ])
        input.expectsMediaDataInRealTime = true
        adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input,
            sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
                kCVPixelBufferWidthKey as String: width,
                kCVPixelBufferHeightKey as String: height,
                kCVPixelBufferIOSurfacePropertiesKey as String: [:]
            ])
        guard writer.canAdd(input) else { throw Self.error("Cannot create a video input.") }
        writer.add(input)
        guard writer.startWriting() else {
            throw writer.error ?? Self.error("Cannot start recording.")
        }
        writer.startSession(atSourceTime: firstTime)
    }

    func append(_ image: CIImage, at time: CMTime, context: CIContext) throws {
        guard writer.status == .writing else {
            throw writer.error ?? Self.error("The video writer stopped.")
        }
        // Drop a frame when the encoder is busy, instead of blocking the camera.
        guard input.isReadyForMoreMediaData else { return }
        guard let pool = adaptor.pixelBufferPool else {
            throw Self.error("Cannot create a recording buffer.")
        }
        var buffer: CVPixelBuffer?
        let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &buffer)
        guard status == kCVReturnSuccess, let buffer else {
            throw Self.error("Cannot allocate a recording frame.")
        }
        context.render(image, to: buffer, bounds: image.extent,
                       colorSpace: CGColorSpaceCreateDeviceRGB())
        guard adaptor.append(buffer, withPresentationTime: time) else {
            throw writer.error ?? Self.error("Cannot write this frame.")
        }
        frameCount += 1
    }

    func finish(completion: @escaping (Result<URL, Error>) -> Void) {
        guard frameCount > 0, writer.status == .writing else {
            let error = writer.error ?? Self.error("Recording was too short. Please try again.")
            cancel()
            completion(.failure(error))
            return
        }
        input.markAsFinished()
        writer.finishWriting {
            if self.writer.status == .completed {
                completion(.success(self.url))
            } else {
                completion(.failure(self.writer.error ?? Self.error("Could not finish the video.")))
            }
        }
    }

    func cancel() {
        if writer.status == .writing || writer.status == .unknown { writer.cancelWriting() }
        try? FileManager.default.removeItem(at: url)
    }

    private static func error(_ message: String) -> NSError {
        NSError(domain: "GridCamera", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
