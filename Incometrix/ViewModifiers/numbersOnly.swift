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

    func body(content: Content) -> some View {
        content
            .keyboardType(.decimalPad)
            .onChange(of: text) { _, newValue in

                let allowed = "0123456789."
                var filtered = newValue.filter { allowed.contains($0) }
                
                if let firstDot = filtered.firstIndex(of: ".") {
                    let before = filtered[...firstDot]
                    var after = filtered[filtered.index(after: firstDot)...]
                        .replacingOccurrences(of: ".", with: "")
                    
                    if after.count > 2 {
                        after.removeLast()
                    }
                    
                    filtered = before + after
                }
                
                if filtered != newValue {
                    text = filtered
                }
            }
    }
}

extension View {
    func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = false) -> some View {
        modifier(NumbersOnlyModifier(text: text))
    }
}
