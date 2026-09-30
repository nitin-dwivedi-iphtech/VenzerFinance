//
//  MetricDetailCardView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct MetricDetailCardView: View {
    @ObservedObject var viewModel: BalanceOverviewViewModel

    var body: some View {
        if viewModel.selectedMetricID != "overview" {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: selectedMetricIcon)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.12), in: Circle())

                    Text(selectedMetricTitle)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)

                    Spacer()

                    Text(viewModel.monthName)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.12), in: Capsule())
                }

                Divider()
                    .overlay(Color.white.opacity(0.15))

                VStack {
                    switch viewModel.selectedMetricID {
                    case "breakdown":
                        breakdownPanel
                    case "activity":
                        activityPanel
                    case "rates":
                        ratesPanel
                    default:
                        accountsPanel
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
                .transition(.opacity.combined(with: .scale(scale: 0.97)))
            }
            .padding(16)
            .background(Color("CardColor"), in: RoundedRectangle(cornerRadius: 20))
            .clipShape(NotchedCardShape(position: .top, direction: .inward))
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }

    private var selectedMetricTitle: String {
        viewModel.metrics.first(where: { $0.id == viewModel.selectedMetricID })?.title
            ?? "Details"
    }

    private var selectedMetricIcon: String {
        viewModel.metrics.first(where: { $0.id == viewModel.selectedMetricID })?.icon
            ?? "chart.bar.fill"
    }

    private var breakdownPanel: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 9)
                    .frame(width: 62, height: 62)

                Circle()
                    .trim(from: 0, to: max(viewModel.spentShare, 0.001))
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 62, height: 62)
                    .animation(.easeInOut(duration: 0.4), value: viewModel.spentShare)

                Text(viewModel.spentPercentText)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 8) {
                detailRow(dot: .white, title: "Spent", value: viewModel.monthSpentDisplay)
                detailRow(dot: Color.white.opacity(0.35), title: "Balance", value: viewModel.balanceDisplay)
            }
        }
    }

    private var activityPanel: some View {
        HStack(spacing: 0) {
            statBlock(value: "\(viewModel.monthTransferCount)", caption: "sent")
            verticalDivider
            statBlock(value: viewModel.largestTransferDisplay, caption: "largest")
            verticalDivider
            statBlock(value: viewModel.monthSpentDisplay, caption: "total sent")
        }
    }

    private var ratesPanel: some View {
        HStack(spacing: 8) {
            if viewModel.isLoadingRate {
                ProgressView()
                    .tint(.white)
            } else {
                Text("1 \(viewModel.currencyCode)")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                    .monospacedDigit()

                Text(viewModel.rateText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
                    .monospacedDigit()
            }
        }
        .frame(minHeight: 44)
    }

    private var accountsPanel: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.accountBankName)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text("•••• \(viewModel.accountLastFour)")
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.6))
                    .monospacedDigit()
            }

            Spacer(minLength: 8)

            Text(viewModel.currencyCode)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.12), in: Capsule())
        }
    }

    private func detailRow(dot: Color, title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(dot)
                .frame(width: 8, height: 8)

            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.7))

            Spacer(minLength: 8)

            Text(value)
                .font(.system(size: 13, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private func statBlock(value: String, caption: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(caption)
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }

    private var verticalDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.12))
            .frame(width: 1, height: 34)
    }
}

#Preview {
    MetricDetailCardView(viewModel: BalanceOverviewViewModel())
}
