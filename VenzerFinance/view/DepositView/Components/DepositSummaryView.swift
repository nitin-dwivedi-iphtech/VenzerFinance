//
//  DepositSummaryView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 30/09/26.
//

import SwiftUI

struct DepositSummaryView: View {
    @ObservedObject var viewModel: DepositViewModel

    var body: some View {
        VStack(spacing: 0) {
            row(title: "Amount", value: viewModel.formattedAmountWithSymbol)
                .padding(.vertical, 8)
            Divider().overlay(Color("CardText").opacity(0.1))
            row(title: "From balance after", value: viewModel.money((viewModel.fromAccount?.balance ?? 0) - viewModel.depositValue))
                .padding(.vertical, 8)
            Divider().overlay(Color("CardText").opacity(0.1))
            row(title: "To balance after", value: viewModel.money((viewModel.toAccount?.balance ?? 0) + viewModel.depositValue), bold: true)
                .padding(.vertical, 8)
        }
        .transactionInnerBox()
        .transactionCard()
    }

    private func row(title: String, value: String, bold: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: bold ? .bold : .medium))
                .foregroundStyle(bold ? Color("CardText") : .gray)
            Spacer()
            Text(value)
                .font(.system(size: bold ? 16 : 14, weight: bold ? .bold : .semibold).monospacedDigit())
                .foregroundStyle(Color("CardText"))
        }
    }
}

struct DepositMoveButton: View {
    @ObservedObject var viewModel: DepositViewModel
    var onMove: () -> Void

    var body: some View {
        Button(action: onMove) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 15, weight: .semibold))
                Text("Move \(viewModel.formattedAmountWithSymbol)")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(viewModel.isMoveDisabled ? Color.gray.opacity(0.4) : Color("CardColor"), in: Capsule())
            .shadow(color: Color("CardColor").opacity(viewModel.isMoveDisabled ? 0 : 0.25), radius: 10, x: 0, y: 6)
        }
        .disabled(viewModel.isMoveDisabled)
        .animation(.easeInOut(duration: 0.2), value: viewModel.amount)
    }
}
