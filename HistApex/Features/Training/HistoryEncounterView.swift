import SwiftUI

struct HistoryEncounterView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                ForEach(HistoryEncounterData.all) { encounter in
                    NavigationLink { HistoryEncounterDetailView(encounter: encounter) } label: {
                        encounterRow(encounter)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("时空会客厅")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "person.2.wave.2")
                    .foregroundColor(.apexLava)
                Text("人物遇见事件，考点自然记住")
                    .font(AppFont.cardTitle)
            }
            Text("把历史人物放回关键事件现场：听一句话、抓一个转折、带走一个高考考点。")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack(spacing: Spacing.sm) {
                TagChip(text: "\(HistoryEncounterData.all.count) 场会面", color: .apexLava)
                TagChip(text: "人物线", color: .apexGold)
                TagChip(text: "事件线", color: .apexBlue)
            }
        }
        .cardSurface()
    }

    private func encounterRow(_ encounter: HistoryEncounter) -> some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Radius.inner)
                    .fill(Color.apexLava.opacity(0.13))
                Image(systemName: "person.crop.square")
                    .font(.title3)
                    .foregroundColor(.apexLava)
            }
            .frame(width: 46, height: 46)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: Spacing.xs) {
                    Text(encounter.person)
                        .font(AppFont.cardTitle)
                        .foregroundColor(.primary)
                    TagChip(text: encounter.roleTag, color: .apexGold)
                }
                Text(encounter.event)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Text(encounter.openingLine)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .cardSurface()
    }
}

struct HistoryEncounterDetailView: View {
    let encounter: HistoryEncounter
    @State private var selectedTab: DetailTab = .scene

    private var points: [KnowledgePoint] {
        encounter.knowledgeIds.compactMap { MainLineData.knowledge(id: $0) }
    }

    private var choiceQuestions: [HistoryQuestion] {
        PracticeLinker.choiceQuestions(knowledgeIds: encounter.knowledgeIds)
    }

    private var subjectiveQuestions: [SubjectiveQuestion] {
        PracticeLinker.subjectiveQuestions(knowledgeIds: encounter.knowledgeIds)
    }

