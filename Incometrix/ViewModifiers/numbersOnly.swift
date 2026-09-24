//
//  numbersOnly.swift
//  Incometrix
//
//  Created by cyberfortress on 13/09/26.
//

import Foundation
import SwiftUI
struct NumbersOnlyModifier: ViewModifier {
    @Binding var text: String
    var includeDecimal: Bool = false

    func body(content: Content) -> some View {
        content
            .keyboardType(includeDecimal ? .decimalPad : .numberPad)
            .onChange(of: text) { _, newValue in
                let allowed = includeDecimal ? "0123456789." : "0123456789"
                let filtered = newValue.filter { allowed.contains($0) }
                if filtered != newValue {
                    text = filtered
                }
            }
    }
}

extension View {
    func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = false) -> some View {
        modifier(NumbersOnlyModifier(text: text, includeDecimal: includeDecimal))
    }
}
