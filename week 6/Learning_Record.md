# Week 06 Learning Record

Learning resources: [Week06 — Local Data 2, More SwiftUI](https://github.com/molab-itp/content-2026-itp/blob/main/weeks/06_data.md), [06-ImageEditDemoJSON](https://github.com/molab-itp/06-ImageEditDemoJSON), [06-ChipsSaveJSON](https://github.com/molab-itp/06-ChipsSaveJSON)

Goal: Add JSON file saving and loading to the existing navigation app.

Project: **Study Timer Records**

## Code Questions and Notes

### Representing a study session

Each ***StudyRecord*** contains an ***id***, a ***date***, and a ***seconds*** value. ***Codable*** lets Swift encode and decode these fields, while ***Identifiable*** gives the list a stable identity for each record. This is similar to an array of objects in a p5.js sketch, but the Swift fields have declared types.

### Sharing records between pages

Home owns the records array using ***@State***. The timer receives ***$records*** through ***@Binding***, so it can update the same array after saving. History reads the array and displays the newest sessions first. This avoids keeping separate copies of the history in different pages.

### Choosing a file location

***recordsFileURL()*** locates the app's Documents directory and adds the filename ***studyRecords.json***. This follows the file-location approach in the class JSON demos. The file belongs to the app's local storage; it does not require a server or internet connection.

### Saving and loading JSON

***saveRecords*** uses ***JSONEncoder*** to turn the array into JSON data and writes it to the file. ***loadRecords*** reads the file and uses ***JSONDecoder*** to restore the array. The two steps are similar to JavaScript's ***JSON.stringify*** and ***JSON.parse***, with Swift's ***Codable*** describing the data structure. Dates use the same ISO 8601 format during encoding and decoding.

### Saving a timer session

Save Session pauses the timer and adds its current duration to a proposed updated array. Only after writing the file successfully does the app update the shared history and reset the timer. The button is disabled when the duration is zero, which prevents empty records and immediate duplicate saves.

### Missing files and errors

On the first launch, a missing file means an empty history. If an existing file cannot be read, ***do*** and ***catch*** handle the error, and saving is disabled so the file is not replaced with an empty history. If saving fails, the current timer value is kept for another attempt.

### Difference from Week05

Week05 uses ***@AppStorage*** for one simple name setting. Week06 keeps that feature and adds a JSON file containing an array of study sessions. The current timer still uses temporary ***@State***; only sessions saved with Save Session become part of the persistent history.

## Final Project Direction

The final-project direction continues to focus on phone portability and sensor-based tools for daily life. Local data saving could help a small everyday assistant keep useful records from its tools. The specific sensor features remain a topic for further exploration.

## Weekly Summary

This week's app extends the timer with Save Session and History. It connects a typed data model, shared view state, and JSON file storage. The new feature demonstrates both saving records and loading them again, while retaining the name setting and navigation from the previous project.
