import SwiftUI

struct TrainingView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false
    @State private var selectedFocus: TrainingFocus = .today

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    learningLoop
                    focusPicker
                    focusContent
                    coverageDashboard
                }
                .padding(Spacing.lg)
                .padding(.bottom, Spacing.xxl)
                .readableWidth()
            }
            .background(Color.apexBackground.ignoresSafeArea())
            .navigationTitle("历史训练场")
            .sheet(isPresented: $showPaywall) { PaywallView() }
        }
    }

    private enum TrainingFocus: String, CaseIterable, Identifiable {
        case today = "今日"
        case exam = "套练"
        case methods = "方法"
        case archive = "题库"

        var id: String { rawValue }
    }

    private var focusPicker: some View {
        Picker("训练分区", selection: $selectedFocus) {
            ForEach(TrainingFocus.allCases) { focus in
                Text(focus.rawValue).tag(focus)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private var focusContent: some View {
        switch selectedFocus {
        case .today:
            todaySection
            premiumValueCard
        case .exam:
            examPracticeSection
            subjectivePracticePreview
        case .methods:
            methodModules
        case .archive:
            materialCasesPreview
            bossDuelsPreview
            memoryCards
        }
    }

    private var coverageDashboard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "考点全覆盖", systemImage: "checklist.checked", accent: .apexTeal)
            HStack(spacing: Spacing.md) {
                stat("\(MainLineData.allKnowledgePoints.count)", "考点", .apexTeal)
                stat("\(QuestionBank.all.count)", "选择题", .apexBlue)
                stat("\(SubjectiveQuestionData.all.count)", "非选择题", .apexRed)
            }
            HStack(spacing: Spacing.sm) {
                ForEach(ImportanceGrade.allCases.reversed()) { grade in
                    let count = MainLineData.allKnowledgePoints.filter { $0.grade == grade }.count
                    TagChip(text: "\(grade.rawValue) \(count)", color: .grade(grade))
                }
            }
        }
        .cardSurface()
    }

    private var todaySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "今日冲刺", systemImage: "target", accent: .apexLava)
            NavigationLink { ExamPracticeSetView(set: ExamPracticeData.all[0]) } label: {
                compactActionRow(icon: "timer",
                                 title: "按高考比例做一套",
                                 subtitle: "16 道选择题 + 4 道非选择题，先练最接近考场的结构。",
                                 value: "100分",
                                 color: .apexLava)
            }
            .buttonStyle(.plain)

            NavigationLink { TrapDrillView() } label: {
                compactActionRow(icon: "exclamationmark.triangle",
                                 title: "先排选择题陷阱",
                                 subtitle: "时间错位、主体错配、因果倒置、绝对化表述。",
                                 value: "\(TrapDrillData.all.count)",
                                 color: .apexBlue)
            }
            .buttonStyle(.plain)

            if let item = SubjectiveQuestionData.all.first(where: { $0.grade == .s }) {
                NavigationLink { SubjectiveQuestionDetailView(item: item) } label: {
                    compactActionRow(icon: "text.append",
                                     title: "练一道高权重主观题",
                                     subtitle: item.prompt,
                                     value: "\(item.score)分",
                                     color: .apexRed)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var examPracticeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "高考比例套练", systemImage: "doc.text.magnifyingglass", accent: .apexLava)
            HStack(spacing: Spacing.md) {
                stat("\(ExamPracticeBlueprint.choiceScore)", "选择题分", .apexBlue)
                stat("\(ExamPracticeBlueprint.subjectiveScore)", "非选择分", .apexRed)
                stat("\(ExamPracticeBlueprint.choiceQuestionCount)+\(ExamPracticeBlueprint.subjectiveQuestionCount)", "题型结构", .apexGold)
            }
            Text(ExamPracticeBlueprint.sourceNote)
                .font(.caption)
                .foregroundColor(.secondary)
            ForEach(ExamPracticeData.all.prefix(3)) { set in
                NavigationLink { ExamPracticeSetView(set: set) } label: {
                    HStack(spacing: Spacing.md) {
                        Image(systemName: "timer")
                            .font(.title3)
                            .frame(width: 42, height: 42)
                            .background(Color.apexLava.opacity(0.12))
                            .foregroundColor(.apexLava)
                            .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(set.title)
                                .font(AppFont.cardTitle)
                                .foregroundColor(.primary)
                            Text("按分值配比：选择题 \(set.choiceScore) 分 + 非选择题 \(set.subjectiveScore) 分")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .cardSurface()
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var subjectivePracticePreview: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "非选择题专项", systemImage: "text.append", accent: .apexRed)
            ForEach(SubjectiveQuestionData.all.prefix(4)) { item in
                NavigationLink { SubjectiveQuestionDetailView(item: item) } label: {
                    subjectiveRow(item)
                }
                .buttonStyle(.plain)
            }
            NavigationLink { SubjectivePracticeListView() } label: {
                compactActionRow(icon: "tray.full",
                                 title: "查看全部主观题",
                                 subtitle: "按材料分析、原因背景、影响意义、评析和小论文继续练。",
                                 value: "\(SubjectiveQuestionData.all.count)",
                                 color: .apexRed)
            }
            .buttonStyle(.plain)
        }
    }

    private func stat(_ value: String, _ label: String, _ color: Color) -> some View {
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

    private var expansionModules: some View {
        methodModules
    }

    private var learningLoop: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "提分闭环", systemImage: "arrow.triangle.2.circlepath", accent: .apexLava)
            HStack(spacing: Spacing.sm) {
                loopStep("学", "主线考点", .apexLava)
                loopStep("练", "选择/主观", .apexBlue)
                loopStep("拆", "材料切片", .apexGold)
                loopStep("复", "错题复习", .apexTeal)
            }
            Text("下面每个模块都接回题库：看完方法后直接练关联选择题和主观题。")
                .font(.caption)
                .foregroundColor(.secondary)
            HStack(spacing: Spacing.sm) {
                TagChip(text: "史料实证", color: .apexTeal)
                TagChip(text: "时空观念", color: .apexBlue)
                TagChip(text: "历史解释", color: .apexGold)
                TagChip(text: "家国情怀", color: .apexRed)
            }
        }
        .cardSurface()
    }

    private func loopStep(_ mark: String, _ title: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(mark)
                .font(AppFont.cardTitle)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(color)
                .clipShape(Circle())
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var premiumValueCard: some View {
        if !purchase.isUnlocked {
            Button { showPaywall = true } label: {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    HStack(spacing: Spacing.md) {
                        Image(systemName: "crown.fill")
                            .font(.title3)
                            .foregroundColor(.apexGold)
                            .frame(width: 42, height: 42)
                            .background(Color.apexGold.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(PremiumContentPlan.title)
                                .font(AppFont.cardTitle)
                                .foregroundColor(.primary)
                            Text(PremiumContentPlan.unlockSummary)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        Spacer(minLength: 0)
                        TagChip(text: purchase.product?.displayPrice ?? "¥22", color: .apexGold)
                    }
                    HStack(spacing: Spacing.sm) {
                        ForEach(PremiumContentPlan.pillars.prefix(3)) { pillar in
                            TagChip(text: pillar.metric, color: .apexLava)
                        }
                    }
                }
                .cardSurface()
            }
            .buttonStyle(.plain)
        }
    }

    private var methodModules: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            SectionHeader(title: "方法训练区", systemImage: "square.grid.2x2", accent: .apexBlue)

            ExpandableSection(
                title: "复习与排雷",
                systemImage: "target",
                accent: .apexRed,
                initiallyExpanded: true,
                badge: "基础必备"
            ) {
                VStack(spacing: Spacing.sm) {
                    NavigationLink { ReviewView() } label: {
                        expansionRow(icon: "calendar.badge.clock",
                                     title: "智能复习",
                                     subtitle: "按 S/A/B/C 权重安排复习间隔",
                                     value: "\(ReviewProgressManager.shared.dueCards.count)")
                    }
                    .buttonStyle(.plain)

                    NavigationLink { TrapDrillView() } label: {
                        expansionRow(icon: "exclamationmark.triangle",
                                     title: "选择题排雷靶场",
                                     subtitle: "主体错配、绝对化、因果倒置等六类错因",
                                     value: "\(TrapDrillData.all.count)")
                    }
                    .buttonStyle(.plain)
                }
            }
            .cardSurface()

            ExpandableSection(
                title: "趣味记忆",
                systemImage: "brain.head.profile",
                accent: .apexGold,
                badge: "轻松提分"
            ) {
                VStack(spacing: Spacing.sm) {
                    NavigationLink { SubjectMatrixView() } label: {
                        expansionRow(icon: "tablecells",
                                     title: "历史主体矩阵",
                                     subtitle: "皇帝、士人、资产阶级、人民群众等历史主体",
                                     value: "\(SubjectMatrixData.all.count)")
                    }
                    .buttonStyle(.plain)

                    NavigationLink { TimeMuseumView() } label: {
                        expansionRow(icon: "ticket",
                                     title: "穿越策展馆",
                                     subtitle: "用文物、展柜和小任务轻松带走必考点",
                                     value: "\(TimeMuseumData.all.count)")
                    }
                    .buttonStyle(.plain)

                    NavigationLink { HistoryEncounterView() } label: {
                        expansionRow(icon: "person.2.wave.2",
                                     title: "时空会客厅",
                                     subtitle: "让历史人物和著名事件相遇，轻松记住高考考点",
                                     value: "\(HistoryEncounterData.all.count)")
                    }
                    .buttonStyle(.plain)
                }
            }
            .cardSurface()

            ExpandableSection(
                title: "方法与模型",
                systemImage: "function",
                accent: .apexViolet,
                badge: "提分核心"
            ) {
                VStack(spacing: Spacing.sm) {
                    NavigationLink { HistoryPatternView() } label: {
                        expansionRow(icon: "sparkles.rectangle.stack",
                                     title: "历史规律引擎",
                                     subtitle: "把制度、经济、思想、世界格局抽成可迁移答题模型",
                                     value: "\(HistoryPatternData.all.count)")
                    }
                    .buttonStyle(.plain)

                    NavigationLink { HistoricalSpecialView() } label: {
                        expansionRow(icon: "timeline.selection",
                                     title: "史学实验室",
                                     subtitle: "时间轴、史料侦探、制度演变、地图空间、武器雷达",
                                     value: "\(HistoricalSpecialData.all.count)")
                    }
                    .buttonStyle(.plain)
                }
            }
            .cardSurface()

            ExpandableSection(
                title: "答题武器库",
                systemImage: "shield.lefthalf.filled",
                accent: .apexTeal
            ) {
                VStack(spacing: Spacing.sm) {
                    NavigationLink { AnswerTemplateView() } label: {
                        expansionRow(icon: "doc.text",
                         title: "答案模板库",
                                     subtitle: "背景、影响、比较、评析、历史小论文",
                                     value: "\(AnswerTemplateData.all.count)")
                    }
                    .buttonStyle(.plain)

                    NavigationLink { WeaponShelfView() } label: {
                        expansionRow(icon: "shield.lefthalf.filled",
                                     title: "秒杀武器库",
                                     subtitle: "每把武器都接回关联选择题和主观题",
                                     value: "\(WeaponGuideData.all.count)")
                    }
                    .buttonStyle(.plain)
                }
            }
            .cardSurface()
        }
    }

    private func expansionRow(icon: String, title: String, subtitle: String, value: String) -> some View {
        HStack(spacing: Spacing.md) {
            IconBadge(systemImage: icon, color: .apexBlue)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(AppFont.cardTitle)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
            TagChip(text: value, color: .apexBlue)
        }
        .cardSurface()
    }

    private var materialCasesPreview: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "材料切片机", systemImage: "scissors", accent: .apexGold)
            ExpandableSection(
                title: "精选材料案例",
                systemImage: "doc.text.magnifyingglass",
                accent: .apexGold,
                initiallyExpanded: true,
                badge: "\(MaterialCaseData.all.count) 例"
            ) {
                VStack(spacing: Spacing.sm) {
                    ForEach(Array(MaterialCaseData.all.prefix(3).enumerated()), id: \.element.id) { index, item in
                        if purchase.isMaterialCasePremiumLocked(index: index) {
                            Button { showPaywall = true } label: {
                                MaterialCaseRow(item: item, locked: true)
                            }
                            .buttonStyle(.plain)
                        } else {
                            NavigationLink { MaterialCaseDetailView(item: item) } label: {
                                MaterialCaseRow(item: item, locked: false)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .cardSurface()
            NavigationLink { MaterialCaseListView() } label: {
                compactActionRow(icon: "tray.full",
                                 title: "查看全部材料案例",
                                 subtitle: "从史料出处、时间、立场和有效信息切入。",
                                 value: "\(MaterialCaseData.all.count)",
                                 color: .apexGold)
            }
            .buttonStyle(.plain)
        }
    }

    private var bossDuelsPreview: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "Boss 双解对决", systemImage: "bolt.shield", accent: .apexRed)
            ExpandableSection(
                title: "热门对决",
                systemImage: "bolt.shield",
                accent: .apexRed,
                initiallyExpanded: true,
                badge: "\(BossDuelData.all.count) 场"
            ) {
                VStack(spacing: Spacing.sm) {
                    ForEach(Array(BossDuelData.all.prefix(3).enumerated()), id: \.element.id) { index, duel in
                        if purchase.isDuelPremiumLocked(index: index) {
                            Button { showPaywall = true } label: {
                                BossDuelTrainingRow(duel: duel, locked: true)
                            }
                            .buttonStyle(.plain)
                        } else {
                            NavigationLink { DuelDetailView(duel: duel) } label: {
                                BossDuelTrainingRow(duel: duel, locked: false)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .cardSurface()
            NavigationLink { BossDuelListView() } label: {
                compactActionRow(icon: "bolt.shield",
                                 title: "查看全部 Boss 对决",
                                 subtitle: "同一道题对比常规解和武器解，训练提速路径。",
                                 value: "\(BossDuelData.all.count)",
                                 color: .apexRed)
            }
            .buttonStyle(.plain)
        }
    }

    private var memoryCards: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "高权重记忆引擎", systemImage: "brain.head.profile", accent: .apexViolet)
            ExpandableSection(
                title: "记忆卡片分类",
                systemImage: "square.stack.3d.up",
                accent: .apexViolet,
                initiallyExpanded: true
            ) {
                VStack(spacing: Spacing.sm) {
                    ForEach(MemoryCardType.allCases) { type in
                        NavigationLink { MemoryCardListView(type: type) } label: {
                            let count = MemoryData.cards(type: type).count
                            HStack {
                                Text(type.rawValue)
                                    .font(AppFont.cardTitle)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(count) 张")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
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
            .cardSurface()
        }
    }

    private func subjectiveRow(_ item: SubjectiveQuestion) -> some View {
        HStack(spacing: Spacing.md) {
            IconBadge(systemImage: "pencil.and.list.clipboard", color: .grade(item.grade))
            VStack(alignment: .leading, spacing: 3) {
                Text(item.prompt)
                    .font(AppFont.cardTitle)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                HStack {
                    TagChip(text: "\(item.grade.rawValue)级", color: .grade(item.grade))
                    TagChip(text: item.questionType.shortName, color: .apexTeal)
                    TagChip(text: "\(item.score)分", color: .apexRed)
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .cardSurface()
    }

    private func compactActionRow(icon: String, title: String, subtitle: String, value: String, color: Color) -> some View {
        HStack(spacing: Spacing.md) {
            IconBadge(systemImage: icon, color: color)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(AppFont.cardTitle)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
            TagChip(text: value, color: color)
        }
        .cardSurface()
    }
}

struct MaterialCaseListView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Spacing.md) {
                ForEach(Array(MaterialCaseData.all.enumerated()), id: \.element.id) { index, item in
                    if purchase.isMaterialCasePremiumLocked(index: index) {
                        Button { showPaywall = true } label: {
                            MaterialCaseRow(item: item, locked: true)
                        }
                        .buttonStyle(.plain)
                    } else {
                        NavigationLink { MaterialCaseDetailView(item: item) } label: {
                            MaterialCaseRow(item: item, locked: false)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("材料切片机")
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }
}

struct BossDuelListView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Spacing.md) {
                ForEach(Array(BossDuelData.all.enumerated()), id: \.element.id) { index, duel in
                    if purchase.isDuelPremiumLocked(index: index) {
                        Button { showPaywall = true } label: {
                            BossDuelTrainingRow(duel: duel, locked: true)
                        }
                        .buttonStyle(.plain)
                    } else {
                        NavigationLink { DuelDetailView(duel: duel) } label: {
                            BossDuelTrainingRow(duel: duel, locked: false)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("Boss 对决")
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }
}

struct SubjectivePracticeListView: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Spacing.md) {
                ForEach(SubjectiveQuestionData.all) { item in
                    NavigationLink { SubjectiveQuestionDetailView(item: item) } label: {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "pencil.and.list.clipboard")
                                .font(.title3)
                                .frame(width: 42, height: 42)
                                .background(Color.grade(item.grade).opacity(0.12))
                                .foregroundColor(.grade(item.grade))
                                .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.prompt)
                                    .font(AppFont.cardTitle)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                HStack {
                                    TagChip(text: "\(item.grade.rawValue)级", color: .grade(item.grade))
                                    TagChip(text: item.questionType.shortName, color: .apexTeal)
                                    TagChip(text: "\(item.score)分", color: .apexRed)
                                }
                            }
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .cardSurface()
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("非选择题专项")
    }
}

private struct MaterialCaseRow: View {
    let item: MaterialCase
    let locked: Bool

    var body: some View {
        HStack(spacing: Spacing.md) {
            IconBadge(
                systemImage: locked ? "crown.fill" : "doc.text.magnifyingglass",
                color: locked ? .apexGold : .apexTeal
            )
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(AppFont.cardTitle)
                    .foregroundColor(.primary)
                Text("\(item.subject) · \(item.goal)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
            if locked {
                TagChip(text: "完整版", color: .apexGold)
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .cardSurface()
    }
}

private struct BossDuelTrainingRow: View {
    let duel: BossDuel
    let locked: Bool

    var body: some View {
        HStack(spacing: Spacing.md) {
            IconBadge(
                systemImage: locked ? "crown.fill" : duel.weapon.icon,
                color: locked ? .apexGold : .apexRed
            )
            VStack(alignment: .leading, spacing: 3) {
                Text(duel.title)
                    .font(AppFont.cardTitle)
                    .foregroundColor(.primary)
                Text(duel.keyInsight)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                HStack(spacing: Spacing.sm) {
                    TagChip(text: duel.weapon.name, color: .apexRed)
                    TagChip(text: "\(PracticeLinker.choiceQuestions(for: duel).count) 题", color: .apexBlue)
                }
            }
            Spacer(minLength: 0)
            if locked {
                TagChip(text: "完整版", color: .apexGold)
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .cardSurface()
    }
}

struct MaterialCaseDetailView: View {
    let item: MaterialCase
    private var choiceQuestions: [HistoryQuestion] { PracticeLinker.choiceQuestions(for: item) }
    private var subjectiveQuestions: [SubjectiveQuestion] { PracticeLinker.subjectiveQuestions(for: item) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(item.title)
                        .font(.title2.weight(.bold))
                    Text(item.material)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(item.question)
                        .font(AppFont.cardTitle)
                }
                .cardSurface()

                slicerGrid
                answerBlock
                linkedPracticeBlock
                diagnosticsBlock
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("材料切片")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var slicerGrid: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "五刀切开", systemImage: "scissors", accent: .apexGold)
            slice("主体", item.subject, .apexRed)
            slice("行为", item.action, .apexTeal)
            slice("对象", item.object, .apexBlue)
            slice("目标", item.goal, .apexGold)
            slice("召回考点", item.knowledgeIds.compactMap { MainLineData.knowledge(id: $0)?.title }.joined(separator: "、"), .apexViolet)
        }
        .cardSurface()
    }

    private func slice(_ title: String, _ value: String, _ color: Color) -> some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            TagChip(text: title, color: color)
            Text(value)
                .font(.subheadline)
            Spacer(minLength: 0)
        }
    }

    private var answerBlock: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "答案句", systemImage: "text.quote", accent: .apexTeal)
            ForEach(Array(item.answerSentences.enumerated()), id: \.offset) { index, sentence in
                Text("\(index + 1). \(sentence)")
                    .font(.subheadline)
            }
        }
        .cardSurface()
    }

    private var linkedPracticeBlock: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "关联练习", systemImage: "pencil.and.list.clipboard", accent: .apexBlue)
            ForEach(subjectiveQuestions.prefix(4)) { question in
                NavigationLink { SubjectiveQuestionDetailView(item: question) } label: {
                    practiceLine(question.prompt, subtitle: "主观题", color: .apexRed)
                }
                .buttonStyle(.plain)
            }
            ForEach(choiceQuestions.prefix(4)) { question in
                NavigationLink { QuestionDetailView(question: question) } label: {
                    practiceLine(question.prompt, subtitle: "选择题", color: .apexBlue)
                }
                .buttonStyle(.plain)
            }
        }
        .cardSurface()
    }

    private func practiceLine(_ title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: Spacing.md) {
            TagChip(text: subtitle, color: color)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(2)
            Spacer(minLength: 0)
        }
        .padding(.vertical, 3)
    }

    private var diagnosticsBlock: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "扣分提醒", systemImage: "exclamationmark.triangle", accent: .apexDanger)
            ForEach(item.diagnostics, id: \.self) { text in
                Label(text, systemImage: "checkmark.circle")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .cardSurface()
    }
}

