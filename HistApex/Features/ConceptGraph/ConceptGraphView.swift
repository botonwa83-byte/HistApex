import SwiftUI

struct ConceptGraphView: View {
    @State private var selected: ConceptNode?
    /// 默认展开节点最多的模块，进来就能看到一个像样的圆环，而不是一排全收起的标题或只有一个孤点。
    @State private var expandedTopics: Set<HistoryTopic> = {
        let present = HistoryTopic.allCases.filter { t in ConceptGraphData.nodes.contains { $0.topic == t } }
        let densest = present.max { a, b in
            ConceptGraphData.nodes.filter { $0.topic == a }.count < ConceptGraphData.nodes.filter { $0.topic == b }.count
        }
        return densest.map { [$0] } ?? []
    }()

    private var topicsPresent: [HistoryTopic] {
        HistoryTopic.allCases.filter { topic in ConceptGraphData.nodes.contains { $0.topic == topic } }
    }

    private func nodes(in topic: HistoryTopic) -> [ConceptNode] {
        ConceptGraphData.nodes.filter { $0.topic == topic }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.md) {
                    header
                    ForEach(topicsPresent) { topic in
                        moduleSection(topic)
                    }
                }
                .padding(Spacing.lg)
                .padding(.bottom, Spacing.xxl)
                .readableWidth()
            }
            .background(Color.apexBackground.ignoresSafeArea())
            .navigationTitle("概念星图")
            .sheet(item: $selected) { node in
                ConceptDetailSheet(node: node)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("按模块收纳。点开模块看它的概念圆环，连线表示通史前后承接或主题呼应关系；点节点看必背原文、答题模板和高分句。")
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                stat("\(ConceptGraphData.nodes.count)", "核心节点", .apexTeal)
                stat("\(topicsPresent.count)", "模块", .apexBlue)
                stat("\(ConceptGraphData.nodes.filter { $0.grade == .s }.count)", "S级", .apexRed)
            }
            .cardSurface()
        }
    }

    private func stat(_ value: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(AppFont.stat(20))
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 模块行（点开展开圆环）

    private func moduleSection(_ topic: HistoryTopic) -> some View {
        let topicNodes = nodes(in: topic)
        let sCount = topicNodes.filter { $0.grade == .s }.count
        let isExpanded = expandedTopics.contains(topic)
        let preview = topicNodes.prefix(8).map(\.title).joined(separator: " / ")

        return VStack(alignment: .leading, spacing: Spacing.sm) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    if isExpanded {
                        expandedTopics.remove(topic)
                    } else {
                        expandedTopics.insert(topic)
                    }
                }
            } label: {
                HStack(alignment: .top, spacing: Spacing.md) {
                    Circle()
                        .fill(topic.stage.color)
                        .frame(width: 10, height: 10)
                        .padding(.top, 6)
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: Spacing.sm) {
                            Text(topic.name)
                                .font(AppFont.cardTitle)
                                .foregroundColor(.primary)
                            Spacer(minLength: 0)
                            Text("节点\(topicNodes.count) · S\(sCount)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.down")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        }
                        Text(preview)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                ringGraph(for: topicNodes)
                    .padding(.top, Spacing.xs)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .cardSurface(padding: Spacing.md)
    }

    // MARK: - 单个模块的概念圆环

    /// 权重最高的节点放圆心，其余按圆周均匀铺开；半径随数量增长，避免节点挤在一起。
    private func ringLayout(for topicNodes: [ConceptNode]) -> (positions: [String: CGPoint], side: CGFloat) {
        let sorted = topicNodes.sorted { $0.grade > $1.grade }
        guard let anchor = sorted.first else { return ([:], 0) }
        let ring = Array(sorted.dropFirst())
        let count = ring.count
        let radius: CGFloat = count == 0 ? 0 : min(150, max(78, CGFloat(count) * 13))
        let margin: CGFloat = 46
        let side = (radius + margin) * 2
        let center = CGPoint(x: side / 2, y: side / 2)

        var positions: [String: CGPoint] = [anchor.id: center]
        for (index, node) in ring.enumerated() {
            let angle = (2 * Double.pi / Double(count)) * Double(index) - .pi / 2
            positions[node.id] = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
        }
        return (positions, side)
    }

    private func ringGraph(for topicNodes: [ConceptNode]) -> some View {
        let layout = ringLayout(for: topicNodes)
        let ids = Set(topicNodes.map(\.id))

        return ZStack {
            Canvas { context, _ in
                for edge in ConceptGraphData.edges where ids.contains(edge.from) && ids.contains(edge.to) {
                    guard let from = layout.positions[edge.from],
                          let to = layout.positions[edge.to] else { continue }
                    var path = Path()
                    path.move(to: from)
                    path.addLine(to: to)
                    let highlighted = selected?.id == edge.from || selected?.id == edge.to
                    context.stroke(path,
                                    with: .color(highlighted ? Color.apexTeal.opacity(0.55) : Color.secondary.opacity(0.20)),
                                    lineWidth: highlighted ? 1.8 : 1)
                }
            }
            .allowsHitTesting(false)

            ForEach(topicNodes) { node in
                if let point = layout.positions[node.id] {
                    NodeBubble(node: node, isSelected: selected?.id == node.id)
                        .position(point)
                        .onTapGesture { selected = node }
                }
            }
        }
        .frame(width: layout.side, height: layout.side)
        .frame(maxWidth: .infinity)
    }
}

