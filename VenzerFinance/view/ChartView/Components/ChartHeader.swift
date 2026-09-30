//
//  ChartHeader.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//

import SwiftUI

struct ChartHeaderView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Insights")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(1.2)
                Text("Spending Insights")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(Color("CardText"))
                Text("Sent vs received across your history")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chart.pie.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 46, height: 46)
                .background(Color("CardColor").gradient, in: RoundedRectangle(cornerRadius: 15))
                .shadow(color: Color("CardColor").opacity(0.35), radius: 10, x: 0, y: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ChartRangePicker: View {
    let options: [Int]
    @Binding var selected: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(options, id: \.self) { months in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selected = months
                    }
                } label: {
                    Text("\(months)M")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 9)
                        .background(
                            selected == months ? Color("CardColor") : Color.clear,
                            in: Capsule()
                        )
                        .foregroundStyle(
                            selected == months ? .white : Color("CardText").opacity(0.6)
                        )
                        .shadow(
                            color: selected == months
                                ? Color("CardColor").opacity(0.35) : .clear,
                            radius: 8, x: 0, y: 4
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color("CardBackground"), in: Capsule())
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
