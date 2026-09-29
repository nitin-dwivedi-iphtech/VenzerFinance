//
//  AllTransactionsView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//


import SwiftUI

struct AllTransactionsView: View {
    @StateObject private var viewModel = AllTransactionsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            CustomBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    AllTransactionsSummaryCard(
                        countText: viewModel.countText,
                        totalText: viewModel.totalSpentDisplay
                    )
                    
                    AllTransactionsFilterBar(
                        selected: $viewModel.selectedFilter
                    )
                    
                    if viewModel.grouped.isEmpty {
                        AllTransactionsEmptyState()
                    } else {
                        LazyVStack(spacing: 14, pinnedViews: []) {
                            ForEach(viewModel.grouped) { group in
                                AllTransactionsDaySection(
                                    group: group,
                                    currencySymbol: viewModel.currencySymbol
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .refreshable { viewModel.refresh() }
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search amount or date")
        .onAppear { viewModel.refresh() }
    }
}

#Preview {
    NavigationStack {
        AllTransactionsView()
    }
}
