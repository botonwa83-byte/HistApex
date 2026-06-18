import SwiftUI

struct TrapDrillView: View {
    @State private var selectedCategory: TrapCategory? = nil

    private var drills: [TrapDrill] {
        if let selectedCategory {
            return TrapDrillData.drills(category: selectedCategory)
        }
        return TrapDrillData.all
    }

    var body: some View {
        List {
            Section("错因筛选") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        filterChip("全部", active: selectedCategory == nil) { selectedCategory = nil }
                        ForEach(TrapCategory.allCases) { category in
                            filterChip(category.rawValue, active: selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            Section("靶场题") {
                ForEach(drills) { drill in
                    NavigationLink { TrapDrillDetailView(drill: drill) } label: {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: drill.category.icon)
                                .foregroundColor(.apexDanger)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(drill.trapOption)
                                    .font(AppFont.cardTitle)
                                    .lineLimit(2)
                                HStack {
                                    TagChip(text: drill.category.rawValue, color: .apexDanger)
                                    if let point = MainLineData.knowledge(id: drill.knowledgeId) {
                                        TagChip(text: point.title, color: .apexTeal)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("选择题排雷靶场")
    }

    private func filterChip(_ title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.chip)
                .foregroundColor(active ? .white : .apexTeal)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(active ? Color.apexTeal : Color.apexTeal.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
        }
        .buttonStyle(.plain)
    }
}

struct TrapDrillDetailView: View {
    let drill: TrapDrill

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    TagChip(text: drill.category.rawValue, color: .apexDanger)
                    Text(drill.stem)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(drill.trapOption)
                        .font(.title3.weight(.bold))
                }
                .cardSurface()

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: drill.verdict, systemImage: "xmark.octagon", accent: .apexDanger)
                    Text(drill.explanation)
                        .font(.subheadline)
                }
                .cardSurface()

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "改成得分句", systemImage: "checkmark.seal", accent: .apexEmerald)
                    Text(drill.correction)
                        .font(.body)
                    if let point = MainLineData.knowledge(id: drill.knowledgeId) {
                        Divider()
                        Text(point.detail)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .cardSurface()

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "关联选择题", systemImage: "checkmark.seal", accent: .apexBlue)
                    ForEach(PracticeLinker.choiceQuestions(for: drill).prefix(4)) { question in
                        NavigationLink { QuestionDetailView(question: question) } label: {
                            Text(question.prompt)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .lineLimit(2)
                                .padding(.vertical, 3)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .cardSurface()
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("排雷解析")
        .navigationBarTitleDisplayMode(.inline)
    }
}
