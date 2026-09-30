//
//  DailyTrendCard.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//

import Charts
import SwiftUI

struct DailyTrendCard: View {
    @ObservedObject var viewModel: ChartViewModel
    @Environment(\.colorScheme) private var scheme

    private var average: Double {
        guard !viewModel.last5Days.isEmpty else { return 0 }
        return viewModel.last5Days.reduce(0) { $0 + $1.sent } / Double(viewModel.last5Days.count)
    }

    var body: some View {
        let sent = sentColor(for: scheme)
        let grid = gridColor(for: scheme)
        let axis = axisColor(for: scheme)
        let days = viewModel.last5Days
        let tickDates: [Date] = days.map(\.date)
        return ChartCard(title: "Momentum", subtitle: "Last 5 days • daily sent", icon: "waveform.path.ecg") {
            Chart(days) { day in
                AreaMark(
                    x: .value("Day", day.date),
                    y: .value("Sent", day.sent)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [sent.opacity(0.35), sent.opacity(0.02)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)

                LineMark(
                    x: .value("Day", day.date),
                    y: .value("Sent", day.sent)
                )
                .foregroundStyle(sent.gradient)
                .lineStyle(StrokeStyle(lineWidth: 2.75, lineCap: .round, lineJoin: .round))
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Day", day.date),
                    y: .value("Sent", day.sent)
                )
                .foregroundStyle(Color("CardBackground"))
                .symbol {
                    Circle()
                        .strokeBorder(sent, lineWidth: 2.5)
                        .frame(width: 9, height: 9)
                        .background(Circle().fill(Color("CardBackground")))
                }
            }
            .chartXAxis {
                AxisMarks(values: tickDates) { _ in
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
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
            .chartOverlay { _ in
                HStack {
                    Spacer()
                    Text("avg \(viewModel.currencySymbol)\(String(format: "%.0f", average))")
                        .font(.system(size: 9, weight: .bold, design: .rounded).monospacedDigit())
                        .foregroundStyle(scheme == .light ? Color("CardText").opacity(0.7) : .black)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 5)
                        .background(Color("InsideCarTopColor"), in: Capsule())
                }
            }
            .frame(height: 180)
        }
    }
}
