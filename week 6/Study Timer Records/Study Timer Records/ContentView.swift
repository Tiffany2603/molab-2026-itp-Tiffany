import SwiftUI
import Combine

// Home owns the shared records array.
struct ContentView: View {
    @AppStorage("userName") private var userName = ""
    @State private var records: [StudyRecord] = []
    @State private var canSave = false
    @State private var message = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "timer")
                    .font(.system(size: 70))
                    .foregroundStyle(.blue)
                Text("Study Timer Records")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                Text(userName.isEmpty ? "Hello!" : "Hello, \(userName)!")
                    .foregroundStyle(.secondary)

                NavigationLink("Open Timer") {
                    TimerView(records: $records, canSave: canSave)
                }
                .buttonStyle(.borderedProminent)
                NavigationLink("History (\(records.count))") {
                    HistoryView(records: records)
                }
                NavigationLink("Settings") {
                    SettingsView()
                }
                Text(message)
                    .foregroundStyle(.red)
            }
            .padding()
            .navigationTitle("Home")
            .onAppear {
                do {
                    records = try loadRecords(from: recordsFileURL())
                    canSave = true
                    message = ""
                } catch {
                    // Protect an unreadable file from being overwritten.
                    canSave = false
                    message = "Could not load saved records. Saving is disabled."
                }
            }
        }
    }
}

struct TimerView: View {
    @Binding var records: [StudyRecord]
    let canSave: Bool
    @State private var seconds = 0
    @State private var isRunning = false
    @State private var message = ""
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 24) {
            Text(String(format: "%02d:%02d", seconds / 60, seconds % 60))
                .font(.system(size: 60, design: .monospaced))
            Text(isRunning ? "Timer is running" : "Timer is paused")
                .foregroundStyle(.secondary)

            Button(isRunning ? "Pause" : (seconds == 0 ? "Start" : "Resume")) {
                isRunning.toggle()
                message = ""
            }
            .buttonStyle(.borderedProminent)
            Button("Reset") {
                seconds = 0
                isRunning = false
                message = ""
            }
            .buttonStyle(.bordered)

            Button("Save Session") {
                isRunning = false
                var updatedRecords = records
                updatedRecords.append(StudyRecord(date: .now, seconds: seconds))
                do {
                    // Update the screen only after the file is saved successfully.
                    try saveRecords(updatedRecords, to: recordsFileURL())
                    records = updatedRecords
                    seconds = 0
                    message = "Session saved. Open History from Home to view it."
                } catch {
                    message = "Could not save. Your timer value is kept; please try again."
                }
            }
            .buttonStyle(.bordered)
            .disabled(seconds == 0 || !canSave)
            Text(message)
                .font(.footnote)
                .multilineTextAlignment(.center)
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

struct HistoryView: View {
    let records: [StudyRecord]

    var body: some View {
        List {
            if records.isEmpty {
                Text("No saved sessions yet.")
            }
            ForEach(records.reversed()) { record in
                VStack(alignment: .leading, spacing: 6) {
                    Text(String(format: "%02d:%02d", record.seconds / 60, record.seconds % 60))
                        .font(.title2)
                    Text(record.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("History")
    }
}

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
