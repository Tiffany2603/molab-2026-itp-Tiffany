import Foundation

// Codable lets Swift convert records to and from JSON.
struct StudyRecord: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var seconds: Int
}

// Follow the class demos: save a JSON file in the app's Documents directory.
func recordsFileURL() throws -> URL {
    let directory = try FileManager.default.url(
        for: .documentDirectory, in: .userDomainMask,
        appropriateFor: nil, create: true)
    return directory.appendingPathComponent("studyRecords.json")
}

func loadRecords(from url: URL) throws -> [StudyRecord] {
    // A first launch has no saved file yet.
    if !FileManager.default.fileExists(atPath: url.path) {
        return []
    }
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode([StudyRecord].self, from: data)
}

func saveRecords(_ records: [StudyRecord], to url: URL) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    encoder.dateEncodingStrategy = .iso8601
    let data = try encoder.encode(records)
    try data.write(to: url, options: .atomic)
}
