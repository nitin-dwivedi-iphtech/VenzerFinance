//
//  TransactionsCard.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//

import SwiftUI

struct TransactionsCard: View {
    let transactions: [TransactionItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if transactions.isEmpty {
                Text("No transactions yet")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 16)
            } else {
                ForEach(Array(transactions.enumerated()), id: \.element.id) { index, transaction in
                    TransactionRow(transaction: transaction)
                        .padding(.vertical, 10)

                    if index < transactions.count - 1 {
                        Divider()
                            .overlay(Color.black.opacity(0.05))
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }

    private var header: some View {
        HStack {
            Text("Transactions")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color("CardText"))

            Spacer()

            Button(action: {}) {
                Text("See All")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color("CardColor").opacity(0.7))
            }
        }
        .padding(.bottom, 6)
    }
}


private struct TransactionRow: View {
    let transaction: TransactionItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color("CardColor"))
                .frame(width: 36, height: 36)
                .background(Color("InsideCarTopColor"), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color("CardText"))

                Text(transaction.detail)
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
            }

            Spacer(minLength: 8)

            Text(transaction.amount)
                .font(.system(size: 13, weight: .bold).monospacedDigit())
                .foregroundStyle(
                    transaction.isCredit
                        ? Color(red: 0.13, green: 0.52, blue: 0.28)
                        : Color(red: 0.78, green: 0.22, blue: 0.22)
                )
        }
    }
}
