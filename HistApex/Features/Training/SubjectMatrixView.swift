import SwiftUI

struct SubjectMatrixView: View {
    var body: some View {
        List {
            Section("主体职责速查") {
                ForEach(SubjectMatrixData.all) { subject in
                    NavigationLink { SubjectDetailView(subject: subject) } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(subject.title)
                                .font(AppFont.cardTitle)
                            Text(subject.role)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack {
                                ForEach(subject.triggerWords.prefix(3), id: \.self) { word in
                                    TagChip(text: word, color: .apexTeal)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("历史主体矩阵")
    }
}

struct SubjectDetailView: View {
    let subject: SubjectResponsibility
    private var choiceQuestions: [HistoryQuestion] { PracticeLinker.choiceQuestions(for: subject) }
    private var subjectiveQuestions: [SubjectiveQuestion] { PracticeLinker.subjectiveQuestions(for: subject) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(subject.title)
                        .font(.title2.weight(.bold))
                    Text(subject.role)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack {
                        ForEach(subject.triggerWords, id: \.self) { word in
                            TagChip(text: word, color: .apexGold)
                        }
                    }
                }
                .cardSurface()

                bulletBlock("能做什么", icon: "checkmark.circle", color: .apexEmerald, items: subject.canDo)
                bulletBlock("不能写什么", icon: "xmark.octagon", color: .apexDanger, items: subject.cannotDo)

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "关联考点", systemImage: "link", accent: .apexTeal)
                    ForEach(subject.knowledgeIds, id: \.self) { id in
                        if let point = MainLineData.knowledge(id: id) {
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(point.title)
                                        .font(AppFont.cardTitle)
                                    TagChip(text: "\(point.grade.rawValue)级", color: .grade(point.grade))
                                }
                                Text(point.detail)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 3)
                        }
                    }
                }
                .cardSurface()

                practiceBlock
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("主体详情")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var practiceBlock: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "关联练习", systemImage: "pencil.and.list.clipboard", accent: .apexBlue)
            ForEach(choiceQuestions.prefix(5)) { question in
                NavigationLink { QuestionDetailView(question: question) } label: {
                    practiceLine(question.prompt, subtitle: "选择题", color: .apexBlue)
                }
                .buttonStyle(.plain)
            }
            ForEach(subjectiveQuestions.prefix(3)) { question in
                NavigationLink { SubjectiveQuestionDetailView(item: question) } label: {
                    practiceLine(question.prompt, subtitle: "主观题", color: .apexRed)
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

    private func bulletBlock(_ title: String, icon: String, color: Color, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: title, systemImage: icon, accent: color)
            ForEach(items, id: \.self) { item in
                Label(item, systemImage: icon)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        .cardSurface()
    }
}
