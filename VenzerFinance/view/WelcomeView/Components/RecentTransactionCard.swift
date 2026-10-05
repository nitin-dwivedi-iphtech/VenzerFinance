//
//  RecentTransactionCard.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//


import SwiftUI

struct RecentTransactionCard: View {
    var transaction: TransactionItem?
    var onTap: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Recent Transaction")
                .font(.system(size: 13))

            Spacer(minLength: 30)

            Text(transaction.map { "\($0.title) • \($0.amount)" } ?? "No activity yet")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .lineLimit(1)
                .padding(.bottom, 6)

            HStack {
                ZStack(alignment: .leading) {
                    if let tx = transaction {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 25, height: 25)
                            .overlay(
                                Image(systemName: tx.icon)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(tx.isCredit ? .green : Color("CardColor"))
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                    } else {
                        UserAvatarView(imageData: nil, size: 25)
                    }

                    UserAvatarView(imageData: nil, size: 25)
                        .offset(x: 16)
                }
                .frame(width: 45, alignment: .leading)

                Spacer()

                Button(action: onTap) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color("CardText"))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 150)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    RecentTransactionCard(
        transaction: TransactionItem(
            id: "1",
            title: "Money Received",
            detail: "Transfer • Sep 30",
            icon: "arrow.down.left.circle.fill",
            amount: "+$250.00",
            isCredit: true
        )
    )
    .padding(.horizontal, 20)
}
