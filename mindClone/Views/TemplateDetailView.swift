import SwiftUI

struct TemplateDetailView: View {
    let template: Template
    var noteStore: NoteStore
    @Environment(\.dismiss) private var dismiss
    @State private var showEditor = false

    var body: some View {
        ZStack {
            PaperPatternBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    benefitSection
                    sectionsPreview
                    startButton
                }
                .padding()
            }
        }
        .navigationTitle(template.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("닫기") { dismiss() }
                    .font(MCFont.subheadline)
            }
        }
        .fullScreenCover(isPresented: $showEditor) {
            NoteEditorView(template: template, noteStore: noteStore)
        }
    }

    private var header: some View {
        HStack(spacing: 20) {
            ZStack {
                SketchyRoundedRect(cornerRadius: 18, wobble: 3)
                    .fill(MCColor.highlightFallback.opacity(0.4))
                    .frame(width: 96, height: 96)
                SketchyRoundedRect(cornerRadius: 18, wobble: 3)
                    .stroke(MCColor.inkFallback.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 96, height: 96)

                Image(systemName: template.systemImageName)
                    .font(.system(size: 42))
                    .foregroundStyle(MCColor.inkFallback)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(template.person)
                    .font(MCFont.title)
                    .foregroundStyle(MCColor.inkFallback)

                Text(template.personDescription)
                    .font(MCFont.body)
                    .foregroundStyle(MCColor.pencilFallback)

                HStack(spacing: 6) {
                    Label(template.category.rawValue, systemImage: template.category.icon)
                        .font(MCFont.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            SketchyRoundedRect(cornerRadius: 10, wobble: 1)
                                .fill(MCColor.highlightFallback.opacity(0.3))
                        )
                        .foregroundStyle(MCColor.inkFallback)

                    if template.isFree {
                        Text("무료")
                            .font(MCFont.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                SketchyRoundedRect(cornerRadius: 10, wobble: 1)
                                    .fill(Color.green.opacity(0.2))
                            )
                            .foregroundStyle(.green)
                    }
                }
            }
        }
    }

    private var benefitSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text("*")
                    .font(MCFont.title3)
                    .foregroundStyle(MCColor.eraserFallback)
                Text("이 방식을 쓰면?")
                    .font(MCFont.headline)
                    .foregroundStyle(MCColor.inkFallback)
            }

            Text(template.benefit)
                .font(MCFont.body)
                .foregroundStyle(MCColor.pencilFallback)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .sketchyCard(wobble: 1.5)
        }
    }

    private var sectionsPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text("~")
                    .font(MCFont.title3)
                    .foregroundStyle(MCColor.eraserFallback)
                Text("템플릿 구조")
                    .font(MCFont.headline)
                    .foregroundStyle(MCColor.inkFallback)
            }

            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(template.sections.enumerated()), id: \.element.id) { index, section in
                    HStack(spacing: 12) {
                        // 손글씨 번호
                        Text("\(index + 1)")
                            .font(MCFont.title3)
                            .foregroundStyle(MCColor.eraserFallback)
                            .frame(width: 28)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(section.title)
                                .font(MCFont.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(MCColor.inkFallback)
                            Text(section.placeholder)
                                .font(MCFont.caption)
                                .foregroundStyle(MCColor.pencilFallback.opacity(0.7))
                        }
                    }
                    .padding(.vertical, 10)

                    if index < template.sections.count - 1 {
                        SketchyUnderline()
                            .stroke(MCColor.inkFallback.opacity(0.1), lineWidth: 1)
                            .frame(height: 4)
                    }
                }
            }
            .padding()
            .sketchyCard(wobble: 1.5)
        }
    }

    private var startButton: some View {
        Button {
            showEditor = true
        } label: {
            Text("이 방식으로 메모하기")
                .sketchyButton()
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
    }
}
