//
//  ChartInsights.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//

import SwiftUI

struct ChartInsightsCard: View {
    @ObservedObject var viewModel: ChartViewModel

    var body: some View {
        ChartCard(title: "Highlights", subtitle: "Auto insights", icon: "sparkles") {
            VStack(spacing: 10) {
                insightRow(
                    icon: "calendar",
                    title: "Peak month",
                    value: viewModel.largestMonthLabel == "—"
                        ? "—"
                        : "\(viewModel.largestMonthLabel) • \(viewModel.currencySymbol)\(String(format: "%.2f", viewModel.largestMonthValue))"
                )
                Divider().overlay(Color("CardText").opacity(0.08)).padding(.vertical, 5).padding(.horizontal,30)
                insightRow(icon: "clock", title: "Most active day", value: viewModel.activeDayLabel)
                Divider().overlay(Color("CardText").opacity(0.08)).padding(.vertical, 5).padding(.horizontal,30)
                insightRow(icon: "arrow.left.arrow.right", title: "Net flow", value: viewModel.netDisplay)
            }.padding(.vertical)
        }
    }

    private func insightRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 11) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color("CardColor"))
                .frame(width: 34, height: 34)
                .background(Color("InsideCarTopColor"), in: Circle())
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color("CardText"))
                Text(value)
                    .font(.system(size: 11).monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.secondary.opacity(0.5))
        }
    }
}

struct ChartEmptyState: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)
            Text("No chart data yet")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color("CardText"))
            Text("Send money to see trends here")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 22))
    }
}

#Preview {
    ChartInsightsCard(viewModel: ChartViewModel())
}
