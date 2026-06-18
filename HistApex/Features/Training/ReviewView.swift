import SwiftUI

struct ReviewView: View {
    @ObservedObject private var manager = ReviewProgressManager.shared

    private var dueCards: [MemoryCard] { manager.dueCards }

    var body: some View {
        List {
            Section {
                HStack {
                    stat("\(dueCards.count)", "今日到期", .apexRed)
                    stat("\(manager.masteredCount)", "稳定掌握", .apexEmerald)
                    stat("\(MemoryData.all.count)", "总卡片", .apexTeal)
                }
                .padding(.vertical, 8)
            }

            Section("优先复习") {
                ForEach(dueCards) { card in
                    NavigationLink { ReviewCardDetailView(card: card) } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(card.front)
                                    .font(AppFont.cardTitle)
                                Spacer()
                                TagChip(text: "\(card.grade.rawValue)级", color: .grade(card.grade))
                            }
                            HStack {
                                TagChip(text: card.type.rawValue, color: .apexBlue)
                                TagChip(text: card.mode.rawValue, color: .apexTeal)
                                let state = manager.state(for: card)
                                if state.correctCount + state.wrongCount > 0 {
                                    Text("Lv.\(state.level)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("智能复习")
    }

    private func stat(_ value: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(AppFont.stat(22))
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ReviewCardDetailView: View {
    let card: MemoryCard
    @ObservedObject private var manager = ReviewProgressManager.shared
    @State private var showingBack = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    HStack {
                        TagChip(text: "\(card.grade.rawValue)级", color: .grade(card.grade))
                        TagChip(text: card.type.rawValue, color: .apexBlue)
                        TagChip(text: card.mode.rawValue, color: .apexTeal)
                    }
                    Text(card.front)
                        .font(.title2.weight(.bold))
                    if showingBack {
                        Divider()
                        Text(card.back)
                            .font(.body)
                    }
                }
                .cardSurface()

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingBack.toggle()
                    }
                } label: {
                    Label(showingBack ? "收起答案" : "显示答案", systemImage: showingBack ? "eye.slash" : "eye")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.apexTeal)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.card))
                }

                if showingBack {
                    HStack(spacing: Spacing.md) {
                        reviewButton("忘了", color: .apexDanger, correct: false)
                        reviewButton("掌握", color: .apexEmerald, correct: true)
                    }
                }

                statePanel
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("复习卡")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var statePanel: some View {
        let state = manager.state(for: card)
        return VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "复习状态", systemImage: "calendar.badge.clock", accent: .apexGold)
            Text("等级：Lv.\(state.level)")
                .font(.subheadline)
            Text("正确 \(state.correctCount) 次 · 错误 \(state.wrongCount) 次")
                .font(.subheadline)
                .foregroundColor(.secondary)
            if state.nextDue != .distantPast {
                Text("下次复习：\(state.nextDue.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .cardSurface()
    }

    private func reviewButton(_ title: String, color: Color, correct: Bool) -> some View {
        Button {
            manager.record(card: card, correct: correct)
            showingBack = false
        } label: {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: Radius.card))
        }
    }
}