struct SubjectiveQuestionDetailView: View {
    let item: SubjectiveQuestion

    private var bridge: KnowledgeBridge? {
        MainLineData.knowledge(id: item.knowledgeId).flatMap { KnowledgeBridgeData.bridge(for: $0) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    TagChip(text: "\(item.grade.rawValue)级", color: .grade(item.grade))
                    TagChip(text: item.questionType.rawValue, color: .apexTeal)
                    TagChip(text: "\(item.score)分", color: .apexRed)
                    Text(item.material)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(item.prompt)
                        .font(.title3.weight(.bold))
                }
                .cardSurface()

                scorePathBlock

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "采分点", systemImage: "list.bullet.clipboard", accent: .apexRed)
                    ForEach(Array(item.answerPoints.enumerated()), id: \.offset) { index, point in
                        HStack(alignment: .top, spacing: Spacing.sm) {
                            Text("\(index + 1)")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.white)
                                .frame(width: 22, height: 22)
                                .background(Color.apexRed)
                                .clipShape(Circle())
                            Text(point)
                                .font(.subheadline)
                        }
                    }
                }
                .cardSurface()

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "自查清单", systemImage: "checkmark.seal", accent: .apexTeal)
                    ForEach(item.diagnostics, id: \.self) { text in
                        Label(text, systemImage: "square")
                            .font(.subheadline)
                    }
                }
                .cardSurface()

                if let bridge {
                    KnowledgeBridgeDetailPanel(bridge: bridge)
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("主观题训练")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var scorePathBlock: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "三步拿分法", systemImage: "wand.and.stars", accent: .apexGold)
            HStack(alignment: .top, spacing: Spacing.sm) {
                scoreStep("1", "定题型", "\(item.questionType.shortName)题先确定设问动词和分值。", .apexGold)
                scoreStep("2", "切材料", "圈时间、主体、行动、评价词，先拿材料分。", .apexTeal)
                scoreStep("3", "补所学", "用考点术语补背景、影响和局限。", .apexRed)
            }
            Text("高分关键：先让阅卷老师看到结构，再让史实服务结构。不要把材料摘抄和教材背诵分开写。")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .cardSurface()
    }

    private func scoreStep(_ number: String, _ title: String, _ detail: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(number)
                .font(.caption.weight(.black))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(color)
                .clipShape(Circle())
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(.primary)
            Text(detail)
                .font(.caption2)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.sm)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
    }
}

