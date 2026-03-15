import SwiftUI

struct TemplateRequestView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var templateName = ""
    @State private var personName = ""
    @State private var selectedCategory: TemplateCategory?
    @State private var description = ""
    @State private var showConfirmation = false

    private var canSubmit: Bool {
        !templateName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperPatternBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        nameSection
                        personSection
                        categorySection
                        descriptionSection
                        submitButton
                    }
                    .padding()
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("템플릿 요청")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("닫기") { dismiss() }
                        .font(MCFont.subheadline)
                        .foregroundStyle(MCColor.pencilFallback)
                }
            }
            .alert("요청 완료", isPresented: $showConfirmation) {
                Button("확인") { dismiss() }
            } message: {
                Text("템플릿 요청이 접수되었습니다.\n검토 후 추가될 예정이에요!")
            }
        }
    }

    // MARK: - 템플릿 이름
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader(icon: "~", title: "템플릿 이름")

            TextField("예: 파인만 학습법", text: $templateName)
                .font(MCFont.body)
                .padding(14)
                .background(MCColor.paperDarkFallback.opacity(0.5))
                .clipShape(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5))
                .overlay(
                    SketchyRoundedRect(cornerRadius: 10, wobble: 1.5)
                        .stroke(MCColor.inkFallback.opacity(0.15), lineWidth: 1)
                )
        }
    }

    // MARK: - 인물/출처
    private var personSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader(icon: "*", title: "인물 또는 출처")

            TextField("예: 리처드 파인만", text: $personName)
                .font(MCFont.body)
                .padding(14)
                .background(MCColor.paperDarkFallback.opacity(0.5))
                .clipShape(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5))
                .overlay(
                    SketchyRoundedRect(cornerRadius: 10, wobble: 1.5)
                        .stroke(MCColor.inkFallback.opacity(0.15), lineWidth: 1)
                )
        }
    }

    // MARK: - 카테고리 선택
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader(icon: "~", title: "카테고리")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(TemplateCategory.allCases) { category in
                        HandDrawnChip(
                            title: category.rawValue,
                            icon: category.icon,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
            }
        }
    }

    // MARK: - 설명
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader(icon: "*", title: "어떤 템플릿인가요?")

            ZStack(alignment: .topLeading) {
                TextEditor(text: $description)
                    .font(MCFont.body)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 120)
                    .padding(12)
                    .background(MCColor.paperDarkFallback.opacity(0.5))
                    .clipShape(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5))
                    .overlay(
                        SketchyRoundedRect(cornerRadius: 10, wobble: 1.5)
                            .stroke(MCColor.inkFallback.opacity(0.15), lineWidth: 1)
                    )

                if description.isEmpty {
                    Text("이 템플릿이 어떤 상황에서 유용한지,\n어떤 구성이면 좋을지 자유롭게 적어주세요.")
                        .font(MCFont.body)
                        .foregroundStyle(MCColor.pencilFallback.opacity(0.4))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .allowsHitTesting(false)
                }
            }
        }
    }

    // MARK: - 제출 버튼
    private var submitButton: some View {
        Button {
            showConfirmation = true
        } label: {
            Text("요청 보내기")
                .sketchyButton()
        }
        .buttonStyle(.plain)
        .disabled(!canSubmit)
        .opacity(canSubmit ? 1 : 0.5)
    }

    // MARK: - 섹션 헤더 헬퍼
    private func sectionHeader(icon: String, title: String) -> some View {
        HStack(spacing: 4) {
            Text(icon)
                .font(MCFont.title3)
                .foregroundStyle(MCColor.eraserFallback)
            Text(title)
                .font(MCFont.headline)
                .foregroundStyle(MCColor.inkFallback)
        }
    }
}
