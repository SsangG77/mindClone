import SwiftUI

struct CoachMarkOverlayView: View {
    @Binding var hasCompleted: Bool
    @State private var cardFrame: CGRect = .zero
    @State private var appeared = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                // 반투명 검정 배경 + cutout
                coachMarkBackground(in: proxy)

                // 안내 말풍선 + 건너뛰기
                VStack {
                    Spacer()
                        .frame(height: cardFrame.maxY + 16)

                    speechBubble
                        .padding(.horizontal, 24)

                    Spacer()

                    skipButton
                        .padding(.bottom, 48)
                }
            }
            .ignoresSafeArea()
            .opacity(appeared ? 1 : 0)
            .onPreferenceChange(TodayCardFrameKey.self) { frame in
                cardFrame = frame
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                appeared = true
            }
        }
    }

    // MARK: - 배경 (cutout 처리)
    @ViewBuilder
    private func coachMarkBackground(in proxy: GeometryProxy) -> some View {
        let screenRect = CGRect(origin: .zero, size: proxy.size)
        let padding: CGFloat = 8
        let cutout = cardFrame.insetBy(dx: -padding, dy: -padding)

        Canvas { context, size in
            // 전체 어두운 배경
            context.fill(
                Path(screenRect),
                with: .color(.black.opacity(0.55))
            )
            // cutout 영역을 지움 (블렌드모드 사용)
            context.blendMode = .destinationOut
            context.fill(
                Path(roundedRect: cutout, cornerRadius: 16),
                with: .color(.white)
            )
        }
        .compositingGroup()
        .allowsHitTesting(false)

        // cutout 영역 테두리 (하이라이트)
        if cardFrame != .zero {
            RoundedRectangle(cornerRadius: 16)
                .stroke(MCColor.highlightFallback, lineWidth: 2.5)
                .frame(width: cutout.width, height: cutout.height)
                .position(x: cutout.midX, y: cutout.midY)
                .allowsHitTesting(false)
        }
    }

    // MARK: - 말풍선
    private var speechBubble: some View {
        VStack(spacing: 8) {
            // 꼬리 삼각형
            Triangle()
                .fill(MCColor.paperFallback)
                .frame(width: 20, height: 10)
                .rotationEffect(.degrees(180))
                .offset(x: -40)

            HStack(spacing: 10) {
                Image(systemName: "hand.point.up.left.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(MCColor.highlightFallback)

                Text("여기를 눌러 첫 노트를\n만들어보세요!")
                    .font(MCFont.headline)
                    .foregroundStyle(MCColor.inkFallback)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                SketchyRoundedRect(cornerRadius: 14, wobble: 2.5)
                    .fill(MCColor.paperFallback)
            )
            .overlay(
                SketchyRoundedRect(cornerRadius: 14, wobble: 2.5)
                    .stroke(MCColor.inkFallback.opacity(0.3), lineWidth: 1.5)
            )
        }
    }

    // MARK: - 건너뛰기 버튼
    private var skipButton: some View {
        Button {
            withAnimation(.easeIn(duration: 0.25)) {
                hasCompleted = true
            }
        } label: {
            Text("건너뛰기")
                .font(MCFont.subheadline)
                .foregroundStyle(MCColor.paperFallback.opacity(0.85))
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .stroke(MCColor.paperFallback.opacity(0.5), lineWidth: 1)
                )
        }
    }
}

// MARK: - 삼각형 Shape (말풍선 꼬리)
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
