import SwiftUI
import Combine

// Page 1: the home page. AppStorage keeps the name after the app closes.
struct ContentView: View {
    @AppStorage("userName") private var userName = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "timer")
                    .font(.system(size: 70))
                    .foregroundStyle(.blue)

                Text("Study Timer")
                    .font(.largeTitle)

                Text(userName.isEmpty ? "Hello!" : "Hello, \(userName)!")
                    .foregroundStyle(.secondary)

                NavigationLink("Open Timer") {
                    TimerView()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink("Settings") {
                    SettingsView()
                }
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

// Page 2: the timer page.
struct TimerView: View {
    @State private var seconds = 0
    @State private var isRunning = false

    // Send an event every second.
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 24) {
            // Convert total seconds into minutes and seconds.
            Text(String(format: "%02d:%02d", seconds / 60, seconds % 60))
                .font(.system(size: 60, design: .monospaced))

            Text(isRunning ? "Timer is running" : "Timer is paused")
                .foregroundStyle(.secondary)

            Button(isRunning ? "Pause" : (seconds == 0 ? "Start" : "Resume")) {
                isRunning.toggle()
            }
            .buttonStyle(.borderedProminent)

            Button("Reset") {
                seconds = 0
                isRunning = false
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Timer")
        .onReceive(timer) { _ in
            if isRunning {
                seconds += 1
            }
        }
        .onDisappear {
            isRunning = false
        }
    }
}

// Page 3: change the saved name using the same storage key as the home page.
struct SettingsView: View {
    @AppStorage("userName") private var userName = ""

    var body: some View {
        Form {
            Section("Your name") {
                TextField("Enter your name", text: $userName)
            }
            Text("Your name is saved automatically, even when you close the app.")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    ContentView()
}