private struct NodeBubble: View {
    let node: ConceptNode
    let isSelected: Bool

    private var bubbleSize: CGFloat {
        switch node.grade {
        case .s: return 70
        case .a: return 62
        case .b: return 54
        case .c: return 46
        }
    }

    var body: some View {
        Text(node.title)
            .font(.system(size: 10.5, weight: .semibold))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .minimumScaleFactor(0.7)
            .padding(4)
            .frame(width: bubbleSize, height: bubbleSize)
            .background(Circle().fill(Color.grade(node.grade)))
            .overlay(Circle().stroke(Color.white, lineWidth: isSelected ? 3 : 0))
            .shadow(color: .black.opacity(0.18), radius: isSelected ? 6 : 3, y: 1)
            .scaleEffect(isSelected ? 1.15 : 1)
            .animation(.spring(response: 0.3), value: isSelected)
    }
}

private struct ConceptDetailSheet: View {
    let node: ConceptNode
    @Environment(\.dismiss) private var dismiss

    private var edges: [ConceptEdge] { ConceptGraphData.related(to: node.id) }
    private var studyPoints: [KnowledgePoint] { ConceptGraphData.knowledgePoints(for: node.id) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text(node.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            TagChip(text: "\(node.grade.rawValue)级", color: .grade(node.grade))
                            TagChip(text: node.topic.name, color: node.topic.stage.color)
                        }
                    }
                    .cardSurface()

                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: "材料触发词", systemImage: "scope", accent: .apexGold)
                        FlowWrap(spacing: Spacing.xs) {
                            ForEach(node.triggerWords, id: \.self) { word in
                                TagChip(text: word, color: .apexGold)
                            }
                        }
                    }
                    .cardSurface()

                    if studyPoints.isEmpty {
                        EmptyStateView(title: "深度讲解整理中",
                                       systemImage: "book.closed",
                                       message: "该节点的逐句讲解即将上线，先用上方触发词和下方关系网把概念串起来。")
                            .cardSurface()
                    } else {
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            SectionHeader(title: "考点深度讲解（\(studyPoints.count)）",
                                          systemImage: "text.book.closed",
                                          accent: .apexRed)
                            Text("含必背原文、白话理解、答题模板、易混辨析、高分答案句与扣分提醒——点开每一栏都是可直接背、可直接抄进答卷的内容。")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Spacing.xs)

                        ForEach(studyPoints) { point in
                            KnowledgePointStudyCard(point: point)
                        }
                    }

                    if !edges.isEmpty {
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            SectionHeader(title: "关系边（\(edges.count)）", systemImage: "arrow.triangle.branch", accent: .apexTeal)
                            ForEach(edges) { edge in
                                let otherId = edge.from == node.id ? edge.to : edge.from
                                let other = ConceptGraphData.concept(id: otherId)
                                NavigationLink {
                                    if let other {
                                        ConceptDetailSheet(node: other)
                                    }
                                } label: {
                                    HStack(alignment: .top, spacing: Spacing.sm) {
                                        Image(systemName: edge.from == node.id ? "arrow.right" : "arrow.left")
                                            .foregroundColor(.apexTeal)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(other?.title ?? otherId)
                                                .font(.subheadline.weight(.semibold))
                                                .foregroundColor(.primary)
                                            Text(edge.relation)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer(minLength: 0)
                                        Image(systemName: "chevron.right")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .buttonStyle(.plain)
                                .padding(.vertical, 4)
                            }
                        }
                        .cardSurface()
                    }
                }
                .padding(Spacing.lg)
                .readableWidth()
            }
            .background(Color.apexBackground.ignoresSafeArea())
            .navigationTitle(node.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("关闭") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
