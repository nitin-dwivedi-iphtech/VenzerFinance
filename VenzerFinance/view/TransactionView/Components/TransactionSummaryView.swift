//
//  TransactionSummaryView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

/// Transfer summary (amount / fee / total / remaining).
struct TransactionSummaryView: View {
    @ObservedObject var viewModel: TransactionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TransactionSectionLabel(text: "Review", step: "04")

            VStack(spacing: 0) {
                SummaryRow(title: "Transfer amount", value: viewModel.formattedAmountWithSymbol, bold: false)
                    .padding(.vertical, 8)
                Divider().overlay(Color("CardText").opacity(0.12))
                SummaryRow(title: "Fee", value: "\(viewModel.currencySymbol)0.00", sub: "No hidden charges", bold: false)
                    .padding(.vertical, 8)
                Divider().overlay(Color("CardText").opacity(0.12))
                SummaryRow(title: "Total debit", value: viewModel.formattedAmountWithSymbol, bold: true)
                    .padding(.vertical, 8)
                SummaryRow(title: "Remaining balance", value: viewModel.remainingBalanceText, bold: false)
                    .padding(.top, 2)
            }
            .transactionInnerBox()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.06), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

private struct SummaryRow: View {
    let title: String
    let value: String
    var sub: String? = nil
    let bold: Bool

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 13, weight: bold ? .bold : .medium))
                    .foregroundStyle(bold ? Color("CardText") : .gray)
                if let sub {
                    Text(sub)
                        .font(.system(size: 11))
                        .foregroundStyle(.gray.opacity(0.8))
                }
            }
            Spacer()
            Text(value)
                .font(.system(size: bold ? 16 : 14, weight: bold ? .bold : .semibold).monospacedDigit())
                .foregroundStyle(Color("CardText"))
        }
    }
}
