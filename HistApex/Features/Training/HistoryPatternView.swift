import SwiftUI

struct HistoryPatternView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                ForEach(HistoryPatternData.all) { pattern in
                    NavigationLink { HistoryPatternDetailView(pattern: pattern) } label: {
                        patternRow(pattern)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("历史规律引擎")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "sparkles.rectangle.stack")
                    .foregroundColor(.apexViolet)
                Text("把难背考点变成可迁移规律")
                    .font(AppFont.cardTitle)
            }
            Text("历史不是散点仓库。抓住制度、经济、思想、世界体系和史料实证的重复结构，很多题可以用同一套思路解决。")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack(spacing: Spacing.sm) {
                TagChip(text: "\(HistoryPatternData.all.count) 条规律", color: .apexViolet)
                TagChip(text: "主观题提分", color: .apexRed)
                TagChip(text: "内购核心", color: .apexGold)
            }
        }
        .cardSurface()
    }

    private func patternRow(_ pattern: HistoryPatternCard) -> some View {
        HStack(spacing: Spacing.md) {
            IconBadge(systemImage: "function", color: .apexViolet)
            VStack(alignment: .leading, spacing: 3) {
                Text(pattern.title)
                    .font(AppFont.cardTitle)
                    .foregroundColor(.primary)
                Text(pattern.law)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
            TagChip(text: "\(pattern.knowledgeIds.count) 考点", color: .apexViolet)
        }
        .cardSurface()
    }
}

struct HistoryPatternDetailView: View {
    let pattern: HistoryPatternCard

    private var points: [KnowledgePoint] {
        pattern.knowledgeIds.compactMap { MainLineData.knowledge(id: $0) }
    }

    private var choiceQuestions: [HistoryQuestion] {
        PracticeLinker.choiceQuestions(knowledgeIds: pattern.knowledgeIds)
    }

    private var subjectiveQuestions: [SubjectiveQuestion] {
        PracticeLinker.subjectiveQuestions(knowledgeIds: pattern.knowledgeIds)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                lawCard
                applyCard
                transferCard
                answerCard
                practiceCard
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(pattern.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var lawCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            TagChip(text: "规律", color: .apexViolet)
            Text(pattern.law)
                .font(.title3.weight(.bold))
            Text(pattern.whyItWorks)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Label(pattern.wrongCounterExample, systemImage: "exclamationmark.triangle")
                .font(.caption)
                .foregroundColor(.apexDanger)
        }
        .cardSurface()
    }

    private var applyCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "看到这些信号就套用", systemImage: "scope", accent: .apexBlue)
            ForEach(pattern.examSignals, id: \.self) { signal in
                Label(signal, systemImage: "checkmark.circle")
                    .font(.subheadline)
            }
            Divider()
            SectionHeader(title: "三步写进答案", systemImage: "text.append", accent: .apexTeal)
            ForEach(Array(pattern.applySteps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text("\(index + 1)")
                        .font(AppFont.chip)
                        .foregroundColor(.white)
                        .frame(width: 22, height: 22)
                        .background(Color.apexTeal)
                        .clipShape(Circle())
                    Text(step)
                        .font(.subheadline)
                    Spacer(minLength: 0)
                }
            }
        }
        .cardSurface()
    }

    private var transferCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "一条规律迁移多个考点", systemImage: "arrow.triangle.branch", accent: .apexGold)
            ForEach(pattern.transferCases, id: \.self) { item in
                Label(item, systemImage: "arrow.right.circle")
                    .font(.subheadline)
            }
            Text(pattern.premiumHook)
                .font(.caption)
                .foregroundColor(.apexGold)
                .padding(.top, Spacing.xs)
            ForEach(points) { point in
                HStack(spacing: Spacing.sm) {
                    TagChip(text: "\(point.grade.rawValue)级", color: .grade(point.grade))
                    Text(point.title)
                        .font(.caption)
                    Spacer(minLength: 0)
                }
            }
        }
        .cardSurface()
    }

    private var answerCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "能直接用的高分句", systemImage: "text.quote", accent: .apexRed)
            ForEach(pattern.answerLines, id: \.self) { line in
                Label(line, systemImage: "quote.bubble")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .cardSurface()
    }

    private var practiceCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "用规律练题", systemImage: "pencil.and.list.clipboard", accent: .apexBlue)
            ForEach(subjectiveQuestions.prefix(2)) { question in
                NavigationLink { SubjectiveQuestionDetailView(item: question) } label: {
                    practiceLine(question.prompt, tag: question.questionType.shortName, color: .apexRed)
                }
                .buttonStyle(.plain)
            }
            ForEach(choiceQuestions.prefix(3)) { question in
                NavigationLink { QuestionDetailView(question: question) } label: {
                    practiceLine(question.prompt, tag: "选择题", color: .apexBlue)
                }
                .buttonStyle(.plain)
            }
        }
        .cardSurface()
    }

    private func practiceLine(_ title: String, tag: String, color: Color) -> some View {
        HStack(spacing: Spacing.md) {
            TagChip(text: tag, color: color)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(2)
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
