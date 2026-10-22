import SwiftUI
import PhotosUI
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var originalImage: Image?
    @State private var processedImage: Image?
    @State private var inputImage: CIImage?
    @State private var filterIntensity = 0.7
    @State private var showOriginal = false
    @State private var message = ""

    let context = CIContext()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Give a photo a vintage tone and compare it with the original.")
                        .foregroundStyle(.secondary)

                    Group {
                        if showOriginal, let originalImage {
                            originalImage.resizable().scaledToFit()
                        } else if let processedImage {
                            processedImage.resizable().scaledToFit()
                        } else {
                            ContentUnavailableView("No photo yet", systemImage: "photo",
                                description: Text("Choose a photo to get started."))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)

                    if originalImage != nil {
                        Text(showOriginal ? "Original" : "Edited")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    PhotosPicker("Choose Photo", selection: $selectedItem, matching: .images)
                        .buttonStyle(.borderedProminent)
                        .onChange(of: selectedItem, loadImage)

                    HStack {
                        Text("Vintage")
                        Slider(value: $filterIntensity, in: 0...1)
                            .accessibilityLabel("Vintage intensity")
                            .onChange(of: filterIntensity, applyProcessing)
                        Text("\(Int(filterIntensity * 100))%")
                            .monospacedDigit()
                    }
                    .disabled(inputImage == nil || showOriginal)

                    Toggle("Show Original", isOn: $showOriginal)
                        .disabled(originalImage == nil)

                    HStack {
                        Button("Reset Effect") {
                            filterIntensity = 0.7
                            showOriginal = false
                            applyProcessing()
                        }
                        .disabled(inputImage == nil)

                        Spacer()

                        if let processedImage {
                            ShareLink(item: processedImage,
                                preview: SharePreview("Edited photo", image: processedImage)) {
                                Label("Share Edited Photo", systemImage: "square.and.arrow.up")
                            }
                        }
                    }

                    if !message.isEmpty {
                        Text(message)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
                .padding()
            }
            .navigationTitle("Photo Compare")
        }
    }

    // Follow Instafilter: load the selected photo as data inside a Task.
    func loadImage() {
        Task {
            guard let selectedItem else { return }
            message = ""

            do {
                let data = try await selectedItem.loadTransferable(type: Data.self)
                // Ignore an older download if another photo has been selected.
                guard selectedItem == self.selectedItem else { return }
                guard let data, let uiImage = UIImage(data: data),
                    let ciImage = CIImage(data: data, options: [.applyOrientationProperty: true])
                else {
                    message = "Could not open this photo. Please try another one."
                    return
                }

                originalImage = Image(uiImage: uiImage)
                inputImage = ciImage
                showOriginal = false
                applyProcessing()
            } catch {
                if selectedItem == self.selectedItem {
                    message = "Could not load this photo. Please try again."
                }
            }
        }
    }

    // Keep one filter from the class demo to make the controls simple.
    func applyProcessing() {
        guard let inputImage else { return }
        let filter = CIFilter.sepiaTone()
        filter.inputImage = inputImage
        filter.intensity = Float(filterIntensity)

        guard let outputImage = filter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        else {
            processedImage = nil
            message = "Could not apply the effect. Please choose another photo."
            return
        }

        processedImage = Image(uiImage: UIImage(cgImage: cgImage))
        message = ""
    }
}

#Preview {
    ContentView()
}
