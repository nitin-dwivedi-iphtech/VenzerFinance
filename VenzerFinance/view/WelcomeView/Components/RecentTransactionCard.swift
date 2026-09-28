//
//  RecentTransactionCard.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//


import SwiftUI

struct RecentTransactionCard: View {
    var body: some View {
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
    RecentTransactionCard()
        .padding(.horizontal, 20)
}
