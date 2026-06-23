import SwiftUI

struct PaywallView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @Environment(\.dismiss) private var dismiss

    private var priceLabel: String { purchase.product?.displayPrice ?? "¥22" }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroArea

                VStack(alignment: .leading, spacing: 14) {
                    ForEach(PremiumContentPlan.heroBenefits) { benefit in
                        benefitRow(benefit)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 28)
                .padding(.bottom, 20)

                Divider()
                    .padding(.horizontal, 24)

                qualityProof

                Divider()
                    .padding(.horizontal, 24)

                unlockComparison

                Divider()
                    .padding(.horizontal, 24)

                VStack(spacing: 6) {
                    Text(PremiumContentPlan.freeSummary)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Text("先用免费初中主线体验背诵和材料切片，再解锁高中提分闭环。")
                        .font(.footnote.weight(.medium))
                        .foregroundColor(.apexLava)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 24)

                purchaseButton
                    .padding(.horizontal, 24)

                Button { Task { await purchase.restore() } } label: {
                    Text("恢复购买")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .underline()
                }
                .padding(.top, 12)
                .disabled(purchase.isPurchasing)

                if let message = purchase.errorMessage {
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.apexDanger)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                }

                #if DEBUG
                Button("（调试）本地解锁") { purchase.debugToggle() }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
                #endif

                Text("购买即视为同意[用户协议](https://botonwa83-byte.github.io/HistApex/terms.html)与[隐私政策](https://botonwa83-byte.github.io/HistApex/privacy.html)。购买通过 Apple 账户完成。\(PremiumContentPlan.paywallFootnote)")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
            }
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .onChange(of: purchase.isUnlocked) { unlocked in
            if unlocked { dismiss() }
        }
    }

    private var heroArea: some View {
        ZStack {
            LinearGradient(colors: [.apexLava, .apexMystery],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            VStack(spacing: 10) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.white)
                Text("解锁历史登顶完整版")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Text(PremiumContentPlan.tagline)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
            }
            .padding(.vertical, 40)
        }
    }

    private var purchaseButton: some View {
        Button { Task { await purchase.purchase() } } label: {
            HStack(spacing: 10) {
                if purchase.isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "lock.open.fill")
                }
                Text(purchase.isPurchasing ? "处理中..." : "立即解锁 \(priceLabel)")
                    .fontWeight(.bold)
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(LinearGradient(colors: [.apexLava, .apexMystery],
                                       startPoint: .leading,
                                       endPoint: .trailing))
            .clipShape(RoundedRectangle(cornerRadius: Radius.card, style: .continuous))
            .shadow(color: Color.apexLava.opacity(0.3), radius: 10, y: 4)
        }
        .disabled(purchase.isPurchasing)
    }

    private var qualityProof: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("质量凭证")
                .font(.headline)
                .foregroundColor(.primary)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 12)], spacing: 12) {
                ForEach(PremiumContentPlan.qualityStats) { stat in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(stat.value)
                            .font(.title3.weight(.black))
                            .foregroundColor(.apexLava)
                        Text(stat.title)
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.primary)
                        Text(stat.detail)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(Color.apexCardSurface)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.inner, style: .continuous))
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
    }

    private var unlockComparison: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("免费版 vs 完整版")
                .font(.headline)
                .foregroundColor(.primary)
            ForEach(PremiumContentPlan.unlockComparison) { item in
                HStack(alignment: .top, spacing: 10) {
                    Label(item.free, systemImage: "lock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "arrow.right")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.apexGold)
                        .padding(.top, 2)
                    Label(item.premium, systemImage: "crown.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(10)
                .background(Color.apexCardSurface)
                .clipShape(RoundedRectangle(cornerRadius: Radius.inner, style: .continuous))
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
    }

    private func benefitRow(_ benefit: PremiumBenefit) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: Radius.inner, style: .continuous)
                    .fill(benefit.color.opacity(0.15))
                    .frame(width: 38, height: 38)
                Image(systemName: benefit.icon)
                    .font(.subheadline)
                    .foregroundColor(benefit.color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(benefit.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
                Text(benefit.detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
    }
}
