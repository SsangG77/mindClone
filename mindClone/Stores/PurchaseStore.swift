import StoreKit

@Observable
class PurchaseStore {
    private(set) var products: [Product] = []
    private(set) var purchasedProductIDs: Set<String> = []
    private var updateTask: Task<Void, Never>?

    // 상품 ID 정의
    static let allTemplatesPack = "com.sangjin.mindClone.alltemplates"

    static let templateProductIDs: [String: String] = [
        "gtd": "com.sangjin.mindClone.template.gtd",
        "eisenhower": "com.sangjin.mindClone.template.eisenhower",
        "davinci": "com.sangjin.mindClone.template.davinci",
        "franklin": "com.sangjin.mindClone.template.franklin",
        "buffett": "com.sangjin.mindClone.template.buffett",
        "thinkweek": "com.sangjin.mindClone.template.thinkweek",
        "zettelkasten": "com.sangjin.mindClone.template.zettelkasten",
        "threecircle": "com.sangjin.mindClone.template.threecircle",
        "bulletjournal": "com.sangjin.mindClone.template.bulletjournal",
        "para": "com.sangjin.mindClone.template.para",
    ]

    private var allProductIDs: Set<String> {
        var ids = Set(Self.templateProductIDs.values)
        ids.insert(Self.allTemplatesPack)
        return ids
    }

    init() {
        updateTask = listenForTransactions()
        Task { await loadProducts() }
        Task { await restorePurchases() }
    }

    deinit {
        updateTask?.cancel()
    }

    // MARK: - 템플릿 잠금 확인
    func isUnlocked(_ templateId: String) -> Bool {
        // 무료 템플릿
        if Template.template(for: templateId)?.isFree == true { return true }
        // 올인원 팩 구매
        if purchasedProductIDs.contains(Self.allTemplatesPack) { return true }
        // 개별 구매
        if let productID = Self.templateProductIDs[templateId] {
            return purchasedProductIDs.contains(productID)
        }
        return false
    }

    // MARK: - 상품 불러오기
    func loadProducts() async {
        do {
            products = try await Product.products(for: allProductIDs)
                .sorted { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    // MARK: - 구매
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            purchasedProductIDs.insert(transaction.productID)
            await transaction.finish()
            return true
        case .userCancelled:
            return false
        case .pending:
            return false
        @unknown default:
            return false
        }
    }

    func purchaseTemplate(_ templateId: String) async throws -> Bool {
        guard let productID = Self.templateProductIDs[templateId],
              let product = products.first(where: { $0.id == productID }) else {
            return false
        }
        return try await purchase(product)
    }

    func purchaseAllPack() async throws -> Bool {
        guard let product = products.first(where: { $0.id == Self.allTemplatesPack }) else {
            return false
        }
        return try await purchase(product)
    }

    // MARK: - 구매 복원
    func restorePurchases() async {
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
    }

    // MARK: - 거래 감시
    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached {
            for await result in Transaction.updates {
                if let transaction = try? self.checkVerified(result) {
                    self.purchasedProductIDs.insert(transaction.productID)
                    await transaction.finish()
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let value):
            return value
        }
    }

    // MARK: - 헬퍼
    func product(for templateId: String) -> Product? {
        guard let productID = Self.templateProductIDs[templateId] else { return nil }
        return products.first { $0.id == productID }
    }

    var allPackProduct: Product? {
        products.first { $0.id == Self.allTemplatesPack }
    }

    enum StoreError: Error {
        case failedVerification
    }
}
