NavigationLink(destination: GoalDetailView(goal: goal)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(goal.title ?? "")
                                .font(.headline)
                            ProgressView(value: goal.progress)
                            Text(goal.progressPercentText)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        if goal.isCompleted {
                            Spacer()
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    .padding(.vertical, 4)