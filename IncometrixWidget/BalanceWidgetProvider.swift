import WidgetKit
import CoreData

struct BalanceEntry: TimelineEntry {
    let date: Date
    let accountName: String
    let balance: Double
    let hasAccount: Bool
}

struct BalanceWidgetProvider: AppIntentTimelineProvider {
    typealias Intent = SelectAccountIntent
    typealias Entry = BalanceEntry

    func placeholder(in context: Context) -> BalanceEntry {
        BalanceEntry(date: .now, accountName: "Checking", balance: 1250, hasAccount: true)
    }

    func snapshot(for configuration: SelectAccountIntent, in context: Context) async -> BalanceEntry {
        await entry(for: configuration)
    }

    func timeline(for configuration: SelectAccountIntent, in context: Context) async -> Timeline<BalanceEntry> {
        // .never = no automatic refresh schedule. The app calls
        // WidgetCenter.shared.reloadAllTimelines() from PersistenceController.save()
        // whenever data actually changes, which is cheaper than polling.
        Timeline(entries: [await entry(for: configuration)], policy: .never)
    }

    private func entry(for configuration: SelectAccountIntent) async -> BalanceEntry {
        guard let selected = configuration.account else {
            print("🟡 Incometrix widget: configuration.account is nil")
            return BalanceEntry(date: .now, accountName: "No Account", balance: 0, hasAccount: false)
        }
        print("🟢 Incometrix widget: configuration.account = \(selected.name) (\(selected.id))")

        let context = PersistenceController.shared.container.viewContext
        let fetched: (name: String, balance: Double)? = await context.perform {
            let request = Account.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", selected.id as CVarArg)
            request.fetchLimit = 1
            guard let account = try? context.fetch(request).first else { return nil }
            return (account.name ?? selected.name, account.balance)
        }

        guard let fetched else {
            print("🔴 Incometrix widget: no Account matched id \(selected.id) in the store")
            return BalanceEntry(date: .now, accountName: selected.name, balance: 0, hasAccount: false)
        }
        print("🟢 Incometrix widget: fetched \(fetched.name) balance \(fetched.balance)")
        return BalanceEntry(date: .now, accountName: fetched.name, balance: fetched.balance, hasAccount: true)
    }
}
