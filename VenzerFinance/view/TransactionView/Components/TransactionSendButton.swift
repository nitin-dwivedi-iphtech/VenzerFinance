//
//  TransactionSendButton.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct TransactionSendButton: View {
    @ObservedObject var viewModel: TransactionViewModel
    var onSend: () -> Void

    var body: some View {
        Button(action: onSend) {
            HStack(spacing: 8) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 15, weight: .semibold))
                Text("Send \(viewModel.formattedAmountWithSymbol)")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(viewModel.isSendDisabled ? Color.gray.opacity(0.4) : Color("CardColor"), in: Capsule())
            .shadow(color: Color("CardColor").opacity(viewModel.isSendDisabled ? 0 : 0.25), radius: 10, x: 0, y: 6)
        }
        .disabled(viewModel.isSendDisabled)
        .animation(.easeInOut(duration: 0.2), value: viewModel.amount)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedRecipient != nil)
    }
}