struct ExamPracticeSetView: View {
    let set: ExamPracticeSet

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text(set.title)
                        .font(.title2.weight(.bold))
                    Text(ExamPracticeBlueprint.sourceNote)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack(spacing: Spacing.md) {
                        scoreBlock("\(set.choiceScore)", "选择题分", .apexBlue)
                        scoreBlock("\(set.subjectiveScore)", "非选择分", .apexRed)
                    }
                }
                .cardSurface()

                VStack(alignment: .leading, spacing: Spacing.md) {
                    SectionHeader(title: "一、单项选择题（48分）", systemImage: "checkmark.seal", accent: .apexBlue)
                    ForEach(Array(set.choiceQuestions.enumerated()), id: \.element.id) { index, question in
                        NavigationLink { QuestionDetailView(question: question) } label: {
                            practiceRow("\(index + 1). \(question.prompt)",
                                        subtitle: MainLineData.knowledge(id: question.knowledgeId)?.title,
                                        color: .apexBlue)
                        }
                        .buttonStyle(.plain)
                    }
                }

                VStack(alignment: .leading, spacing: Spacing.md) {
                    SectionHeader(title: "二、非选择题（52分）", systemImage: "text.append", accent: .apexRed)
                    ForEach(Array(set.subjectiveQuestions.enumerated()), id: \.element.id) { index, question in
                        NavigationLink { SubjectiveQuestionDetailView(item: question) } label: {
                            practiceRow("\(index + 17). \(question.prompt)",
                                        subtitle: "\(question.questionType.rawValue) · \(question.score)分 · \(MainLineData.knowledge(id: question.knowledgeId)?.title ?? "")",
                                        color: .apexRed)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("高考比例套练")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func scoreBlock(_ value: String, _ title: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(AppFont.stat(24))
                .foregroundColor(color)
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
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
        .cardSurface(padding: Spacing.md)
    }
}

struct MemoryCardListView: View {
    let type: MemoryCardType

    private var cards: [MemoryCard] { MemoryData.cards(type: type) }

    var body: some View {
        List(cards) { card in
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack {
                    Text(card.front)
                        .font(AppFont.cardTitle)
                    Spacer()
                    TagChip(text: "\(card.grade.rawValue)级", color: .grade(card.grade))
                }
                Text(card.back)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle(type.rawValue)
    }
}
