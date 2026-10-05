//
//  TransactionCardModifier.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct TransactionCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.06), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

struct TransactionInnerBoxModifier: ViewModifier {
    @Environment(\.colorScheme) private var scheme

    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(
                scheme == .dark
                    ? Color.white.opacity(0.07)
                    : Color("InsideCarTopColor").opacity(0.38),
                in: RoundedRectangle(cornerRadius: 16)
            )
    }
}

struct TransactionSectionLabel: View {
    let text: String
    var step: String? = nil
    var centered: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            if let step {
                Text(step)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 22, height: 22)
                    .background(Color("CardColor"), in: Circle())
            }

            Text(text)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.gray)
                .tracking(0.4)
        }
        .frame(maxWidth: .infinity, alignment: centered ? .center : .leading)
    }
}
