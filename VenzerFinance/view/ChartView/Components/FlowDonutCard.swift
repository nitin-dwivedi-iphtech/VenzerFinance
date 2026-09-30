//
//  FlowDonutCard.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//

import Charts
import SwiftUI

struct FlowDonutCard: View {
    @ObservedObject var viewModel: ChartViewModel
    @Environment(\.colorScheme) private var scheme

    private var sentShare: Double {
        let total = viewModel.totalSent + viewModel.totalReceived
        guard total > 0 else { return 0 }
        return viewModel.totalSent / total
    }

    var body: some View {
        let sent = sentColor(for: scheme)
        let received = receivedColor(for: scheme)
        return ChartCard(title: "Flow split", subtitle: "Share of money moved", icon: "chart.pie.fill") {
            HStack(spacing: 18) {
                ZStack {
                    Chart {
                        SectorMark(
                            angle: .value("Sent", max(viewModel.totalSent, 0.001)),
                            innerRadius: .ratio(0.68),
                            outerRadius: .ratio(1),
                            angularInset: 2.5
                        )
                        .foregroundStyle(sent.gradient)
                        .cornerRadius(7)

                        SectorMark(
                            angle: .value("Received", max(viewModel.totalReceived, 0.001)),
                            innerRadius: .ratio(0.68),
                            outerRadius: .ratio(1),
                            angularInset: 2.5
                        )
                        .foregroundStyle(received.gradient)
                        .cornerRadius(7)
                    }
                    .chartLegend(.hidden)
                    .frame(width: 148, height: 148)

                    VStack(spacing: 2) {
                        Text("NET")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.secondary)
                            .tracking(1)
                        Text(viewModel.netDisplay)
                            .font(.system(size: 12, weight: .bold, design: .rounded).monospacedDigit())
                            .foregroundStyle(Color("CardText"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        Text("\(Int((sentShare * 100).rounded()))% sent")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: 92)
                    .multilineTextAlignment(.center)
                }
                .frame(width: 148, height: 148)

                VStack(alignment: .leading, spacing: 12) {
                    flowBar(dot: sent, title: "Sent", value: viewModel.totalSentDisplay, share: sentShare)
                    flowBar(dot: received, title: "Received", value: viewModel.totalReceivedDisplay, share: 1 - sentShare)
                }
            }
        }
    }

    private func flowBar(dot: Color, title: String, value: String, share: Double) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 7) {
                Circle().fill(dot).frame(width: 9, height: 9)
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(value)
                    .font(.system(size: 12, weight: .bold, design: .rounded).monospacedDigit())
                    .foregroundStyle(Color("CardText"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            GeometryReader { geo in
                Capsule()
                    .fill(Color("CardText").opacity(0.08))
                    .frame(height: 6)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(dot.gradient)
                            .frame(width: geo.size.width * max(min(share, 1), 0.04), height: 6)
                    }
            }
            .frame(height: 6)
        }
    }
}

#Preview {
    FlowDonutCard(viewModel: ChartViewModel())
}
