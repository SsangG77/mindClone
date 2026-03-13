import Foundation

@Observable
class NoteStore {
    var notes: [Note] = []

    private let savePath: URL = {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("mindclone_notes.json")
    }()

    init() {
        load()
    }

    func save(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        } else {
            notes.insert(note, at: 0)
        }
        persist()
    }

    func delete(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        persist()
    }

    func notes(for templateId: String) -> [Note] {
        notes.filter { $0.templateId == templateId }
    }

    private func persist() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: savePath, options: .atomic)
        } catch {
            print("Failed to save notes: \(error)")
        }
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: savePath.path) else { return }
        do {
            let data = try Data(contentsOf: savePath)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("Failed to load notes: \(error)")
        }
    }
}
