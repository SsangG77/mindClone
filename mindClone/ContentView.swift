import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(NoteStore.self) private var noteStore

    var body: some View {
        HomeView(noteStore: noteStore)
            .overlay {
                if !hasCompletedOnboarding {
                    CoachMarkOverlayView(hasCompleted: $hasCompletedOnboarding)
                }
            }
    }
}

#Preview {
    ContentView()
        .environment(NoteStore())
}
