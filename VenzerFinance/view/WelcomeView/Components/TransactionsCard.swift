//
//  TransactionsCard.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//

import SwiftUI


struct TransactionItem: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let icon: String
    let amount: String
    let isCredit: Bool
}

// Dummy data

let dummyTransactions: [TransactionItem] = [
    TransactionItem(title: "Salary Deposit", detail: "Income • Sep 24", icon: "banknote.fill", amount: "+$3,200.00", isCredit: true),
    TransactionItem(title: "Netflix", detail: "Entertainment • Sep 24", icon: "play.tv.fill", amount: "-$15.99", isCredit: false),
    TransactionItem(title: "Starbucks Coffee", detail: "Food & Drinks • Sep 23", icon: "cup.and.saucer.fill", amount: "-$6.45", isCredit: false),
    TransactionItem(title: "Amazon Order", detail: "Shopping • Sep 23", icon: "bag.fill", amount: "-$89.99", isCredit: false),
    TransactionItem(title: "Freelance Payment", detail: "Income • Sep 22", icon: "briefcase.fill", amount: "+$450.00", isCredit: true),
    TransactionItem(title: "Uber Ride", detail: "Transport • Sep 22", icon: "car.fill", amount: "-$23.50", isCredit: false),
    TransactionItem(title: "Electricity Bill", detail: "Bills • Sep 21", icon: "bolt.fill", amount: "-$112.30", isCredit: false)
]


struct TransactionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            ForEach(Array(dummyTransactions.enumerated()), id: \.element.id) { index, transaction in
                TransactionRow(transaction: transaction)
                    .padding(.vertical, 10)

                if index < dummyTransactions.count - 1 {
                    Divider()
                        .overlay(Color.black.opacity(0.05))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }

    private var header: some View {
        HStack {
            Text("Transactions")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)

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
                    .foregroundStyle(.black)

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

#Preview {
    TransactionsCard()
}
