# Study Timer Records

A SwiftUI study timer that saves session history to a local JSON file. It extends the Week05 app with Save Session and History.

## Run

1. Open `Study Timer Records/Study Timer Records.xcodeproj` in Xcode.
2. Select the `Study Timer Records` scheme and an installed iPhone Simulator.
3. Click Run.

Minimum iOS version: 17. A physical phone is optional. For a physical device, select a development team in Signing & Capabilities.

## Use

1. Open Timer from Home and click Start.
2. After counting some seconds, click Save Session. The timer pauses, saves its duration, and resets to zero.
3. Return Home and open History to see the saved duration and date.
4. Save another session to add another record. The newest record is displayed first.
5. Stop and relaunch the app to read the records again from the JSON file.
6. Settings retains the name-saving feature from Week05.

Save Session is disabled for a zero duration. Reset clears only the current timer. Leaving the timer without saving does not add a record to History.

## Files

- `Study Timer Records/Study Timer Records/ContentView.swift` contains Home, Timer, History, and Settings.
- `Study Timer Records/Study Timer Records/StudyRecord.swift` defines the record and the JSON save/load functions.
- `Study Timer Records/Study Timer Records/Study_Timer_RecordsApp.swift` is the app entry point.
- `Learning_Record.md` contains the weekly notes and summary.

## Data

Names use AppStorage. Session records use `studyRecords.json` in this app's Documents directory. Each record has an ID, a date, and a duration in seconds. The current timer value is temporary until Save Session is clicked.

The record count on Home reflects the loaded history. The first launch starts with no records. Read errors disable saving to protect the existing file; write errors keep the timer value and show a message.

## Course Reference

[Week06 homework](https://github.com/molab-itp/content-2026-itp/blob/main/weeks/06_data.md#homework-week06)

The project adapts the Documents-directory, Codable, JSONEncoder, and JSONDecoder approach in [06-ImageEditDemoJSON](https://github.com/molab-itp/06-ImageEditDemoJSON) and [06-ChipsSaveJSON](https://github.com/molab-itp/06-ChipsSaveJSON). The helpers use a concrete record array to keep the code small.

## Verification

iOS device-target compilation passed without code signing. The JSON helpers were checked with temporary files for an empty first load, saving and reloading multiple sessions, preserving IDs and dates, and reporting invalid JSON and file-write errors.
