import SwiftUI
import WidgetKit

struct BalanceWidgetView: View {
    let entry: BalanceEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.hasAccount ? entry.accountName : "Pick an Account")
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Spacer()

            Text(entry.balance.asCurrency)
                .font(.title2.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text("Balance")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

//#Preview(as: .systemSmall) {
//    BalanceWidget()
//} timelineProvider: {
//    BalanceWidgetProvider()
//}
