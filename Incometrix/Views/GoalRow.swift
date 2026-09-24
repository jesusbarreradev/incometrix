//
//  GoalRow.swift
//  Incometrix
//
//  Created by cyberfortress on 22/09/26.
//
import SwiftUI

struct GoalRow: View {
    @ObservedObject var goal: Goal
    
    var body: some View {
        NavigationLink(destination: GoalDetailView(goal: goal)) {
            VStack(alignment: .leading, spacing: 4) {
                HStack{
                    Text(goal.title ?? "")
                        .font(.headline)
                    Spacer()
                    if goal.hasDeadline{
                        Image(systemName: "calendar")
                    }
                    if !goal.isCompleted{
                        Text(goal.currentAmount.asCurrency)
                        Text("/")
                    }
                    Text(goal.targetAmount.asCurrency)
                        .font(.headline)
                        .foregroundStyle(Color.green)
                }
                
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
    }
}
