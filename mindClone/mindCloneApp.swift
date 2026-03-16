import SwiftUI

@main
struct mindCloneApp: App {
    @State private var noteStore = NoteStore()
    @State private var purchaseStore = PurchaseStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(noteStore)
                .environment(purchaseStore)
        }
    }
}
