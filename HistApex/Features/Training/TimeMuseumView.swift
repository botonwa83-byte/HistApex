import SwiftUI

struct TimeMuseumView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                ForEach(TimeMuseumData.all) { exhibit in
                    NavigationLink { TimeMuseumDetailView(exhibit: exhibit) } label: {
                        exhibitRow(exhibit)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("穿越策展馆")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "ticket")
                    .foregroundColor(.apexGold)
                Text("轻松逛展，顺手背高频点")
                    .font(AppFont.cardTitle)
            }
            Text("每件展品都藏着一个高考历史必考点：先看文物线索，再带走一句能写进答案的高分句。")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack(spacing: Spacing.sm) {
                TagChip(text: "\(TimeMuseumData.all.count) 件展品", color: .apexGold)
                TagChip(text: "S/A 高频", color: .apexRed)
                TagChip(text: "接回题库", color: .apexBlue)
            }
        }
        .cardSurface()
    }

    private func exhibitRow(_ exhibit: TimeMuseumExhibit) -> some View {
        HStack(spacing: Spacing.md) {
            IconBadge(systemImage: "building.columns", color: .apexGold, size: 46)
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: Spacing.xs) {
                    Text(exhibit.title)
                        .font(AppFont.cardTitle)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    TagChip(text: exhibit.era, color: .apexLava)
                }
                Text(exhibit.artifact)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                Text(exhibit.miniMission)
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

struct TimeMuseumDetailView: View {
    let exhibit: TimeMuseumExhibit

    private var points: [KnowledgePoint] {
        exhibit.knowledgeIds.compactMap { MainLineData.knowledge(id: $0) }
    }

    private var choiceQuestions: [HistoryQuestion] {
        PracticeLinker.choiceQuestions(knowledgeIds: exhibit.knowledgeIds)
    }

    private var subjectiveQuestions: [SubjectiveQuestion] {
        PracticeLinker.subjectiveQuestions(knowledgeIds: exhibit.knowledgeIds)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                exhibitCard
                missionCard
                examPointCard
                linkedKnowledgeCard
                practiceCard
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(exhibit.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var exhibitCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                TagChip(text: exhibit.era, color: .apexLava)
                TagChip(text: exhibit.stampTitle, color: .apexGold)
            }
            Text(exhibit.artifact)
                .font(.title3.weight(.bold))
            Text(exhibit.scene)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .cardSurface()
    }

    private var missionCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "策展人提示", systemImage: "sparkles", accent: .apexGold)
            Text(exhibit.curatorNote)
                .font(.subheadline)
            Divider()
            Label(exhibit.miniMission, systemImage: "checkmark.seal")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.apexTeal)
        }
        .cardSurface()
    }

    private var examPointCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "展品背后的必考点", systemImage: "seal", accent: .apexRed)
            Text(exhibit.hiddenExamPoint)
                .font(.subheadline.weight(.semibold))
            Label(exhibit.wrongTurn, systemImage: "exclamationmark.triangle")
                .font(.caption)
                .foregroundColor(.apexDanger)
            ForEach(exhibit.rewardSentences, id: \.self) { sentence in
                Label(sentence, systemImage: "quote.bubble")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .cardSurface()
    }

    private var linkedKnowledgeCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "带走考点卡", systemImage: "shippingbox", accent: .apexTeal)
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
        .cardSurface()
    }

    private var practiceCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "逛完就练", systemImage: "pencil.and.list.clipboard", accent: .apexBlue)
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
