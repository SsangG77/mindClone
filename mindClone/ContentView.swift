import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(NoteStore.self) private var noteStore

    var body: some View {
        if hasCompletedOnboarding {
            HomeView(noteStore: noteStore)
        } else {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}

#Preview {
    ContentView()
        .environment(NoteStore())
}
