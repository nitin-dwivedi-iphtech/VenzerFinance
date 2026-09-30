//
//  DepositView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 30/09/26.
//

import SwiftUI

struct DepositView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    @StateObject private var viewModel = DepositViewModel()

    @State private var pickerSide: DepositPickerSide?
    @State private var showSuccess = false
    @State private var showError: String?

    var body: some View {
        ZStack {
            CustomBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    headerSubtitle

                    if viewModel.hasAccounts {
                        DepositTransferAccountsView(viewModel: viewModel, pickerSide: $pickerSide)
                        if !viewModel.canTransfer {
                            needSecondAccountNotice
                        }
                        DepositAmountCardView(viewModel: viewModel)
                        DepositKeypadView(amount: $viewModel.amount)
                        DepositSummaryView(viewModel: viewModel)
                        DepositMoveButton(viewModel: viewModel, onMove: handleMove)
                    } else {
                        TransactionEmptyStateView()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .alert("Cannot move", isPresented: errorBinding) {
                Button("OK", role: .cancel) { showError = nil }
            } message: {
                Text(showError ?? "")
            }
            .sheet(isPresented: pickerBinding) {
                if let side = pickerSide {
                    DepositAccountPickerSheet(viewModel: viewModel, side: side, isPresented: pickerBinding)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }

            if showSuccess {
                DepositSuccessView(viewModel: viewModel, isPresented: $showSuccess) {
                    dismiss()
                }
            }
        }
        .navigationTitle("Move Money")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color("CardText"))
                }
            }
        }
        .onAppear { viewModel.refresh() }
    }

    private var headerSubtitle: some View {
        VStack(spacing: 2) {
            Text("Move between your accounts")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 2)
    }

    private var needSecondAccountNotice: some View {
        let accent: Color = scheme == .dark ? Color("InsideCarBottomColor") : Color("CardColor")
        return HStack(spacing: 10) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 15))
                .foregroundStyle(accent)
            Text("Only 1 account found. Add another account in Settings → Accounts to move money.")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color("CardText"))
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(accent.opacity(scheme == .dark ? 0.14 : 0.08), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(accent.opacity(scheme == .dark ? 0.4 : 0.2), lineWidth: 1))
    }

    private var pickerBinding: Binding<Bool> {
        Binding(get: { pickerSide != nil }, set: { if !$0 { pickerSide = nil } })
    }

    private var errorBinding: Binding<Bool> {
        Binding(get: { showError != nil }, set: { if !$0 { showError = nil } })
    }

    private func handleMove() {
        if let error = viewModel.validate() {
            showError = error
            return
        }
        if viewModel.move() {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showSuccess = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        ZStack {
            CustomBackgroundView()
            DepositView()
        }
    }
}
