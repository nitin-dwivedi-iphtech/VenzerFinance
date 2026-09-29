//
//  ChartView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//

import SwiftUI

struct ChartView: View {
    @StateObject private var viewModel = ChartViewModel()

    var body: some View {
        ZStack {
            CustomBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ChartHeaderView()

                    ChartRangePicker(
                        options: viewModel.rangeOptions,
                        selected: $viewModel.rangeMonths
                    )

                    if viewModel.hasData {
                        ChartSummaryRow(viewModel: viewModel)
                        MonthlyBarCard(viewModel: viewModel)
                        DailyTrendCard(viewModel: viewModel)
                        FlowDonutCard(viewModel: viewModel)
                        ChartInsightsCard(viewModel: viewModel)
                    } else {
                        ChartEmptyState()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 96)
            }
            .refreshable { viewModel.refresh() }
        }
        .onAppear { viewModel.refresh() }
        .onChange(of: viewModel.rangeMonths) { viewModel.refresh() }
    }
}

#Preview {
    ChartView()
}
