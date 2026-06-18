import SwiftUI

struct HistoricalSpecialView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("历史高分实验室")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                    Text("历史学科的核心不是背散点，而是时空定位、史料实证、制度演变、空间联系和论证表达。")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .cardSurface()

                ForEach(HistoricalSpecialData.all) { module in
                    NavigationLink { HistoricalSpecialDetailView(module: module) } label: {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: module.kind.icon)
                                .font(.title3)
                                .frame(width: 42, height: 42)
                                .background(module.kind.color.opacity(0.12))
                                .foregroundColor(module.kind.color)
                                .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(module.title)
                                    .font(AppFont.cardTitle)
                                    .foregroundColor(.primary)
                                Text(module.subtitle)
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
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("史学实验室")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HistoricalSpecialDetailView: View {
    let module: HistoricalSpecialModule

    private var choiceQuestions: [HistoryQuestion] {
        PracticeLinker.choiceQuestions(knowledgeIds: module.linkedKnowledgeIds)
    }

    private var subjectiveQuestions: [SubjectiveQuestion] {
        PracticeLinker.subjectiveQuestions(knowledgeIds: module.linkedKnowledgeIds)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    TagChip(text: module.kind.rawValue, color: module.kind.color)
                    Text(module.method)
                        .font(.title3.weight(.bold))
                    Text(module.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .cardSurface()

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "典型场景", systemImage: "list.bullet.rectangle", accent: module.kind.color)
                    ForEach(module.examples, id: \.self) { item in
                        Label(item, systemImage: "checkmark.circle")
                            .font(.subheadline)
                    }
                }
                .cardSurface()

                if !choiceQuestions.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: "关联选择题", systemImage: "checkmark.seal", accent: .apexBlue)
                        ForEach(choiceQuestions.prefix(5)) { question in
                            NavigationLink { QuestionDetailView(question: question) } label: {
                                Text(question.prompt)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 6)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .cardSurface()
                }

                if !subjectiveQuestions.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: "关联史料题", systemImage: "text.append", accent: .apexRed)
                        ForEach(subjectiveQuestions.prefix(3)) { question in
                            NavigationLink { SubjectiveQuestionDetailView(item: question) } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(question.prompt)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(.primary)
                                    TagChip(text: "\(question.score)分", color: .apexRed)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 6)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .cardSurface()
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(module.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
