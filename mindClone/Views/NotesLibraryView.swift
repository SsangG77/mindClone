import SwiftUI

struct NotesLibraryView: View {
    var noteStore: NoteStore
    @State private var searchText = ""
    @State private var filterTemplateId: String?
    @State private var selectedNote: Note?

    private var filteredNotes: [Note] {
        var result = noteStore.notes

        if let templateId = filterTemplateId {
            result = result.filter { $0.templateId == templateId }
        }

        if !searchText.isEmpty {
            result = result.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText)
                || note.textContents.values.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }

        return result
    }

    private var usedTemplateIds: [String] {
        Array(Set(noteStore.notes.map(\.templateId))).sorted()
    }

    var body: some View {
        ZStack {
            PaperPatternBackground()

            VStack(spacing: 0) {
                if !usedTemplateIds.isEmpty {
                    templateFilter
                    SketchyUnderline()
                        .stroke(MCColor.inkFallback.opacity(0.15), lineWidth: 1)
                        .frame(height: 4)
                        .padding(.horizontal)
                }

                if filteredNotes.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 48))
                            .foregroundStyle(MCColor.pencilFallback)

                        Text("노트가 없습니다")
                            .font(MCFont.title3)
                            .foregroundStyle(MCColor.inkFallback)

                        Text("템플릿을 선택해서 첫 번째 노트를 작성해보세요.")
                            .font(MCFont.body)
                            .foregroundStyle(MCColor.pencilFallback)
                    }
                    Spacer()
                } else {
                    notesList
                }
            }
        }
        .navigationTitle("노트 보관함")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "노트 검색")
        .fullScreenCover(item: $selectedNote) { note in
            if let template = Template.template(for: note.templateId) {
                NoteEditorView(template: template, noteStore: noteStore, existingNote: note)
            }
        }
    }

    private var templateFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                HandDrawnChip(title: "전체", icon: "square.grid.2x2", isSelected: filterTemplateId == nil) {
                    filterTemplateId = nil
                }

                ForEach(usedTemplateIds, id: \.self) { templateId in
                    if let template = Template.template(for: templateId) {
                        HandDrawnChip(title: template.name, icon: template.systemImageName, isSelected: filterTemplateId == templateId) {
                            filterTemplateId = templateId
                        }
                    }
                }
            }
            .padding()
        }
    }

    private var notesList: some View {
        List {
            ForEach(filteredNotes) { note in
                Button {
                    selectedNote = note
                } label: {
                    HandDrawnNoteRow(note: note)
                }
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        noteStore.delete(note)
                    } label: {
                        Label("삭제", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

struct HandDrawnNoteRow: View {
    let note: Note

    var body: some View {
        HStack(spacing: 14) {
            if let template = Template.template(for: note.templateId) {
                ZStack {
                    SketchyRoundedRect(cornerRadius: 8, wobble: 1)
                        .fill(MCColor.highlightFallback.opacity(0.3))
                        .frame(width: 44, height: 44)

                    Image(systemName: template.systemImageName)
                        .font(MCFont.title3)
                        .foregroundStyle(MCColor.inkFallback)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(note.title)
                    .font(MCFont.headline)
                    .foregroundStyle(MCColor.inkFallback)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(note.templateName)
                        .font(MCFont.caption)
                        .foregroundStyle(MCColor.eraserFallback)

                    Text("·")
                        .foregroundStyle(MCColor.pencilFallback)

                    Text(note.formattedDate)
                        .font(MCFont.caption)
                        .foregroundStyle(MCColor.pencilFallback)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(MCFont.caption2)
                .foregroundStyle(MCColor.pencilFallback)
        }
        .padding()
        .sketchyCard(wobble: 1.5)
    }
}
