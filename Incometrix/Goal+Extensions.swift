import Foundation
import CoreData

extension Goal {

    /// 0.0–1.0, safe against targetAmount == 0.
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }
    
    var progressPercentText: String { "\(Int(progress * 100))%" }
    
    var isCompleted: Bool { progress >= 1.0 }
    
    var hasDeadline: Bool { deadline != nil }

    @discardableResult
    static func create(title: String, currentAmount: Double = 0, targetAmount: Double, deadline: Date?, in context: NSManagedObjectContext) -> Goal {
        let goal = Goal(context: context)
        goal.id = UUID()
        goal.title = title
        goal.targetAmount = targetAmount
        goal.currentAmount = currentAmount
        goal.deadline = deadline
        return goal
    }
}
