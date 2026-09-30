//
//  SpendingTrendCard.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//

import SwiftUI

struct SpendingTrendCard: View {
    let monthColumns: [(month: String, weeks: Int)]
    let counts: [[Int]]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header

            TransactionsHeatmapChart(monthColumns: monthColumns, transactions: counts)

            legend
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }

    private var header: some View {
        HStack(spacing: 8) {
            Image(systemName: "chart.xyaxis.line")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color("CardColor"))

            Text("Transaction Activity")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color("CardText"))

            Spacer()

            Text("Last 5 Months")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Color("CardColor").opacity(0.75))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color("InsideCarTopColor"), in: Capsule())
        }
    }

    private var legend: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(legendFullColor)
                .frame(width: 7, height: 7)
            Circle()
                .fill(legendEmptyColor)
                .frame(width: 7, height: 7)

            Text("More transactions = greener dot")
                .font(.system(size: 9))
                .foregroundStyle(.gray)

            Spacer()
        }
    }

    @Environment(\.colorScheme) private var scheme

    /// Legend dots matching the chart ramp ends in each mode.
    private var legendFullColor: Color {
        scheme == .dark ? Color(red: 0.19, green: 0.85, blue: 0.38) : Color("CardColor")
    }

    private var legendEmptyColor: Color {
        scheme == .dark ? Color.white.opacity(0.09) : Color("InsideCarTopColor")
    }
}

#Preview {
    SpendingTrendCard(
        monthColumns: [("Aug", 4), ("Sep", 4), ("Oct", 4), ("Nov", 4), ("Dec", 4)],
        counts: Array(repeating: Array(repeating: 1, count: 20), count: 7)
    )
}
