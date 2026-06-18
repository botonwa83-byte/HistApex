import SwiftUI

struct PromoView: View {
    let onStart: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [.apexBlue, .apexTeal],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: Spacing.xl) {
                Spacer(minLength: 24)

                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("HistApex")
                        .font(.system(size: 46, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("历史登顶")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.92))
                    Text("定时空、读史料、写得像高分答案。")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.86))
                }

                VStack(spacing: Spacing.md) {
                    promoRow("timeline.selection", "时间轴宇宙", "朝代、年代、阶段特征一屏串联")
                    promoRow("doc.text.magnifyingglass", "史料实证", "出处、时间、立场、信息、限度五步读材料")
                    promoRow("text.append", "小论文工坊", "观点明确、史实准确、逻辑支撑主题")
                }

                Spacer()

                Button(action: onStart) {
                    HStack {
                        Text("开始登顶")
                            .font(.headline)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.apexBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.card, style: .continuous))
                }
            }
            .padding(Spacing.xl)
            .readableWidth(560)
        }
    }

    private func promoRow(_ icon: String, _ title: String, _ subtitle: String) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 42, height: 42)
                .background(Color.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: Radius.inner, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFont.cardTitle)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.82))
            }
            Spacer(minLength: 0)
        }
    }
}
