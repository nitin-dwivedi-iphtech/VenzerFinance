//
//  BalanceEmptyStateView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct BalanceEmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(.white)
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(Color("CardColor"))
                )
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)

            Text("No account found")
                .font(.system(size: 16, weight: .bold))
            Text("Add an account in Settings to see your overview.")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 44)
    }
}
