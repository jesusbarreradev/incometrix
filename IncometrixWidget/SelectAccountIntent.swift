import WidgetKit
import AppIntents

struct SelectAccountIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Account"
    static var description = IntentDescription("Choose which account's balance to display.")

    @Parameter(title: "Account")
    var account: AccountEntity?
}
