import SwiftUI

struct AnswerTemplateView: View {
    var body: some View {
        List {
            Section("主观题模板") {
                ForEach(AnswerTemplateData.all) { item in
                    NavigationLink { AnswerTemplateDetailView(item: item) } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(AppFont.cardTitle)
                            Text(item.promptType)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("答案模板库")
    }
}

struct AnswerTemplateDetailView: View {
    let item: AnswerTemplate
    private var choiceQuestions: [HistoryQuestion] { PracticeLinker.choiceQuestions(for: item) }
    private var subjectiveQuestions: [SubjectiveQuestion] { PracticeLinker.subjectiveQuestions(for: item) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(item.title)
                        .font(.title2.weight(.bold))
                    Text(item.promptType)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .cardSurface()

                block("结构", icon: "list.number", color: .apexTeal, items: item.structure)
                block("开头句", icon: "text.quote", color: .apexGold, items: item.sentenceStarters)
                block("自查", icon: "checkmark.seal", color: .apexDanger, items: item.diagnostics)

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "示例", systemImage: "doc.text", accent: .apexBlue)
                    Text(item.sample)
                        .font(.body)
                }
                .cardSurface()

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "套模板练习", systemImage: "pencil.and.list.clipboard", accent: .apexRed)
                    ForEach(subjectiveQuestions.prefix(5)) { question in
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
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("模板详情")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func block(_ title: String, icon: String, color: Color, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: title, systemImage: icon, accent: color)
            ForEach(Array(items.enumerated()), id: \.offset) { index, text in
                Text("\(index + 1). \(text)")
                    .font(.subheadline)
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
}
