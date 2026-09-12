import Foundation

extension Double {
    /// Formats the value using the user's current locale currency (falls back to USD).
    var asCurrency: String {
        self.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))
    }
}
