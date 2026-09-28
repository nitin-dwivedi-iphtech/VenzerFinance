//
//  BalanceCardView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct BalanceCardView: View {
    @ObservedObject var viewModel: BalanceOverviewViewModel

    var body: some View {
        GeometryReader { proxy in
            let scale = min(1, (proxy.size.width - 32) / 320)

            ZStack {
                BalanceOverviewCardShape()
                    .fill(Color("CardBackground"))
                    .shadow(color: Color.black.opacity(0.04), radius: 20, x: 0, y: 10)
                    .frame(width: 320, height: 320)

                InnerDashedArc()
                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 6]))
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(width: 240, height: 240)
                    .offset(y: -10)

                Circle()
                    .fill(Color("CardColor"))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(viewModel.currencySymbol)
                            .foregroundColor(.white)
                            .font(.headline)
                    )
                    .offset(y: -130)

                MockChartView(pillText: viewModel.currencyCode)
                    .frame(width: 220, height: 80)
                    .offset(y: -50)

                VStack(spacing: 4) {
                    Text(viewModel.balanceDisplay)
                        .font(.system(size: 22, weight: .bold))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.25), value: viewModel.balanceDisplay)

                    Text("Total Balance")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .offset(y: 20)

                metricButtons
            }
            .frame(width: proxy.size.width, height: 320)
            .scaleEffect(scale)
        }
        .frame(height: 336)
        .padding(.top, 28)
    }

    private var metricButtons: some View {
        let xOffsets: [CGFloat] = [-115, -65, 0, 65, 115]
        let yOffsets: [CGFloat] = [110, 95, 85, 95, 110]

        return ZStack {
            ForEach(Array(viewModel.metrics.enumerated()), id: \.element.id) { index, metric in
                FloatingActionButton(
                    icon: metric.icon,
                    isSelected: viewModel.selectedMetricID == metric.id
                )
                .offset(x: xOffsets[index], y: yOffsets[index])
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                        viewModel.selectedMetricID = metric.id
                    }
                }
                .accessibilityLabel(metric.title)
            }
        }
    }
}
