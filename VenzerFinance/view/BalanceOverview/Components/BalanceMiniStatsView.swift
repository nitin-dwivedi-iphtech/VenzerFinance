//
//  BalanceMiniStatsView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct BalanceMiniStatsView: View {
    @ObservedObject var viewModel: BalanceOverviewViewModel

    var body: some View {
        HStack(spacing: 12) {
            miniStat(
                icon: "arrow.left.arrow.right",
                title: "Transfers",
                value: viewModel.monthTransactionCount,
                caption: "This month"
            )
            miniStat(
                icon: "chart.line.uptrend.xyaxis",
                title: "Largest",
                value: viewModel.largestTransferDisplay,
                caption: "Single transfer"
            )
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }

    private func miniStat(icon: String, title: String, value: String, caption: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(Color("CardColor"))
                    .frame(width: 32, height: 32)
                    .background(Color("InsideCarTopColor"), in: Circle())

                Text(title)
                    .font(.system(size: 13))
                    .foregroundStyle(Color("CardText"))

                Spacer()
            }

            Spacer(minLength: 24)

            Text(value)
                .font(.system(size: 16, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(Color("CardText"))
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(caption)
                .font(.system(size: 10))
                .foregroundStyle(.gray)
                .padding(.top, 2)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}
