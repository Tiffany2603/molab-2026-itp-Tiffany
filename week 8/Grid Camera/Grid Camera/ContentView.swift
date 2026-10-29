import SwiftUI

struct ContentView: View {
    @State private var model = CameraModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ZStack {
                        Color.black
                        if let image = model.previewImage {
                            Image(image, scale: 1, orientation: .up, label: Text("Nine-filter camera preview"))
                                .resizable().scaledToFit()
                        } else {
                            Text("Camera preview appears here")
                                .foregroundStyle(.white)
                        }
                    }
                    .aspectRatio(3.0 / 4.0, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Button("Shuffle Filters", systemImage: "shuffle") {
                        model.shuffleFilters()
                    }
                    .buttonStyle(.bordered)
                    .disabled(!model.isReady || model.isSaving)

                    Button {
                        if model.isRecording { model.stopRecording() }
                        else { model.startRecording() }
                    } label: {
                        Label(model.isRecording ? "Stop Recording" : "Start Recording",
                            systemImage: model.isRecording ? "stop.circle.fill" : "record.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(model.isRecording ? .red : .blue)
                    .disabled(!model.isReady || model.isSaving)

                    Text(model.message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    if let url = model.exportURL {
                        ShareLink("Share Last Video", item: url)
                            .disabled(model.isSaving || model.isRecording)
                    }
                }
                .padding()
            }
            .navigationTitle("Grid Camera")
        }
        .onAppear { model.startCamera() }
        .onDisappear { model.stopCamera() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { model.startCamera() }
            else if phase == .background { model.stopCamera() }
        }
    }
}

#Preview {
    ContentView()
}