    private enum DetailTab: String, CaseIterable, Identifiable {
        case scene = "场景"
        case exam = "考点"
        case practice = "练题"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .scene: return "person.2.wave.2"
            case .exam: return "graduationcap"
            case .practice: return "pencil.and.list.clipboard"
            }
        }

        var accent: Color {
            switch self {
            case .scene: return .apexLava
            case .exam: return .apexGold
            case .practice: return .apexBlue
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                heroCard

                Picker("内容分区", selection: $selectedTab) {
                    ForEach(DetailTab.allCases) { tab in
                        Label(tab.rawValue, systemImage: tab.icon).tag(tab)
                    }
                }
                .pickerStyle(.segmented)

                switch selectedTab {
                case .scene:
                    sceneTabContent
                case .exam:
                    examTabContent
                case .practice:
                    practiceTabContent
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(encounter.person)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                TagChip(text: encounter.era, color: .apexLava)
                TagChip(text: encounter.roleTag, color: .apexGold)
            }
            Text("\(encounter.person) × \(encounter.event)")
                .font(.title2.weight(.bold))
            Text(encounter.setting)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Label(encounter.openingLine, systemImage: "quote.bubble")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.apexTeal)
                .padding(Spacing.sm)
                .background(Color.apexTeal.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
        }
        .cardSurface()
    }

    private var sceneTabContent: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            CollapsibleCard(
                title: "事件转折",
                subtitle: encounter.timelineClue,
                systemImage: "arrow.triangle.turn.up.right.circle",
                accent: .apexBlue,
                initiallyExpanded: true
            ) {
                Text(encounter.turningPoint)
                    .font(.subheadline)
                Label(encounter.timelineClue, systemImage: "timeline.selection")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, Spacing.xs)
            }

            CollapsibleCard(
                title: "高考怎么考",
                subtitle: encounter.examFocus,
                systemImage: "scope",
                accent: .apexRed
            ) {
                Text(encounter.examFocus)
                    .font(.subheadline.weight(.semibold))

                Label(encounter.studentMission, systemImage: "checkmark.seal")
                    .font(.subheadline)
                    .foregroundColor(.apexTeal)
                    .padding(.top, Spacing.xs)

                Label(encounter.wrongMemory, systemImage: "exclamationmark.triangle")
                    .font(.caption)
                    .foregroundColor(.apexDanger)
                    .padding(.top, Spacing.xs)

                SectionDivider(title: "高分句")
                    .padding(.vertical, Spacing.xs)

                ForEach(encounter.answerLines, id: \.self) { line in
                    Label(line, systemImage: "text.quote")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            CollapsibleCard(
                title: "关联考点",
                subtitle: "\(points.count) 个高考考点",
                systemImage: "link",
                accent: .apexGold
            ) {
                ForEach(points) { point in
                    HStack(alignment: .top, spacing: Spacing.md) {
                        TagChip(text: "\(point.grade.rawValue)级", color: .grade(point.grade))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(point.title)
                                .font(AppFont.cardTitle)
                            Text(point.mustReciteLines.first ?? point.detail)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(3)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 3)
                }
            }
        }
    }

    private var examTabContent: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            CollapsibleCard(
                title: "考试重点",
                subtitle: encounter.examFocus,
                systemImage: "scope",
                accent: .apexRed,
                initiallyExpanded: true
            ) {
                Text(encounter.examFocus)
                    .font(.subheadline.weight(.semibold))

                Label(encounter.studentMission, systemImage: "checkmark.seal")
                    .font(.subheadline)
                    .foregroundColor(.apexTeal)
                    .padding(.top, Spacing.xs)
            }

            CollapsibleCard(
                title: "易错提醒",
                subtitle: encounter.wrongMemory,
                systemImage: "exclamationmark.triangle",
                accent: .apexDanger
            ) {
                Label(encounter.wrongMemory, systemImage: "exclamationmark.triangle")
                    .font(.subheadline)
                    .foregroundColor(.apexDanger)
            }

            CollapsibleCard(
                title: "高分答案句",
                subtitle: "\(encounter.answerLines.count) 条可直接用",
                systemImage: "text.quote",
                accent: .apexTeal
            ) {
                ForEach(Array(encounter.answerLines.enumerated()), id: \.offset) { index, line in
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Text("\(index + 1)")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Color.apexTeal)
                            .clipShape(Circle())
                        Text(line)
                            .font(.subheadline)
                    }
                }
            }

            CollapsibleCard(
                title: "关联考点卡",
                subtitle: "\(points.count) 个考点",
                systemImage: "shippingbox",
                accent: .apexGold
            ) {
                ForEach(points) { point in
                    NavigationLink {
                        NodeDetailView(node: MainLineData.nodes.first {
                            $0.knowledgePoints.contains { $0.id == point.id }
                        } ?? MainLineData.nodes[0])
                    } label: {
                        HStack(alignment: .top, spacing: Spacing.md) {
                            TagChip(text: "\(point.grade.rawValue)级", color: .grade(point.grade))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(point.title)
                                    .font(AppFont.cardTitle)
                                    .foregroundColor(.primary)
                                Text(point.mustReciteLines.first ?? point.detail)
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
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var practiceTabContent: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            CollapsibleCard(
                title: "主观题练习",
                subtitle: "\(subjectiveQuestions.count) 道非选择题",
                systemImage: "pencil.and.outline",
                accent: .apexRed,
                initiallyExpanded: true
            ) {
                ForEach(subjectiveQuestions.prefix(3)) { question in
                    NavigationLink { SubjectiveQuestionDetailView(item: question) } label: {
                        practiceLine(question.prompt, tag: question.questionType.shortName, color: .apexRed, score: "\(question.score)分")
                    }
                    .buttonStyle(.plain)
                }
            }

            CollapsibleCard(
                title: "选择题练习",
                subtitle: "\(choiceQuestions.count) 道选择题",
                systemImage: "checkmark.seal",
                accent: .apexBlue
            ) {
                ForEach(choiceQuestions.prefix(5)) { question in
                    NavigationLink { QuestionDetailView(question: question) } label: {
                        practiceLine(question.prompt, tag: "选择题", color: .apexBlue)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func practiceLine(_ title: String, tag: String, color: Color, score: String? = nil) -> some View {
        HStack(spacing: Spacing.md) {
            TagChip(text: tag, color: color)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(2)
            Spacer(minLength: 0)
            if let score {
                TagChip(text: score, color: .apexGold)
            }
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
