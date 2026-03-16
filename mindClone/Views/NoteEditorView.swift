import SwiftUI
import PencilKit

struct NoteEditorView: View {
    let template: Template
    var noteStore: NoteStore
    @Environment(\.dismiss) private var dismiss

    @State private var note: Note
    @State private var inputMode: InputMode = .pencil
    @State private var canvasView = PKCanvasView()
    @State private var textContents: [String: String] = [:]
    @State private var showSavedAlert = false

    enum InputMode: String, CaseIterable {
        case pencil = "Apple Pencil"
        case typing = "타이핑"

        var icon: String {
            switch self {
            case .pencil: return "pencil.tip"
            case .typing: return "keyboard"
            }
        }
    }

    init(template: Template, noteStore: NoteStore, existingNote: Note? = nil) {
        self.template = template
        self.noteStore = noteStore
        self._note = State(initialValue: existingNote ?? Note(templateId: template.id))
        if let existing = existingNote {
            self._textContents = State(initialValue: existing.textContents)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                MCColor.paperFallback.ignoresSafeArea()

                VStack(spacing: 0) {
                    inputModeToggle
                    sketchyDivider
                    editorContent
                }
            }
            .navigationTitle(template.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("닫기") { dismiss() }
                        .font(MCFont.subheadline)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        saveNote()
                    } label: {
                        Image(systemName: "square.and.arrow.down.fill")
                            .foregroundStyle(MCColor.inkFallback)
                    }
                }
            }
            .alert("저장 완료", isPresented: $showSavedAlert) {
                Button("확인") { dismiss() }
            } message: {
                Text("노트가 보관함에 저장되었습니다.")
            }
        }
    }

    private var sketchyDivider: some View {
        SketchyUnderline()
            .stroke(MCColor.inkFallback.opacity(0.2), lineWidth: 1)
            .frame(height: 4)
            .padding(.horizontal)
    }

    private var inputModeToggle: some View {
        HStack(spacing: 0) {
            ForEach(InputMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { inputMode = mode }
                } label: {
                    Label(mode.rawValue, systemImage: mode.icon)
                        .font(MCFont.subheadline)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            SketchyRoundedRect(cornerRadius: 10, wobble: 1.5)
                                .fill(inputMode == mode ? MCColor.inkFallback : .clear)
                        )
                        .foregroundStyle(inputMode == mode ? MCColor.paperFallback : MCColor.inkFallback)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(
            SketchyRoundedRect(cornerRadius: 12, wobble: 1.5)
                .stroke(MCColor.inkFallback.opacity(0.3), lineWidth: 1)
        )
        .padding()
    }

    @ViewBuilder
    private var editorContent: some View {
        switch inputMode {
        case .pencil:
            pencilCanvas
        case .typing:
            TemplateTypingLayout(template: template, textContents: $textContents)
        }
    }

    private var pencilCanvas: some View {
        GeometryReader { geo in
            ZStack {
                PencilCanvasView(canvasView: $canvasView, drawing: note.drawingData)
                    .ignoresSafeArea(edges: .bottom)

                TemplateGuideOverlay(template: template, size: geo.size)
            }
        }
    }

    private func saveNote() {
        var updatedNote = note
        updatedNote.textContents = textContents
        updatedNote.drawingData = canvasView.drawing.dataRepresentation()
        updatedNote.updatedAt = Date()
        if updatedNote.title.isEmpty {
            updatedNote.title = "\(template.name) — \(updatedNote.formattedDate)"
        }
        noteStore.save(updatedNote)
        showSavedAlert = true
    }
}

struct PencilCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    let drawing: Data?

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = UIDevice.current.userInterfaceIdiom == .pad ? .pencilOnly : .default
        canvasView.backgroundColor = UIColor(MCColor.paperFallback)
        canvasView.isOpaque = false

        // 검정색 펜으로 기본 설정
        let blackInk = PKInkingTool(.pen, color: .black, width: 3)
        canvasView.tool = blackInk

        let toolPicker = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()

        // PKToolPicker에 기본 도구 오버라이드 (검정 펜 + 지우개 포함)
        context.coordinator.toolPicker = toolPicker

        if let data = drawing, let loadedDrawing = try? PKDrawing(data: data) {
            canvasView.drawing = loadedDrawing
        }

        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var toolPicker: PKToolPicker?
    }
}
