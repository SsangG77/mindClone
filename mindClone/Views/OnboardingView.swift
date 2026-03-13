import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0

    private let pages: [(title: String, subtitle: String, icon: String)] = [
        ("위대한 사람들은\n어떻게 생각했을까?", "역사상 가장 뛰어난 인물들의\n사고방식을 당신의 것으로 만드세요.", "brain.head.profile"),
        ("그들의 메모 방식을\n그대로 따라하세요", "Cornell, Feynman, Elon Musk…\n검증된 프레임워크로 생각을 구조화합니다.", "doc.text.fill"),
        ("Apple Pencil로\n직접 써보세요", "필기와 타이핑을 자유롭게 섞어\n당신만의 노트를 완성하세요.", "pencil.and.scribble"),
        ("지금 시작하세요", "무료 템플릿 3개로\n당신의 뇌를 업그레이드하세요.", "rocket.fill"),
    ]

    var body: some View {
        ZStack {
            PaperPatternBackground()

            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 32) {
                            Spacer()

                            ZStack {
                                Circle()
                                    .fill(MCColor.highlightFallback.opacity(0.3))
                                    .frame(width: 140, height: 140)

                                Image(systemName: pages[index].icon)
                                    .font(.system(size: 64))
                                    .foregroundStyle(MCColor.inkFallback)
                            }

                            VStack(spacing: 16) {
                                Text(pages[index].title)
                                    .font(MCFont.title)
                                    .foregroundStyle(MCColor.inkFallback)
                                    .multilineTextAlignment(.center)

                                Text(pages[index].subtitle)
                                    .font(MCFont.body)
                                    .foregroundStyle(MCColor.pencilFallback)
                                    .multilineTextAlignment(.center)
                            }

                            Spacer()
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))

                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        hasCompletedOnboarding = true
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "다음" : "시작하기")
                        .sketchyButton()
                }
                .buttonStyle(.plain)
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 24)
                .padding(.bottom, 40)

                if currentPage < pages.count - 1 {
                    Button("건너뛰기") {
                        hasCompletedOnboarding = true
                    }
                    .font(MCFont.caption)
                    .foregroundStyle(MCColor.pencilFallback)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
