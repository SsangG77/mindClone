import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct TemplateRequestView: View {
    var body: some View {
        SafariView(url: URL(string: "https://sssangg719.notion.site/325ee035a51f80d3b58ec133a46cd931?pvs=105")!)
            .ignoresSafeArea()
    }
}
