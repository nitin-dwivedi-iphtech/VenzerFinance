//
//  TransactionHeroView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct TransactionHeroView: View {
    @ObservedObject var viewModel: TransactionViewModel

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("YOU'RE SENDING")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white.opacity(0.6))
                    .tracking(1.2)

                Spacer()

                HStack(spacing: 5) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)
                    Text("LIVE")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white.opacity(0.8))
                        .tracking(0.8)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.white.opacity(0.12), in: Capsule())
            }

            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.formattedAmountWithSymbol)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.2), value: viewModel.amount)

                    Text(viewModel.availableText)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 52, height: 52)
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }

            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(height: 1)

            HStack(spacing: 8) {
                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.6))

                Text(viewModel.accountTitle)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Spacer(minLength: 4)

                Image(systemName: "arrow.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white.opacity(0.5))

                Spacer(minLength: 4)

                if let recipient = viewModel.selectedRecipient {
                    Text(recipient.initials)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(recipient.tint, in: Circle())

                    Text(recipient.name)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                } else {
                    Text("Select recipient")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.55))
                }
            }
        }
        .padding(20)
        .background(Color("CardColor"))
        .clipShape(NotchedCardShape(position: .top, direction: .inward))
        .shadow(color: Color("CardColor").opacity(0.25), radius: 14, x: 0, y: 8)
    }
}

struct TransactionFlowConnector: View {
    var body: some View {
        VStack(spacing: 2) {
            Circle()
                .fill(Color("CardColor").opacity(0.25))
                .frame(width: 5, height: 5)
            Rectangle()
                .fill(Color("CardColor").opacity(0.15))
                .frame(width: 2, height: 8)
            Image(systemName: "chevron.down")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color("CardColor").opacity(0.45))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, -2)
    }
}

#Preview {
    ZStack {
        CustomBackgroundView()
        VStack(spacing: 12) {
            TransactionHeroView(viewModel: TransactionViewModel())
            TransactionFlowConnector()
        }
        .padding(.horizontal, 20)
    }
}
