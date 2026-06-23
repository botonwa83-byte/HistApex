import SwiftUI

struct AscentPathView: View {
    @EnvironmentObject var progress: ProgressManager
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    private var nodes: [LearningNode] { MainLineData.nodes }
    private var recommended: LearningNode? { progress.currentNode(in: nodes) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    premiumBanner
                    dashboard
                    todayFocus
                    pathHeader

                    ForEach(Array(nodes.enumerated()), id: \.element.id) { index, node in
                        if index == 0 || node.stage != nodes[index - 1].stage {
                            stageDivider(node.stage)
                        }

                        if purchase.isNodePremiumLocked(node) {
                            Button { showPaywall = true } label: {
                                NodeCard(node: node,
                                         state: progress.nodeState(node, in: nodes),
                                         progressValue: progress.nodeProgress(node),
                                         isRecommended: node.id == recommended?.id,
                                         premiumLocked: true)
                            }
                            .buttonStyle(.plain)
                        } else {
                            NavigationLink { NodeDetailView(node: node) } label: {
                                NodeCard(node: node,
                                         state: progress.nodeState(node, in: nodes),
                                         progressValue: progress.nodeProgress(node),
                                         isRecommended: node.id == recommended?.id,
                                         premiumLocked: false)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(Spacing.lg)
                .padding(.bottom, Spacing.xxl)
                .readableWidth()
            }
            .background(Color.apexBackground.ignoresSafeArea())
            .navigationTitle("指挥中心")
            .sheet(isPresented: $showPaywall) { PaywallView() }
        }
    }

    @ViewBuilder
    private var premiumBanner: some View {
        if !purchase.isUnlocked {
            Button { showPaywall = true } label: {
                HStack(spacing: Spacing.md) {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.white)
                        .frame(width: 42, height: 42)
                        .background(Color.white.opacity(0.16))
                        .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                    VStack(alignment: .leading, spacing: 3) {
                        Text("解锁完整版")
                            .font(AppFont.cardTitle)
                            .foregroundColor(.white)
                        Text("全部 \(nodes.count) 关 · \(WeaponGuideData.all.count) 把武器 · 史学实验室")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    Spacer(minLength: 0)
                    Text(purchase.product?.displayPrice ?? "¥22")
                        .font(AppFont.cardTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 11)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                }
                .padding(Spacing.lg)
                .background(LinearGradient(colors: [.apexRed, .apexGold],
                                           startPoint: .leading,
                                           endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerRadius: Radius.card, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }

    private var dashboard: some View {
        HStack(spacing: Spacing.md) {
            statBlock("\(progress.completedNodeCount)/\(nodes.count)", "主线进度", .apexTeal)
            statBlock("\(MemoryData.highWeight(limit: 99).filter { $0.grade == .s }.count)", "S级卡", .apexRed)
            statBlock("\(WeaponGuideData.all.count)", "武器", .apexGold)
        }
        .cardSurface()
    }

    private func statBlock(_ value: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(AppFont.stat(24))
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var todayFocus: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "今日提分入口", systemImage: "bolt.fill", accent: .apexGold)
            if let weak = progress.weakNodes(limit: 1).first {
                NavigationLink { NodeDetailView(node: weak.node) } label: {
                    focusRow(icon: "target",
                             color: .apexDanger,
                             title: weak.node.title,
                             subtitle: "薄弱优先 · 预计正确率 \(Int(weak.accuracy * 100))%",
                             badge: "补短板")
                }
                .buttonStyle(.plain)
            }
            if let guide = WeaponGuideData.guide(for: .openEssaySixSteps) {
                NavigationLink { WeaponDetailView(guide: guide) } label: {
                    focusRow(icon: guide.weapon.icon,
                             color: .apexTeal,
                             title: guide.weapon.name,
                             subtitle: guide.tagline,
                             badge: "主观题")
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func focusRow(icon: String, color: Color, title: String, subtitle: String, badge: String) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.13))
                .foregroundColor(color)
                .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(AppFont.cardTitle)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            TagChip(text: badge, color: color)
        }
        .cardSurface()
    }

    private var pathHeader: some View {
        HStack {
            SectionHeader(title: "登顶之路 · 28关", systemImage: "map", accent: .apexTeal)
            if let recommended {
                Text("推荐 \(recommended.order)")
                    .font(AppFont.chip)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func stageDivider(_ stage: Stage) -> some View {
        HStack(spacing: Spacing.sm) {
            Rectangle()
                .fill(stage.color.opacity(0.35))
                .frame(height: 1)
            Text("\(stage.mark) \(stage.title)")
                .font(AppFont.chip)
                .foregroundColor(stage.color)
                .fixedSize()
            Rectangle()
                .fill(stage.color.opacity(0.35))
                .frame(height: 1)
        }
        .padding(.vertical, Spacing.xs)
    }
}

struct NodeCard: View {
    let node: LearningNode
    let state: NodeState
    let progressValue: Double
    let isRecommended: Bool
    let premiumLocked: Bool

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Radius.inner, style: .continuous)
                    .fill(node.stage.color.opacity(0.13))
                Text("\(node.order)")
                    .font(AppFont.cardTitle)
                    .foregroundColor(node.stage.color)
            }
            .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(spacing: Spacing.xs) {
                    Text(node.title)
                        .font(AppFont.cardTitle)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    if isRecommended {
                        TagChip(text: "推荐", color: .apexRed)
                    }
                    if premiumLocked {
                        TagChip(text: "完整版", color: .apexGold)
                    }
                }
                Text(node.tagline)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                HStack(spacing: 6) {
                    TagChip(text: node.topic.name, color: node.stage.color)
                    if let weapon = node.weaponUnlocked {
                        TagChip(text: weapon.name, color: .apexTeal)
                    }
                    ForEach(node.knowledgePoints.prefix(1)) { point in
                        TagChip(text: "\(point.grade.rawValue)级", color: .grade(point.grade))
                    }
                }
                ProgressView(value: progressValue)
                    .tint(node.stage.color)
            }

            Spacer(minLength: 0)

            Image(systemName: trailingIcon)
                .font(.caption)
                .foregroundColor(premiumLocked ? .apexGold : .secondary)
                .padding(.top, 4)
        }
        .cardSurface()
    }

    private var trailingIcon: String {
        if premiumLocked { return "crown.fill" }
        switch state {
        case .completed: return "checkmark.circle.fill"
        case .current: return "play.circle.fill"
        case .locked: return "chevron.right"
        }
    }
}

struct NodeDetailView: View {
    let node: LearningNode
    @EnvironmentObject var progress: ProgressManager
    @State private var selectedPointId: String?
    @State private var selectedDetailTab: DetailTab = .learn

