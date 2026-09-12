import WidgetKit
import SwiftUI

struct BalanceWidget: Widget {
    let kind: String = "BalanceWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectAccountIntent.self,
            provider: BalanceWidgetProvider()
        ) { entry in
            BalanceWidgetView(entry: entry)
        }
        .configurationDisplayName("Account Balance")
        .description("Shows the balance of a chosen account.")
        .supportedFamilies([.systemSmall])
    }
}
