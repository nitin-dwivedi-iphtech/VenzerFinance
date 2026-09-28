//
//  BalanceOverviewView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//
import SwiftUI

struct BalanceOverviewView: View {
    @StateObject private var viewModel = BalanceOverviewViewModel()
    @State private var spinAngle: Double = 0

    var body: some View {
        ZStack {
            CustomBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    BalanceOverviewHeaderView(viewModel: viewModel, spinAngle: $spinAngle)

                    if viewModel.hasAccount {
                        BalanceCardView(viewModel: viewModel)

                        MetricDetailCardView(viewModel: viewModel)
                            .animation(.easeInOut(duration: 0.25), value: viewModel.selectedMetricID)

                        BalanceMiniStatsView(viewModel: viewModel)
                    } else {
                        BalanceEmptyStateView()
                    }

                    Spacer(minLength: 24)
                }
            }
            .refreshable { viewModel.refresh() }
        }
        .onAppear { viewModel.refresh() }
    }
}

#Preview {
    BalanceOverviewView()
}
