//
//  AllTransactionsSections.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//

import SwiftUI


struct AllTransactionsSummaryCard: View {
    let countText: String
    let totalText: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "arrow.up.arrow.down.circle.fill")
                .font(.system(size: 30))
                .foregroundStyle(Color("CardColor"))
                .frame(width: 52, height: 52)
                .background(Color("InsideCarTopColor"), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text("Total sent")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                Text(totalText)
                    .font(.system(size: 22, weight: .bold).monospacedDigit())
                    .foregroundStyle(Color("CardText"))
                Text(countText)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}


struct AllTransactionsFilterBar: View {
    @Binding var selected: AllTransactionsViewModel.TimeFilter

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(AllTransactionsViewModel.TimeFilter.allCases) { filter in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selected = filter
                        }
                    } label: {
                        Text(filter.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                selected == filter
                                    ? Color("CardColor")
                                    : Color("CardBackground"),
                                in: Capsule()
                            )
                            .foregroundStyle(
                                selected == filter
                                    ? .white
                                    : Color("CardText").opacity(0.7)
                            )
                            .shadow(
                                color: selected == filter
                                    ? Color("CardColor").opacity(0.3)
                                    : .black.opacity(0.06),
                                radius: 6, x: 0, y: 3
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

struct AllTransactionsDaySection: View {
    let group: AllTransactionsViewModel.DayGroup
    let currencySymbol: String

    private var dayNetText: String {
        let sign = group.dayTotal >= 0 ? "+" : "-"
        return "\(sign)\(currencySymbol)\(String(format: "%.2f", abs(group.dayTotal)))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(group.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color("CardText"))
                    Text(group.subtitle)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(dayNetText)
                    .font(.system(size: 12, weight: .semibold).monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 8)

            ForEach(group.rows) { row in
                AllTransactionRow(row: row, currencySymbol: currencySymbol)
                if row.id != group.rows.last?.id {
                    Divider()
                        .overlay(Color("CardText").opacity(0.08))
                        .padding(.vertical, 8)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

struct AllTransactionRow: View {
    let row: AllTransactionsViewModel.TxRow
    let currencySymbol: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: row.isCredit ? "arrow.down.left.circle.fill" : "paperplane.fill")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color("CardColor"))
                .frame(width: 38, height: 38)
                .background(Color("InsideCarTopColor"), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(row.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color("CardText"))
                Text(row.detail)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            Text("\(row.isCredit ? "+" : "-")\(currencySymbol)\(String(format: "%.2f", row.amount))")
                .font(.system(size: 13, weight: .bold).monospacedDigit())
                .foregroundStyle(
                    row.isCredit
                        ? Color(red: 0.13, green: 0.52, blue: 0.28)
                        : Color(red: 0.78, green: 0.22, blue: 0.22)
                )
        }
    }
}

struct AllTransactionsEmptyState: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "tray")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)
            Text("No transactions found")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color("CardText"))
            Text("Try a different search or filter")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 18))
    }
}
