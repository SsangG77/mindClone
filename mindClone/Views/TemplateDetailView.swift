import SwiftUI
import StoreKit

struct TemplateDetailView: View {
    let template: Template
    var noteStore: NoteStore
    @Environment(\.dismiss) private var dismiss
    @Environment(PurchaseStore.self) private var purchaseStore
    @State private var showEditor = false
    @State private var showPurchaseSheet = false
    @State private var isPurchasing = false

    private var isUnlocked: Bool {
        purchaseStore.isUnlocked(template.id)
    }

    var body: some View {
        ZStack {
            PaperPatternBackground()

            VStack(alignment: .leading, spacing: 20) {
                header
                benefitSection
                sectionsPreview
                Spacer()
                startButton
            }
            .padding()
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
        .sheet(isPresented: $showPurchaseSheet) {
            PurchaseSheetView(template: template) {
                showPurchaseSheet = false
                showEditor = true
            }
            .environment(purchaseStore)
            .presentationDetents([.fraction(0.55)])
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
                    Label(template.category.localizedName, systemImage: template.category.icon)
                        .font(MCFont.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            SketchyRoundedRect(cornerRadius: 10, wobble: 1)
                                .fill(MCColor.highlightFallback.opacity(0.3))
                        )
                        .foregroundStyle(MCColor.inkFallback)

                    if isUnlocked {
                        Text(template.isFree ? "무료" : "구매완료")
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
            if isUnlocked {
                showEditor = true
            } else {
                showPurchaseSheet = true
            }
        } label: {
            HStack(spacing: 8) {
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                }
                Text(isUnlocked ? "이 방식으로 메모하기" : "구매 후 메모하기")
            }
            .sketchyButton()
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
    }
}

// MARK: - 구매 시트
struct PurchaseSheetView: View {
    let template: Template
    let onPurchased: () -> Void
    @Environment(PurchaseStore.self) private var purchaseStore
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    @State private var errorMessage: String?
    @State private var isLoadingProducts = false

    var body: some View {
        NavigationStack {
            ZStack {
                PaperPatternBackground()

                VStack(spacing: 20) {
                    // 템플릿 정보
                    HStack(spacing: 14) {
                        Image(systemName: template.systemImageName)
                            .font(.system(size: 32))
                            .foregroundStyle(MCColor.inkFallback)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(template.name)
                                .font(MCFont.title3)
                                .foregroundStyle(MCColor.inkFallback)
                            Text(template.person)
                                .font(MCFont.subheadline)
                                .foregroundStyle(MCColor.pencilFallback)
                        }
                        Spacer()
                    }
                    .padding()
                    .sketchyCard(wobble: 1.5)

                    if purchaseStore.products.isEmpty {
                        ProgressView("상품 불러오는 중...")
                            .font(MCFont.caption)
                    } else {
                        // 개별 구매
                        if let product = purchaseStore.product(for: template.id) {
                            Button {
                                Task { await purchaseSingle(product) }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("이 템플릿만 구매")
                                            .font(MCFont.headline)
                                        Text("한번 구매로 영구 사용")
                                            .font(MCFont.caption)
                                            .foregroundStyle(MCColor.pencilFallback)
                                    }
                                    Spacer()
                                    Text(product.displayPrice)
                                        .font(MCFont.title3)
                                        .fontWeight(.bold)
                                }
                                .sketchyButton()
                            }
                            .buttonStyle(.plain)
                            .disabled(isPurchasing)
                        }

                        // 올인원 팩
                        if let allPack = purchaseStore.allPackProduct {
                            Button {
                                Task { await purchaseAll(allPack) }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("전체 템플릿 언락")
                                            .font(MCFont.headline)
                                        Text("모든 템플릿 영구 사용")
                                            .font(MCFont.caption)
                                            .foregroundStyle(MCColor.pencilFallback)
                                    }
                                    Spacer()
                                    Text(allPack.displayPrice)
                                        .font(MCFont.title3)
                                        .fontWeight(.bold)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity)
                                .background(MCColor.highlightFallback.opacity(0.3))
                                .clipShape(SketchyRoundedRect(cornerRadius: 14, wobble: 3))
                                .overlay(
                                    SketchyRoundedRect(cornerRadius: 14, wobble: 3)
                                        .stroke(MCColor.highlightFallback, lineWidth: 1.5)
                                )
                                .foregroundStyle(MCColor.inkFallback)
                            }
                            .buttonStyle(.plain)
                            .disabled(isPurchasing)
                        }
                    }

                    // 구매 복원
                    Button {
                        Task { await purchaseStore.restorePurchases() }
                    } label: {
                        Text("구매 복원")
                            .font(MCFont.caption)
                            .foregroundStyle(MCColor.pencilFallback)
                    }

                    if let error = errorMessage {
                        Text(error)
                            .font(MCFont.caption)
                            .foregroundStyle(MCColor.eraserFallback)
                    }

                    if isPurchasing {
                        ProgressView()
                    }
                }
                .padding()
            }
            .navigationTitle("템플릿 구매")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("닫기") { dismiss() }
                        .font(MCFont.subheadline)
                }
            }
            .task {
                if purchaseStore.products.isEmpty {
                    await purchaseStore.loadProducts()
                }
            }
        }
    }

    private func purchaseSingle(_ product: Product) async {
        isPurchasing = true
        errorMessage = nil
        do {
            let success = try await purchaseStore.purchase(product)
            if success { onPurchased() }
        } catch {
            errorMessage = "구매에 실패했습니다. 다시 시도해주세요."
        }
        isPurchasing = false
    }

    private func purchaseAll(_ product: Product) async {
        isPurchasing = true
        errorMessage = nil
        do {
            let success = try await purchaseStore.purchase(product)
            if success { onPurchased() }
        } catch {
            errorMessage = "구매에 실패했습니다. 다시 시도해주세요."
        }
        isPurchasing = false
    }
}
