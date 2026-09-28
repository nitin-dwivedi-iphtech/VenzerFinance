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
    
    var body: some View {
        Group {
            if welcomeViewModel.account != nil {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        header
                        welcomeSection
                        accountCard
                        
                        HStack(spacing: 12) {
                            ExpenseCard(displayAmount: welcomeViewModel.monthExpenseDisplay)
                            RecentTransactionCard()
                        }
                        .padding(.horizontal, 20)
                        
                        SpendingTrendCard(
                            monthColumns: welcomeViewModel.heatmapMonthColumns,
                            counts: welcomeViewModel.heatmapCounts
                        )
                        TransactionsCard(transactions: welcomeViewModel.transactionItems)
                    }
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
            
            Image("image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 42, height: 42)
                .clipShape(Circle())
                .onTapGesture {
                    // handle action to open setting view
                }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Hi \(welcomeViewModel.user?.name ?? "User"),")
                .font(.system(size: 13))
            Text("Welcome Back!")
                .font(.system(size: 35, weight: .light))
            Text("Here's your latest account overview")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    WelcomeView()
}
