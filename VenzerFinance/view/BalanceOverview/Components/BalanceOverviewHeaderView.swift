//
//  BalanceOverviewHeaderView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct BalanceOverviewHeaderView: View {
    @ObservedObject var viewModel: BalanceOverviewViewModel
    @Binding var spinAngle: Double

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Your Balance\nOverview")
                    .font(.system(size: 32, weight: .bold))
                    .lineLimit(2)

                Text("Track spending, earnings, and insights")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Button {
                    withAnimation(.easeInOut(duration: 0.6)) { spinAngle += 360 }
                    viewModel.refresh()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(width: 40, height: 40)
                        .background(.white.opacity(0.67), in: Circle())
                        .rotationEffect(.degrees(spinAngle))
                }.padding(.bottom,10)

                AccountHeaderButton()
            }
            .padding(.top, 6)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }
}

#Preview {
    BalanceOverviewHeaderView(viewModel: BalanceOverviewViewModel(), spinAngle: .constant(360.0))
}
