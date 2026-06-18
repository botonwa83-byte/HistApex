import SwiftUI

struct ConceptGraphView: View {
    @State private var selected: ConceptNode? = ConceptGraphData.nodes.first

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    graphSummary
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: Spacing.md)], spacing: Spacing.md) {
                        ForEach(ConceptGraphData.nodes) { node in
                            Button { selected = node } label: {
                                ConceptTile(node: node, selected: selected?.id == node.id)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    if let selected {
                        ConceptDetailPanel(node: selected)
                    }
                }
                .padding(Spacing.lg)
                .padding(.bottom, Spacing.xxl)
                .readableWidth()
            }
            .background(Color.apexBackground.ignoresSafeArea())
            .navigationTitle("概念星图")
        }
    }

    private var graphSummary: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "高考历史知识网络", systemImage: "network", accent: .apexTeal)
            Text("节点按权重、主体职责和材料触发词组织。先看主体，再看边界，最后把材料动作贴回教材术语。")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                stat("\(ConceptGraphData.nodes.count)", "核心节点", .apexTeal)
                stat("\(ConceptGraphData.edges.count)", "关系边", .apexBlue)
                stat("\(ConceptGraphData.nodes.filter { $0.grade == .s }.count)", "S级", .apexRed)
            }
        }
        .cardSurface()
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

private struct ConceptTile: View {
    let node: ConceptNode
    let selected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                TagChip(text: node.grade.rawValue, color: .grade(node.grade))
                Spacer()
                Image(systemName: node.topic.icon)
                    .foregroundColor(node.topic.stage.color)
            }
            Text(node.title)
                .font(AppFont.cardTitle)
                .foregroundColor(.primary)
                .lineLimit(1)
            Text(node.subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.md)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.card)
                .stroke(selected ? Color.apexTeal : Color.clear, lineWidth: 2)
        )
    }
}

private struct ConceptDetailPanel: View {
    let node: ConceptNode

    private var edges: [ConceptEdge] { ConceptGraphData.related(to: node.id) }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: node.title, systemImage: node.topic.icon, accent: node.topic.stage.color)
            Text(node.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                TagChip(text: "\(node.grade.rawValue)级", color: .grade(node.grade))
                TagChip(text: node.topic.name, color: node.topic.stage.color)
            }

            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("材料触发词")
                    .font(AppFont.cardTitle)
                HStack {
                    ForEach(node.triggerWords, id: \.self) { word in
                        TagChip(text: word, color: .apexGold)
                    }
                }
            }

            if !edges.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("关系边")
                        .font(AppFont.cardTitle)
                    ForEach(edges) { edge in
                        let otherId = edge.from == node.id ? edge.to : edge.from
                        let other = ConceptGraphData.concept(id: otherId)?.title ?? otherId
                        HStack(alignment: .top, spacing: Spacing.sm) {
                            Image(systemName: "arrow.left.and.right")
                                .foregroundColor(.apexTeal)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(other)
                                    .font(.subheadline.weight(.semibold))
                                Text(edge.relation)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .cardSurface()
    }
}