    private var questions: [HistoryQuestion] { QuestionBank.questions(nodeId: node.id) }
    private var subjectiveQuestions: [SubjectiveQuestion] { SubjectiveQuestionData.questions(nodeId: node.id) }
    private var duel: BossDuel? { node.bossCaseId.flatMap { BossDuelData.duel(id: $0) } }
    private var selectedPoint: KnowledgePoint { MainLineData.knowledge(id: selectedPointId ?? "") ?? node.knowledgePoints[0] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                pointSelector
                tabPicker
                knowledgeSection
                if selectedDetailTab == .practice {
                    practiceSection
                }
                if let duel {
                    duelSection(duel)
                }
                completeButton
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("第 \(node.order) 关")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if selectedPointId == nil {
                selectedPointId = node.knowledgePoints.first?.id
            }
        }
    }

    private enum DetailTab: String, CaseIterable, Identifiable {
        case learn = "讲解"
        case practice = "练习"

        var id: String { rawValue }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                TagChip(text: node.stage.shortTitle, color: node.stage.color)
                TagChip(text: node.topic.name, color: node.stage.color)
                if let weapon = node.weaponUnlocked {
                    TagChip(text: "解锁 \(weapon.name)", color: .apexGold)
                }
            }
            Text(node.title)
                .font(.title2.weight(.bold))
            Text(node.tagline)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .cardSurface()
    }

    private var knowledgeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "高权重考点", systemImage: "seal", accent: .apexTeal)
            KnowledgePointStudyCard(point: selectedPoint)
        }
    }

    private var pointSelector: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "本关目录", systemImage: "list.bullet.rectangle", accent: .apexBlue)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: Spacing.sm)], spacing: Spacing.sm) {
                ForEach(node.knowledgePoints) { point in
                    Button {
                        selectedPointId = point.id
                        selectedDetailTab = .learn
                    } label: {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: selectedPoint.id == point.id ? "checkmark.circle.fill" : "circle")
                                .font(.caption)
                                .foregroundColor(selectedPoint.id == point.id ? .grade(point.grade) : .secondary)
                            Text(point.title)
                                .font(.caption.weight(.semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            Spacer(minLength: 0)
                            TagChip(text: point.grade.rawValue, color: .grade(point.grade))
                        }
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.sm)
                        .background(selectedPoint.id == point.id ? Color.grade(point.grade).opacity(0.12) : Color.apexCardSurface)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .cardSurface()
    }

    private var tabPicker: some View {
        Picker("详情分区", selection: $selectedDetailTab) {
            ForEach(DetailTab.allCases) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
    }

    private var practiceSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "关联练习", systemImage: "checkmark.seal", accent: .apexBlue)
            let linkedSubjective = subjectiveQuestions.filter { $0.knowledgeId == selectedPoint.id }
            let linkedQuestions = questions.filter { $0.knowledgeId == selectedPoint.id }
            ForEach(linkedSubjective.prefix(3)) { question in
                NavigationLink { SubjectiveQuestionDetailView(item: question) } label: {
                    HStack(spacing: Spacing.md) {
                        TagChip(text: question.questionType.shortName, color: .apexRed)
                        Text(question.prompt)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                        Spacer(minLength: 0)
                        TagChip(text: "\(question.score)分", color: .apexGold)
                    }
                    .cardSurface(padding: Spacing.md)
                }
                .buttonStyle(.plain)
            }

            ForEach(linkedQuestions.prefix(6)) { question in
                NavigationLink { QuestionDetailView(question: question) } label: {
                    HStack(spacing: Spacing.md) {
                        Image(systemName: progress.stats(for: question.id).everCorrect ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(progress.stats(for: question.id).everCorrect ? .apexEmerald : .secondary)
                        Text(question.prompt)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .cardSurface(padding: Spacing.md)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func duelSection(_ duel: BossDuel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "Boss 双解对决", systemImage: "bolt.shield", accent: .apexRed)
            NavigationLink { DuelDetailView(duel: duel) } label: {
                HStack(spacing: Spacing.md) {
                    Image(systemName: duel.weapon.icon)
                        .font(.title3)
                        .frame(width: 44, height: 44)
                        .background(Color.apexRed.opacity(0.12))
                        .foregroundColor(.apexRed)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(duel.title)
                            .font(AppFont.cardTitle)
                            .foregroundColor(.primary)
                        Text("常规 \(timeText(duel.standard.timeMinutes)) → 武器 \(timeText(duel.weaponPath.timeMinutes))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    TagChip(text: String(format: "快 %.1f 倍", duel.timeRatio), color: .apexRed)
                }
                .cardSurface()
            }
            .buttonStyle(.plain)
        }
    }

    private var completeButton: some View {
        Button {
            progress.complete(node)
        } label: {
            Label(progress.completedNodeIds.contains(node.id) ? "已通关" : "标记本关通关",
                  systemImage: progress.completedNodeIds.contains(node.id) ? "checkmark.circle.fill" : "flag.checkered")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(node.stage.color)
                .clipShape(RoundedRectangle(cornerRadius: Radius.card))
        }
    }

    private func timeText(_ value: Double) -> String {
        value >= 1 ? String(format: "%.0f分钟", value) : String(format: "%.1f分钟", value)
    }
}

struct KnowledgePointStudyCard: View {
    let point: KnowledgePoint
    @State private var selectedBlock: StudyBlock = .recite

    private enum StudyBlock: String, CaseIterable, Identifiable {
        case recite = "背诵"
        case explain = "理解"
        case template = "答题"
        case traps = "易错"

        var id: String { rawValue }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(point.title)
                        .font(AppFont.cardTitle)
                    Text(point.detail)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                Spacer(minLength: 0)
                VStack(alignment: .trailing, spacing: 4) {
                    TagChip(text: "\(point.grade.rawValue)级", color: .grade(point.grade))
                    TagChip(text: point.cardType.rawValue, color: .apexBlue)
                    if point.hasDeepExplanation {
                        TagChip(text: "深度讲解", color: .apexGold)
                    }
                }
            }

            if point.hasDeepExplanation {
                Picker("讲解分区", selection: $selectedBlock) {
                    ForEach(StudyBlock.allCases) { block in
                        Text(block.rawValue).tag(block)
                    }
                }
                .pickerStyle(.segmented)

                selectedStudyContent
                if let bridge = KnowledgeBridgeData.bridge(for: point) {
                    KnowledgeBridgeMiniPanel(bridge: bridge)
                }
            } else if let pitfall = point.pitfall {
                Label(pitfall, systemImage: "exclamationmark.triangle")
                    .font(.caption)
                    .foregroundColor(.apexDanger)
            }
        }
        .cardSurface(padding: Spacing.md)
    }

    @ViewBuilder
    private var selectedStudyContent: some View {
        switch selectedBlock {
        case .recite:
            studyBlock("必背原文", icon: "text.book.closed", color: .apexRed, lines: point.mustReciteLines)
            studyBlock("默写清单", icon: "checkmark.seal", color: .apexTeal, lines: point.explanation.reciteChecklist)
        case .explain:
            if !point.explanation.plainExplanation.isEmpty {
                studyBlock("白话理解", icon: "lightbulb", color: .apexGold, lines: [point.explanation.plainExplanation])
            }
            studyBlock("材料触发", icon: "scope", color: .apexBlue, lines: point.explanation.triggerScenes)
        case .template:
            studyBlock("答题模板", icon: "text.append", color: .apexTeal, lines: point.explanation.answerTemplate)
            studyBlock("高分答案句", icon: "text.quote", color: .apexEmerald, lines: point.sampleAnswerSentences)
        case .traps:
            studyBlock("易混辨析", icon: "arrow.left.arrow.right", color: .apexViolet, lines: point.explanation.confusions)
            studyBlock("扣分提醒", icon: "exclamationmark.triangle", color: .apexDanger, lines: point.commonTrapLines)
        }
    }

    @ViewBuilder
    private func studyBlock(_ title: String, icon: String, color: Color, lines: [String]) -> some View {
        if !lines.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Label(title, systemImage: icon)
                    .font(AppFont.chip)
                    .foregroundColor(color)
                ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Text("\(index + 1).")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(color)
                            .frame(width: 20, alignment: .leading)
                        Text(line)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

private struct KnowledgeBridgeMiniPanel: View {
    let bridge: KnowledgeBridge

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Label("下一步", systemImage: "arrow.triangle.branch")
                .font(AppFont.chip)
                .foregroundColor(.apexBlue)

            HStack(spacing: Spacing.xs) {
                if let guide = bridge.weaponGuide {
                    NavigationLink { WeaponDetailView(guide: guide) } label: {
                        TagChip(text: guide.weapon.name, color: .apexTeal)
                    }
                    .buttonStyle(.plain)
                }
                if let module = bridge.specialModules.first {
                    NavigationLink { HistoricalSpecialDetailView(module: module) } label: {
                        TagChip(text: module.title, color: module.kind.color)
                    }
                    .buttonStyle(.plain)
                }
                if let template = bridge.answerTemplates.first {
                    TagChip(text: template.title, color: .apexGold)
                }
            }

            HStack(spacing: Spacing.xs) {
                if let question = bridge.subjectiveQuestions.first {
                    NavigationLink { SubjectiveQuestionDetailView(item: question) } label: {
                        TagChip(text: "练主观题", color: .apexRed)
                    }
                    .buttonStyle(.plain)
                }
                if let question = bridge.choiceQuestions.first {
                    NavigationLink { QuestionDetailView(question: question) } label: {
                        TagChip(text: "练选择题", color: .apexBlue)
                    }
                    .buttonStyle(.plain)
                }
                if let next = bridge.nextPoint {
                    TagChip(text: "下个：\(next.title)", color: .apexViolet)
                }
            }
        }
        .padding(.top, Spacing.xs)
    }
}

struct QuestionDetailView: View {
    let question: HistoryQuestion
    @EnvironmentObject var progress: ProgressManager
    @State private var selectedIndex: Int?

    private var bridge: KnowledgeBridge? {
        MainLineData.knowledge(id: question.knowledgeId).flatMap { KnowledgeBridgeData.bridge(for: $0) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text(question.prompt)
                        .font(.title3.weight(.bold))
                    HStack {
                        TagChip(text: question.stage.shortTitle, color: question.stage.color)
                        TagChip(text: question.topic.name, color: question.stage.color)
                    }
                }
                .cardSurface()

                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    Button {
                        selectedIndex = index
                        progress.record(question, correct: index == question.answerIndex)
                    } label: {
                        HStack(spacing: Spacing.md) {
                            Text(String(UnicodeScalar(65 + index)!))
                                .font(AppFont.cardTitle)
                                .frame(width: 32, height: 32)
                                .background(optionColor(index).opacity(0.14))
                                .foregroundColor(optionColor(index))
                                .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                            Text(option)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                            Spacer(minLength: 0)
                        }
                        .cardSurface(padding: Spacing.md)
                    }
                    .buttonStyle(.plain)
                }

                if selectedIndex != nil {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: "解析", systemImage: "lightbulb", accent: .apexGold)
                        Text(question.explanation)
                            .font(.subheadline)
                        if !question.trapTags.isEmpty {
                            HStack {
                                ForEach(question.trapTags, id: \.self) { tag in
                                    TagChip(text: tag, color: .apexDanger)
                                }
                            }
                        }
                    }
                    .cardSurface()
                }

                if let bridge {
                    KnowledgeBridgeDetailPanel(bridge: bridge)
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("选择题排雷")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func optionColor(_ index: Int) -> Color {
        guard let selectedIndex else { return .apexBlue }
        if index == question.answerIndex { return .apexEmerald }
        if index == selectedIndex { return .apexDanger }
        return .secondary
    }
}

