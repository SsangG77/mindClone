import SwiftUI

@main
struct mindCloneApp: App {
    @State private var noteStore = NoteStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(noteStore)
        }
    }
}
