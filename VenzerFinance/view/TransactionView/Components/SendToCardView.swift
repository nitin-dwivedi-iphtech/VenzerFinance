//
//  SendToCardView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct SendToCardView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @Binding var showRecipientSheet: Bool
    @Environment(\.colorScheme) private var scheme

    /// "Choose" pill accent: deep green on light, light mint on dark.
    private var chooseColor: Color {
        scheme == .dark ? Color("InsideCarBottomColor") : Color("CardColor")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TransactionSectionLabel(text: "Send to", step: "03")

            Button { showRecipientSheet = true } label: {
                HStack(spacing: 12) {
                    if let recipient = viewModel.selectedRecipient {
                        Text(recipient.initials)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(recipient.tint, in: Circle())

                        VStack(alignment: .leading, spacing: 2) {
                            Text(recipient.name)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color("CardText"))
                            Text(recipient.detail)
                                .font(.system(size: 12))
                                .foregroundStyle(.gray)
                        }

                        Spacer()

                        Image(systemName: "arrow.up.and.down.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(chooseColor.opacity(0.8))
                    } else {
                        Circle()
                            .fill(Color("InsideCarTopColor"))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color("CardColor"))
                            )

                        Text("Select Recipient")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.gray)

                        Spacer()

                        HStack(spacing: 6) {
                            Text("Choose")
                                .font(.system(size: 12, weight: .bold))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundStyle(chooseColor)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(chooseColor.opacity(0.14), in: Capsule())
                    }
                }
                .transactionInnerBox()
            }
            .buttonStyle(.plain)
        }
        .transactionCard()
    }
}
