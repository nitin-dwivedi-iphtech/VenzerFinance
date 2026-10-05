//
//  WelcomeView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject var welcomeViewModel: WelcomeViewModel = WelcomeViewModel()
    @State var showCurrencyConverterView: Bool = false
    @State private var showAllTransactions = false
    @Binding var currentTab:Tab
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackgroundView()
                
                Group {
                    if welcomeViewModel.account != nil {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                header
                                welcomeSection
                                accountCard
                                
                                HStack(spacing: 12) {
                                    ExpenseCard(displayAmount: welcomeViewModel.monthExpenseDisplay)
                                    RecentTransactionCard(
                                        transaction: welcomeViewModel.transactionItems.first,
                                        onTap: { showAllTransactions = true }
                                    )
                                }
                                .padding(.horizontal, 20)
                                
                                SpendingTrendCard(
                                    monthColumns: welcomeViewModel.heatmapMonthColumns,
                                    counts: welcomeViewModel.heatmapCounts
                                )
                                TransactionsCard(
                                    transactions: welcomeViewModel.transactionItems,
                                    onSeeAll: { showAllTransactions = true }
                                )
                            }.padding(.bottom,80)
                        }
                    } else {
                        VStack(spacing: 0) {
                            header
                            welcomeSection
                            
                            Spacer()
                            
                            VStack(spacing: 6) {
                                Text("Account not found!!")
                                    .font(.system(size: 15, weight: .semibold))
                                Text("Please add new account in settings")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                        }
                    }
                }
                .fullScreenCover(isPresented: $showAllTransactions) {
                    NavigationStack {
                        AllTransactionsView()
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
        .onAppear { welcomeViewModel.refresh() }
        .fullScreenCover(isPresented: $showCurrencyConverterView) {
            NavigationStack {
                CurrencyConverterView()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                showCurrencyConverterView = false
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 22))
                                    .foregroundStyle(.gray.opacity(0.6))
                            }
                        }
                    }
            }
        }
    }
    
    var header: some View {
        HStack {
            Text("venzer.")
                .font(.title)
                .bold()
            
            Spacer()
            
            Button(action: {
                showCurrencyConverterView = true
            }) {
                Image(systemName: "coloncurrencysign.arrow.trianglehead.counterclockwise.rotate.90")
                    .font(.title3)
                    .foregroundStyle(.black)
            }
            .padding(10)
            .background(.white.opacity(0.67), in: Circle())
            
            UserAvatarView(imageData: welcomeViewModel.avatarData, size: 42)
                .onTapGesture {
                    currentTab = .setting
                }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    var welcomeSection: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Hi \(welcomeViewModel.user?.name ?? "User"),")
                    .font(.system(size: 13))
                Text("Welcome Back!")
                    .font(.system(size: 35, weight: .light))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text("Here's your latest account overview")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            AccountHeaderButton()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    var accountCard: some View {
        AccountCardView(
            displayName: welcomeViewModel.user?.name ?? "User",
            balanceText: balanceText,
            lastFour: lastFour
        )
        .padding(.horizontal, 20)
    }
    
    private var balanceText: String {
        guard let account = welcomeViewModel.account else {
            return "\(welcomeViewModel.currencySymbol)0.00"
        }
        return String(format: "%@%.2f", welcomeViewModel.currencySymbol, account.balance)
    }
    
    private var lastFour: String {
        guard let no = welcomeViewModel.account?.account_no, !no.isEmpty else { return "••••" }
        return String(no.suffix(4))
    }
}

#Preview {
    WelcomeView(currentTab: .constant(.home))
}
