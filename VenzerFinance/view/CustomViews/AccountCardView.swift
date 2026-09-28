//
//  AccountCardView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//

import SwiftUI

struct AccountCardView: View {
    var displayName: String
    var balanceText: String
    var lastFour: String
    var bankLabel: String = "PayPal"

    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottom) {
                UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20)
                    .fill(Color("InsideCarTopColor"))
                    .frame(height: 70)
                    .overlay(alignment: .top) {
                        HStack(spacing: 2) {
                            Text(displayName)
                                .font(.system(size: 15))
                                .bold()
                                .foregroundStyle(.black)
                            Spacer()
                            Text(bankLabel)
                                .font(.system(size: 15))
                                .bold()
                                .italic()
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    }
                    .padding(.bottom, 15)

                HStack {
                    Text("•••• \(lastFour)")
                        .font(.system(size: 15))
                        .foregroundStyle(.black.opacity(0.7))
                    
                    Spacer()
                    
                    Text("VISA")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                }
                .padding(.top, 12).padding(.bottom, 20)
                .padding(.horizontal, 20)
                .background(Color("InsideCarBottomColor"))
                .clipShape(NotchedCardShape(position: .bottom, direction: .inward))
                .offset(y: 20)
            }
            .padding(.bottom, 20)

            VStack(spacing: 4) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color("InsideCarBottomColor"))
                
                Text(balanceText)
                    .font(.system(size: 26, weight: .bold))
                
                Text("Total Balance")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.vertical, 12).padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 0.5, lineCap: .round, dash: [6, 6]))
            )

            HStack(spacing: 12) {
                Button(action: {}) {
                    Label("Deposit", systemImage: "square.and.arrow.down")
                        .font(.subheadline).frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.12)).cornerRadius(20)
                }
                Button(action: {}) {
                    Label("Send", systemImage: "paperplane.fill")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(.black).background(Color.white).cornerRadius(20)
                }
            }
        }
        .padding(.all, 20)
        .background(Color("CardColor"))
        .clipShape(NotchedCardShape(position: .top, direction: .inward))
        .foregroundStyle(.white)
    }
}

#Preview {
    AccountCardView(displayName: "Maya", balanceText: "$4,309,573.02", lastFour: "0849")
        .padding()
}
