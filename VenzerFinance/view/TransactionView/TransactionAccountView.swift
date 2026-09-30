//
//  TransactionAccountView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct TransactionAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TransactionViewModel()
    
    @State var selectedAccount: Account?
    @State var amount: String = ""
    
    @State private var showRecipientSheet = false
    @State private var showSuccess = false
    @State private var showError: String?
    
    var body: some View {
        ZStack {
            CustomBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    
                    if viewModel.hasAccount {
                        TransactionHeroView(viewModel: viewModel)
                        
                        FromAccountCardView(viewModel: viewModel)
                        TransactionFlowConnector()
                        AmountCardView(viewModel: viewModel)
                        TransactionFlowConnector()
                        SendToCardView(viewModel: viewModel, showRecipientSheet: $showRecipientSheet)
                        TransactionSummaryView(viewModel: viewModel)
                            .padding(.top, 4)
                        TransactionSendButton(viewModel: viewModel, onSend: handleSend)
                            .padding(.top, 2)
                    } else {
                        TransactionEmptyStateView()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 80)
            }
            .sheet(isPresented: $showRecipientSheet) {
                RecipientSheetView(viewModel: viewModel, isPresented: $showRecipientSheet)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .alert("Cannot send", isPresented: errorBinding) {
                Button("OK", role: .cancel) { showError = nil }
            } message: {
                Text(showError ?? "")
            }
            
            if showSuccess {
                TransactionSuccessView(viewModel: viewModel, isPresented: $showSuccess, endShow: {
                    dismiss()
                })
            }
        }
        .navigationTitle("Transfer Money")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color("CardText"))
                }
            }
        }
        .onAppear {
            viewModel.refresh()
            selectedAccount = viewModel.account
        }
        .onChange(of: viewModel.amount) { _, newValue in
            if amount != newValue { amount = newValue }
        }
        .onChange(of: amount) { _, newValue in
            if viewModel.amount != newValue { viewModel.amount = newValue }
        }
        .onChange(of: viewModel.account?.id) { _, _ in
            selectedAccount = viewModel.account
        }
    }
    
    private var errorBinding: Binding<Bool> {
        Binding(
            get: { showError != nil },
            set: { if !$0 { showError = nil } }
        )
    }
    
    private func handleSend() {
        if let error = viewModel.validate() {
            showError = error
            return
        }
        if viewModel.send() {
            amount = viewModel.amount
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showSuccess = true
            }
        }
    }
    
}

#Preview {
    ZStack {
        CustomBackgroundView()
        TransactionAccountView()
    }
}