struct KnowledgeBridgeDetailPanel: View {
    let bridge: KnowledgeBridge

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "回到知识网络", systemImage: "point.3.connected.trianglepath.dotted", accent: .apexTeal)
            NavigationLink { NodeDetailView(node: bridge.node) } label: {
                bridgeRow(title: bridge.node.title, subtitle: "主线关卡 · \(bridge.point.title)", icon: "map", color: bridge.node.stage.color)
            }
            .buttonStyle(.plain)

            if let guide = bridge.weaponGuide {
                NavigationLink { WeaponDetailView(guide: guide) } label: {
                    bridgeRow(title: guide.weapon.name, subtitle: guide.tagline, icon: guide.weapon.icon, color: .apexGold)
                }
                .buttonStyle(.plain)
            }

            ForEach(bridge.specialModules.prefix(2)) { module in
                NavigationLink { HistoricalSpecialDetailView(module: module) } label: {
                    bridgeRow(title: module.title, subtitle: module.method, icon: module.kind.icon, color: module.kind.color)
                }
                .buttonStyle(.plain)
            }

            if let next = bridge.nextPoint {
                HStack(spacing: Spacing.md) {
                    Image(systemName: "arrow.right.circle")
                        .foregroundColor(.apexViolet)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("继续学：\(next.title)")
                            .font(AppFont.cardTitle)
                        Text("前后考点串起来，避免只背孤立结论。")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
        .cardSurface()
    }

    private func bridgeRow(title: String, subtitle: String, icon: String, color: Color) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFont.cardTitle)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 3)
    }
}

