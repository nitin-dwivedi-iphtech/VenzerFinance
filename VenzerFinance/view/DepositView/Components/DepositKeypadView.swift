//
//  DepositKeypadView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 30/09/26.
//

import SwiftUI

struct DepositKeypadView: View {
    @Binding var amount: String
    @Environment(\.colorScheme) private var scheme

    private let rows: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "delete"]
    ]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { key in
                        keyButton(key)
                    }
                }
            }
        }
        .transactionCard()
    }

    private func keyButton(_ key: String) -> some View {
        Button {
            if key == "delete" {
                guard !amount.isEmpty else { return }
                amount.removeLast()
            } else {
                amount = DepositViewModel.sanitized(amount + key)
            }
        } label: {
            Group {
                if key == "delete" {
                    Image(systemName: "delete.left.fill").font(.system(size: 20))
                } else {
                    Text(key).font(.system(size: 22, weight: .semibold)).monospacedDigit()
                }
            }
            .foregroundStyle(Color("CardText"))
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                scheme == .dark ? Color.white.opacity(0.07) : Color("InsideCarTopColor").opacity(0.38),
                in: RoundedRectangle(cornerRadius: 14)
            )
        }
        .buttonStyle(.plain)
    }
}
