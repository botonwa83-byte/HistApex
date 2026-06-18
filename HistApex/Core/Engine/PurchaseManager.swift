import StoreKit
import SwiftUI

// MARK: - 完整功能解锁 IAP（StoreKit 2 · 一次性买断）
//
// 产品 ID：com.histapex.app.full_unlock（¥22 一次性买断，价格以 App Store Connect 为准）
// 免费档：初中通史主线 9 关 + 少量史学武器 / 史料案例 / Boss 双解，用来体验时空定位和史料实证。
// 解锁后：高中必修、选必、冲刺主线，高考权重套练，史料题题型池，史学实验室，Boss 双解和复习闭环。
// 本地测试：HistApex.storekit 已挂到 scheme，可直接验证购买 / 恢复流程。

final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()

    let productID = "com.histapex.app.full_unlock"

    static let freeNodeCount = 9
    static let freeDuelCount = 1
    static let freeMaterialCaseCount = 2
    static let freeWeaponCount = 6

    @Published private(set) var isUnlocked: Bool = false
    @Published private(set) var product: Product?
    @Published private(set) var isPurchasing: Bool = false
    @Published private(set) var errorMessage: String?

    private let storageKey = "histapex_full_unlocked"

    private init() {
        isUnlocked = UserDefaults.standard.bool(forKey: storageKey)
        Task {
            await loadProduct()
            await refreshEntitlements()
        }
    }

    func isNodePremiumLocked(_ node: LearningNode) -> Bool {
        guard !isUnlocked else { return false }
        return node.order > Self.freeNodeCount
    }

    func isDuelPremiumLocked(index: Int) -> Bool {
        guard !isUnlocked else { return false }
        return index >= Self.freeDuelCount
    }

    func isMaterialCasePremiumLocked(index: Int) -> Bool {
        guard !isUnlocked else { return false }
        return index >= Self.freeMaterialCaseCount
    }

    func isWeaponPremiumLocked(index: Int) -> Bool {
        guard !isUnlocked else { return false }
        return index >= Self.freeWeaponCount
    }

    @MainActor
    func loadProduct() async {
        do {
            let products = try await Product.products(for: [productID])
            product = products.first
        } catch {
            errorMessage = nil
        }
    }

    @MainActor
    func purchase() async {
        guard let product else {
            errorMessage = "获取产品信息失败，请检查网络后重试"
            return
        }
        isPurchasing = true
        errorMessage = nil
        defer { isPurchasing = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                unlock()
            case .userCancelled:
                break
            case .pending:
                errorMessage = "购买待处理（可能需要家长确认），完成后会自动解锁"
            @unknown default:
                break
            }
        } catch {
            errorMessage = "购买失败：\(error.localizedDescription)"
        }
    }

    @MainActor
    func restore() async {
        isPurchasing = true
        errorMessage = nil
        defer { isPurchasing = false }
        do {
            try await AppStore.sync()
            await refreshEntitlements()
            if !isUnlocked { errorMessage = "未找到购买记录" }
        } catch {
            errorMessage = "恢复失败：\(error.localizedDescription)"
        }
    }

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == productID,
               transaction.revocationDate == nil {
                await MainActor.run { unlock() }
                return
            }
        }
    }

    @MainActor
    private func unlock() {
        isUnlocked = true
        UserDefaults.standard.set(true, forKey: storageKey)
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error): throw error
        case .verified(let value): return value
        }
    }

    #if DEBUG
    @MainActor func debugToggle() {
        isUnlocked.toggle()
        UserDefaults.standard.set(isUnlocked, forKey: storageKey)
    }
    #endif
}
