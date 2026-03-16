import SwiftUI

// MARK: - 오늘의 추천 카드 위치 전달용 PreferenceKey
struct TodayCardFrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct HomeView: View {
    @State var noteStore: NoteStore
    @State private var selectedCategory: TemplateCategory?
    @State private var selectedTemplate: Template?
    @State private var showTemplateRequest = false

    private var filteredTemplates: [Template] {
        if let category = selectedCategory {
            return Template.all.filter { $0.category == category }
        }
        return Template.all
    }

    private var todayTemplate: Template {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return Template.all[dayOfYear % Template.all.count]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperPatternBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        todaySection
                        categoryFilter
                        templateGrid
                        templateRequestSection
                    }
                    .padding()
                }
            }
            .navigationTitle("MindClone")
            .sheet(item: $selectedTemplate) { template in
                NavigationStack {
                    TemplateDetailView(template: template, noteStore: noteStore)
                }
                .presentationDetents([.large])
            }
            .sheet(isPresented: $showTemplateRequest) {
                TemplateRequestView()
            }
        }
    }

    private var todaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Text("~")
                    .font(MCFont.title3)
                    .foregroundStyle(MCColor.eraserFallback)
                Text("오늘의 추천")
                    .font(MCFont.headline)
                    .foregroundStyle(MCColor.pencilFallback)
            }

            Button {
                selectedTemplate = todayTemplate
            } label: {
                HStack(spacing: 16) {
                    ZStack {
                        SketchyRoundedRect(cornerRadius: 12, wobble: 2)
                            .fill(MCColor.highlightFallback.opacity(0.4))
                            .frame(width: 72, height: 72)

                        Image(systemName: todayTemplate.systemImageName)
                            .font(.system(size: 32))
                            .foregroundStyle(MCColor.inkFallback)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(todayTemplate.name)
                            .font(MCFont.title2)
                            .foregroundStyle(MCColor.inkFallback)
                        Text(todayTemplate.person)
                            .font(MCFont.subheadline)
                            .foregroundStyle(MCColor.pencilFallback)
                        Text(todayTemplate.personDescription)
                            .font(MCFont.caption)
                            .foregroundStyle(MCColor.pencilFallback.opacity(0.7))
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(MCColor.pencilFallback)
                }
                .padding()
                .sketchyCard(wobble: 2.5)
            }
            .buttonStyle(.plain)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: TodayCardFrameKey.self,
                            value: geo.frame(in: .global)
                        )
                }
            )
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                HandDrawnChip(title: "전체", icon: "square.grid.2x2", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }

                ForEach(TemplateCategory.allCases) { category in
                    HandDrawnChip(title: category.localizedName, icon: category.icon, isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
        }
    }

    private var templateRequestSection: some View {
        Button {
            showTemplateRequest = true
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    SketchyRoundedRect(cornerRadius: 10, wobble: 1.5)
                        .fill(MCColor.eraserFallback.opacity(0.2))
                        .frame(width: 48, height: 48)

                    Image(systemName: "plus.bubble.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(MCColor.eraserFallback)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("원하는 템플릿이 없나요?")
                        .font(MCFont.headline)
                        .foregroundStyle(MCColor.inkFallback)
                    Text("직접 요청해보세요!")
                        .font(MCFont.caption)
                        .foregroundStyle(MCColor.pencilFallback)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(MCColor.pencilFallback)
            }
            .padding()
            .sketchyCard(wobble: 2)
        }
        .buttonStyle(.plain)
    }

    private var templateGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 200), spacing: 16)], spacing: 16) {
            ForEach(filteredTemplates) { template in
                HandDrawnTemplateCard(template: template) {
                    selectedTemplate = template
                }
            }
        }
    }
}

// MARK: - 손그림 스타일 칩
struct HandDrawnChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(MCFont.caption)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    SketchyRoundedRect(cornerRadius: 16, wobble: 1.5)
                        .fill(isSelected ? MCColor.inkFallback : MCColor.paperDarkFallback)
                )
                .foregroundStyle(isSelected ? MCColor.paperFallback : MCColor.inkFallback)
                .overlay(
                    SketchyRoundedRect(cornerRadius: 16, wobble: 1.5)
                        .stroke(MCColor.inkFallback.opacity(0.4), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 손그림 스타일 템플릿 카드
struct HandDrawnTemplateCard: View {
    let template: Template
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: template.systemImageName)
                        .font(MCFont.title2)
                        .foregroundStyle(MCColor.inkFallback)

                    Spacer()

                    if !template.isFree {
                        Image(systemName: "lock.fill")
                            .font(MCFont.caption2)
                            .foregroundStyle(MCColor.pencilFallback)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(template.name)
                        .font(MCFont.headline)
                        .foregroundStyle(MCColor.inkFallback)
                        .lineLimit(1)

                    Text(template.person)
                        .font(MCFont.caption)
                        .foregroundStyle(MCColor.pencilFallback)
                        .lineLimit(1)
                }

                // 손그림 밑줄
                SketchyUnderline()
                    .stroke(MCColor.inkFallback.opacity(0.2), lineWidth: 1)
                    .frame(height: 4)

                Text(template.personDescription)
                    .font(MCFont.caption2)
                    .foregroundStyle(MCColor.pencilFallback.opacity(0.7))
                    .lineLimit(2)
            }
            .padding()
            .sketchyCard()
        }
        .buttonStyle(.plain)
    }
}