struct DuelDetailView: View {
    let duel: BossDuel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(duel.title)
                        .font(.title2.weight(.bold))
                    Text(duel.material)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(duel.question)
                        .font(AppFont.cardTitle)
                }
                .cardSurface()

                solutionCard(path: duel.standard, color: .secondary)
                solutionCard(path: duel.weaponPath, color: .apexRed)

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "为什么能快", systemImage: "sparkles", accent: .apexGold)
                    Text(duel.keyInsight)
                        .font(.subheadline)
                }
                .cardSurface()

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "高分答案句", systemImage: "text.quote", accent: .apexTeal)
                    ForEach(Array(duel.sampleAnswer.enumerated()), id: \.offset) { index, sentence in
                        Text("\(index + 1). \(sentence)")
                            .font(.subheadline)
                    }
                }
                .cardSurface()
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("双解对决")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func solutionCard(path: SolutionPath, color: Color) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(path.title)
                    .font(AppFont.cardTitle)
                Spacer()
                TagChip(text: String(format: "%.1f 分钟", path.timeMinutes), color: color)
            }
            ForEach(Array(path.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text("\(index + 1)")
                        .font(AppFont.chip)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(color)
                        .clipShape(Circle())
                    Text(step)
                        .font(.subheadline)
                }
            }
        }
        .cardSurface()
    }
}
