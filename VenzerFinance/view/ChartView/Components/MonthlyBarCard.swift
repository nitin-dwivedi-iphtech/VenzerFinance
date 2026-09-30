//
//  MonthlyBarCard.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//

import Charts
import SwiftUI

struct MonthlyBarCard: View {
    @ObservedObject var viewModel: ChartViewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let sent = sentColor(for: scheme)
        let received = receivedColor(for: scheme)
        let grid = gridColor(for: scheme)
        let axis = axisColor(for: scheme)
        let maxSent = viewModel.months.map(\.sent).max() ?? 0
        let maxRecived = viewModel.months.map(\.received).max() ?? 0
        let newMax = max(maxSent, maxRecived)
        return ChartCard(title: "Monthly flow", subtitle: "Grouped bars • \(viewModel.rangeMonths)M", icon: "chart.bar.fill") {
            Chart(viewModel.months) { month in
                BarMark(
                    x: .value("Month", month.label),
                    y: .value("Sent", month.sent)
                )
                .foregroundStyle(sent.gradient.shadow(.inner(color: .black.opacity(0.12), radius: 2)))
                .cornerRadius(6)
                .position(by: .value("Type", "Sent"))

                BarMark(
                    x: .value("Month", month.label),
                    y: .value("Received", month.received)
                )
                .foregroundStyle(received.gradient)
                .cornerRadius(6)
                .position(by: .value("Type", "Received"))
            }
            .chartLegend(position: .bottom, alignment: .center, spacing: 14)
            .chartForegroundStyleScale([
                "Sent": sent,
                "Received": received
            ])
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(axis)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.6, dash: [3, 4]))
                        .foregroundStyle(grid)
                    AxisValueLabel()
                        .font(.system(size: 9))
                        .foregroundStyle(axis)
                }
            }
            .chartYScale(domain: 0...(max(newMax * 1.2, 10)))
            .frame(height: 210)
            .chartPlotStyle { plot in
                plot.background(.clear)
            }
        }
    }
}
