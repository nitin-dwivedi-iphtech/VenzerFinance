//
//  WelcomeView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 18/09/26.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject var welcomeViewModel:WelcomeViewModel = WelcomeViewModel()
    @State var showCurrencyConverterView:Bool = false
    
    
    var body: some View {
        ScrollView(showsIndicators:false){
            VStack(spacing: 16) {
                header
                welcomeSection
                // MARK: - For Testing Only
//                if welcomeViewModel.account != nil {
                    accountCard
                        .padding(.horizontal, 20)
                    
                    HStack(spacing: 12) {
                        expenseCard
                        recentTransactionCard
                    }
                    .padding(.horizontal, 20)
//                } else {
//                    Spacer()
//                    VStack {
//                        
//                        Text("Account not found!!")
//                            .font(.system(size: 15))
//                        Text("Please add new account in settings")
//                            .font(.system(size: 10))
//                            .foregroundStyle(.gray)
//                    }
//                }
                Spacer()
            }
        }
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
            balanceText: "$4,309,573.02",
            lastFour: "0849"
        )
    }
    
    var expenseCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(Color("InsideCarBottomColor"))
                
                Text("Expenses")
                    .font(.system(size: 13))
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 16))
            }
            
            Spacer(minLength: 30)
            
            HStack(alignment: .center, spacing: 4) {
                HStack(spacing: 1) {
                    Image(systemName: "dollarsign")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.gray)
                    
                    Text("4570")
                        .font(.system(size: 18, weight: .bold))
                }
                
                Text("*27%")
                    .font(.system(size: 9))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color("InsideCarBottomColor"), in: RoundedRectangle(cornerRadius: 10))
            }
            
            Text("This Month")
                .font(.system(size: 10))
                .foregroundStyle(.gray)
                .padding(.top, 2)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 150)
        .background(.white, in: RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
    
    var recentTransactionCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Recent Transaction")
                .font(.system(size: 13))
            
            Spacer(minLength: 30)
            
            Text("Direct Bank")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .padding(.bottom, 6)
            
            HStack {
                ZStack(alignment: .leading) {
                    Image("image")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                    
                    Image("person1")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                        .offset(x: 16)
                }
                .frame(width: 45, alignment: .leading)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.black)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 150)
        .background(.white, in: RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    WelcomeView()
}
