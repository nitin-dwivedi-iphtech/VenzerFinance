//
//  ChartSummaryRow.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//

import SwiftUI

struct ChartSummaryRow: View {
    @ObservedObject var viewModel: ChartViewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        HStack(spacing: 12) {
            summaryBox(
                title: "Sent",
                value: viewModel.totalSentDisplay,
                icon: "arrow.up.right",
                tint: sentTint(for: scheme),
                soft: sentSoft(for: scheme)
            )
            summaryBox(
                title: "Received",
                value: viewModel.totalReceivedDisplay,
                icon: "arrow.down.left",
                tint: receivedTint(for: scheme),
                soft: receivedSoft(for: scheme)
            )
        }
    }

    private func summaryBox(title: String, value: String, icon: String, tint: Color, soft: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 7) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(tint)
                    .frame(width: 26, height: 26)
                    .background(soft, in: Circle())
                Text(title.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.secondary)
                    .tracking(0.8)
            }
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded).monospacedDigit())
                .foregroundStyle(Color("CardText"))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(tint.opacity(0.18), lineWidth: 1)
        )
    }
}
