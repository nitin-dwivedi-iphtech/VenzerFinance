//
//  FromAccountCardView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct FromAccountCardView: View {
    @ObservedObject var viewModel: TransactionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TransactionSectionLabel(text: "From account", step: "01")

            HStack(spacing: 14) {
                Text(viewModel.userInitial)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 46, height: 46)
                    .background(Color("CardColor"), in: RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 3) {
                    Text(viewModel.accountTitle)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Text(viewModel.availableText)
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                }

                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color(red: 0.13, green: 0.52, blue: 0.28))
            }
            .transactionInnerBox()
        }
        .transactionCard()
    }
}
