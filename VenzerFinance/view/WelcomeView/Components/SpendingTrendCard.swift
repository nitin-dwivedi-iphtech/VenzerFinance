//
//  SpendingTrendCard.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//

import SwiftUI

struct SpendingTrendCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header

            TransactionsHeatmapChart()

            legend
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 15))
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
                .foregroundStyle(.black)

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
                .fill(Color("CardColor"))
                .frame(width: 7, height: 7)
            Circle()
                .fill(Color("InsideCarTopColor"))
                .frame(width: 7, height: 7)

            Text("More transactions = greener dot")
                .font(.system(size: 9))
                .foregroundStyle(.gray)

            Spacer()
        }
    }
}

#Preview {
    SpendingTrendCard()
}
