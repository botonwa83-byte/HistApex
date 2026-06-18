import SwiftUI

struct MoreView: View {
    @EnvironmentObject var progress: ProgressManager
    @ObservedObject private var purchase = PurchaseManager.shared
    @ObservedObject private var appearance = AppearanceManager.shared
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            List {
                if !purchase.isUnlocked {
                    Section {
                        Button { showPaywall = true } label: {
                            HStack(spacing: Spacing.md) {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.apexGold)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(PremiumContentPlan.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(PremiumContentPlan.unlockSummary)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                Section("学习") {
                    NavigationLink { ReviewView() } label: {
                        HStack {
                            Label("智能复习", systemImage: "calendar.badge.clock")
                            Spacer()
                            Text("\(ReviewProgressManager.shared.dueCards.count)")
                                .foregroundColor(.secondary)
                        }
                    }
                    NavigationLink { DiagnosisView() } label: {
                        Label("学情诊断", systemImage: "chart.bar.xaxis")
                    }
                    NavigationLink { ErrorBookView() } label: {
                        Label("错题本", systemImage: "exclamationmark.triangle")
                    }
                    NavigationLink { CoverageView() } label: {
                        Label("考点覆盖", systemImage: "checklist")
                    }
                }

                Section("武器") {
                    NavigationLink { TrapDrillView() } label: {
                        HStack {
                            Label("选择题排雷靶场", systemImage: "exclamationmark.triangle")
                            Spacer()
                            Text("\(TrapDrillData.all.count)")
                                .foregroundColor(.secondary)
                        }
                    }
                    NavigationLink { SubjectMatrixView() } label: {
                        HStack {
                            Label("历史主体矩阵", systemImage: "tablecells")
                            Spacer()
                            Text("\(SubjectMatrixData.all.count)")
                                .foregroundColor(.secondary)
                        }
                    }
                    NavigationLink { AnswerTemplateView() } label: {
                        HStack {
                            Label("答案模板库", systemImage: "doc.text")
                            Spacer()
                            Text("\(AnswerTemplateData.all.count)")
                                .foregroundColor(.secondary)
                        }
                    }
                    NavigationLink { WeaponShelfView() } label: {
                        Label("秒杀武器库", systemImage: "shield.lefthalf.filled")
                    }
                    NavigationLink { DuelListView() } label: {
                        Label("Boss 双解对决", systemImage: "bolt.shield")
                    }
                }

                Section("数据") {
                    HStack {
                        Label("主线通关", systemImage: "flag.checkered")
                        Spacer()
                        Text("\(progress.completedNodeCount)/\(MainLineData.nodes.count)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Label("题库规模", systemImage: "questionmark.circle")
                        Spacer()
                        Text("\(QuestionBank.all.count)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Label("S/A 主观题", systemImage: "text.append")
                        Spacer()
                        Text("\(SubjectiveQuestionData.all.count)")
                            .foregroundColor(.secondary)
                    }
                }

                Section("外观") {
                    Picker("外观模式", selection: $appearance.preference) {
                        ForEach(AppearancePreference.allCases) { pref in
                            Label(pref.label, systemImage: pref.icon).tag(pref)
                        }
                    }
                }
            }
            .navigationTitle("更多")
            .sheet(isPresented: $showPaywall) { PaywallView() }
        }
    }
}

struct DiagnosisView: View {
    @EnvironmentObject var progress: ProgressManager

    var body: some View {
        List {
            Section("优先攻克") {
                ForEach(progress.weakNodes(limit: 12)) { item in
                    NavigationLink { NodeDetailView(node: item.node) } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(item.node.title)
                                Spacer()
                                Text("\(Int(item.accuracy * 100))%")
                                    .foregroundColor(item.accuracy < 0.5 ? .apexDanger : .secondary)
                            }
                            ProgressView(value: item.accuracy)
                                .tint(item.accuracy < 0.5 ? .apexDanger : .apexTeal)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("学情诊断")
    }
}

struct ErrorBookView: View {
    @EnvironmentObject var progress: ProgressManager

    var body: some View {
        Group {
            let items = progress.errorQuestions()
            if items.isEmpty {
                EmptyStateView(title: "暂无错题",
                               systemImage: "checkmark.seal",
                               message: "答错或收藏的题会出现在这里。")
            } else {
                List(items) { question in
                    NavigationLink { QuestionDetailView(question: question) } label: {
                        Text(question.prompt)
                            .lineLimit(2)
                    }
                }
            }
        }
        .navigationTitle("错题本")
    }
}

struct CoverageView: View {
    var body: some View {
        List {
            ForEach(Stage.allCases) { stage in
                Section(stage.title) {
                    ForEach(MainLineData.nodes.filter { $0.stage == stage }) { node in
                        NavigationLink { NodeDetailView(node: node) } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(node.title)
                                    Text("\(MainLineData.coveragePoints(for: node).count) 个考点 · \(QuestionBank.questions(nodeId: node.id).count) 道题")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                let sCount = MainLineData.coveragePoints(for: node).filter { $0.grade == .s }.count
                                if sCount > 0 {
                                    TagChip(text: "S \(sCount)", color: .apexRed)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("考点覆盖")
    }
}

struct WeaponShelfView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    var body: some View {
        List {
            ForEach(Array(WeaponGuideData.all.enumerated()), id: \.element.id) { index, guide in
                if purchase.isWeaponPremiumLocked(index: index) {
                    Button { showPaywall = true } label: {
                        WeaponRow(guide: guide, locked: true)
                    }
                    .buttonStyle(.plain)
                } else {
                    NavigationLink { WeaponDetailView(guide: guide) } label: {
                        WeaponRow(guide: guide, locked: false)
                    }
                }
            }
        }
        .navigationTitle("秒杀武器库")
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }
}

private struct WeaponRow: View {
    let guide: WeaponGuide
    let locked: Bool

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: locked ? "crown.fill" : guide.weapon.icon)
                .foregroundColor(locked ? .apexGold : .apexTeal)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 3) {
                Text(guide.weapon.name)
                    .foregroundColor(.primary)
                Text(guide.tagline)
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack(spacing: Spacing.sm) {
                    TagChip(text: "\(PracticeLinker.choiceQuestions(for: guide).count) 选择题", color: .apexBlue)
                    TagChip(text: "\(PracticeLinker.subjectiveQuestions(for: guide).count) 主观题", color: .apexTeal)
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct WeaponDetailView: View {
    let guide: WeaponGuide
    private var choiceQuestions: [HistoryQuestion] { PracticeLinker.choiceQuestions(for: guide) }
    private var subjectiveQuestions: [SubjectiveQuestion] { PracticeLinker.subjectiveQuestions(for: guide) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Image(systemName: guide.weapon.icon)
                        .font(.title)
                        .foregroundColor(.apexTeal)
                    Text(guide.weapon.name)
                        .font(.title2.weight(.bold))
                    Text(guide.tagline)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .cardSurface()

                bulletBlock("何时用", icon: "scope", color: .apexGold, items: guide.whenToUse)
                bulletBlock("怎么用", icon: "list.number", color: .apexTeal, items: guide.steps)
                choicePracticeBlock(title: "关联选择题", questions: Array(choiceQuestions.prefix(8)))
                subjectivePracticeBlock(title: "关联主观题", questions: Array(subjectiveQuestions.prefix(6)))

                if let id = guide.exampleCaseId, let duel = BossDuelData.duel(id: id) {
                    NavigationLink { DuelDetailView(duel: duel) } label: {
                        HStack {
                            Label("查看 Boss 对决", systemImage: "bolt.shield")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.apexRed)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.card))
                    }
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("武器详情")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func bulletBlock(_ title: String, icon: String, color: Color, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: title, systemImage: icon, accent: color)
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text("\(index + 1)")
                        .font(AppFont.chip)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(color)
                        .clipShape(Circle())
                    Text(item)
                        .font(.subheadline)
                }
            }
        }
        .cardSurface()
    }

    private func choicePracticeBlock(title: String, questions: [HistoryQuestion]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: title, systemImage: "checkmark.seal", accent: .apexBlue)
            ForEach(questions) { question in
                NavigationLink { QuestionDetailView(question: question) } label: {
                    practiceRow(question.prompt, subtitle: MainLineData.knowledge(id: question.knowledgeId)?.title, color: .apexBlue)
                }
                .buttonStyle(.plain)
            }
        }
        .cardSurface()
    }

    private func subjectivePracticeBlock(title: String, questions: [SubjectiveQuestion]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: title, systemImage: "text.append", accent: .apexRed)
            ForEach(questions) { question in
                NavigationLink { SubjectiveQuestionDetailView(item: question) } label: {
                    practiceRow(question.prompt, subtitle: MainLineData.knowledge(id: question.knowledgeId)?.title, color: .apexRed)
                }
                .buttonStyle(.plain)
            }
        }
        .cardSurface()
    }

    private func practiceRow(_ title: String, subtitle: String?, color: Color) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: "arrow.right.circle")
                .foregroundColor(color)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}

struct DuelListView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    var body: some View {
        List {
            ForEach(Array(BossDuelData.all.enumerated()), id: \.element.id) { index, duel in
                if purchase.isDuelPremiumLocked(index: index) {
                    Button { showPaywall = true } label: {
                        duelRow(duel, locked: true)
                    }
                    .buttonStyle(.plain)
                } else {
                    NavigationLink { DuelDetailView(duel: duel) } label: {
                        duelRow(duel, locked: false)
                    }
                }
            }
        }
        .navigationTitle("Boss 对决")
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    private func duelRow(_ duel: BossDuel, locked: Bool) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: locked ? "crown.fill" : duel.weapon.icon)
                .foregroundColor(locked ? .apexGold : .apexRed)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 3) {
                Text(duel.title)
                    .foregroundColor(.primary)
                Text(duel.keyInsight)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                TagChip(text: "\(PracticeLinker.choiceQuestions(for: duel).count) 关联题", color: .apexBlue)
            }
            Spacer()
        }
    }
}
