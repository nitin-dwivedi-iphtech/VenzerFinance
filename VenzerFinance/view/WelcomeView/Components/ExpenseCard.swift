//
//  ExpenseCard.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//


import SwiftUI

struct ExpenseCard: View {
    var body: some View {
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

                    Text("0")
                        .font(.system(size: 18, weight: .bold))
                }
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
}

#Preview {
    ExpenseCard()
        .padding(.horizontal, 20)
}
