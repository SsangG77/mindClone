import SwiftUI

struct ContentView: View {
    @Environment(NoteStore.self) private var noteStore

    var body: some View {
        TabView {
            Tab("템플릿", systemImage: "square.grid.2x2") {
                HomeView(noteStore: noteStore)
            }

            Tab("노트", systemImage: "tray.full.fill") {
                NavigationStack {
                    NotesLibraryView(noteStore: noteStore)
                }
            }
        }
        .tint(MCColor.inkFallback)
    }
}

#Preview {
    ContentView()
        .environment(NoteStore())
        .environment(PurchaseStore())
}
