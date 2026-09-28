//
//  TransactionsHeatmapChart.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//
import SwiftUI

struct TransactionsHeatmapChart: View {
    
    @Environment(\.colorScheme) private var scheme
    
    let monthColumns: [(month: String, weeks: Int)]
    let transactions: [[Int]]

    private let cellSize: CGFloat = 5
    private let cellPadding: CGFloat = 4
    private let columnSpacing: CGFloat = 2
    private let rowSpacing: CGFloat = 6

    private var cellWidth: CGFloat {
        cellSize + cellPadding * 2
    }

    private var maxCount: Int {
        transactions.flatMap { $0 }.max() ?? 1
    }


    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            monthLabels
            grid
        }
        .frame(maxWidth: .infinity)
    }

    // Month labels (X axis)

    private var monthLabels: some View {
        HStack(spacing: columnSpacing) {
            ForEach(monthColumns.indices, id: \.self) { index in
                let column = monthColumns[index]
                Text(column.month)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.gray)
                    .frame(width: CGFloat(column.weeks) * cellWidth + CGFloat(column.weeks - 1) * columnSpacing)
            }
        }
    }

    // Dots grid

    private var grid: some View {
        VStack(spacing: rowSpacing) {
            ForEach(transactions.indices, id: \.self) { row in
                HStack(spacing: columnSpacing) {
                    ForEach(transactions[row].indices, id: \.self) { column in
                        cell(count: transactions[row][column])
                            .opacity(0.7)
                    }
                }
            }
        }
    }

    private func cell(count: Int) -> some View {
        Circle()
            .fill(cellColor(count: count))
            .frame(width: cellSize, height: cellSize)
            .padding(.all, cellPadding)
    }

    // Colors

    private func intensity(count: Int) -> Double {
        guard count > 0 else { return 0 }
        return 0.3 + 0.7 * Double(count) / Double(Swift.max(maxCount, 1))
    }


    private func cellColor(count: Int) -> Color {
        guard count > 0 else {
            return scheme == .dark ? Color.white.opacity(0.09) : Color.black.opacity(0.05)
        }

        let t = intensity(count: count)
        if scheme == .dark {
            let red = 0.050 + (0.190 - 0.050) * t
            let green = 0.280 + (0.850 - 0.280) * t
            let blue = 0.160 + (0.380 - 0.160) * t
            return Color(red: red, green: green, blue: blue)
        }

        let red = 0.929 + (0.033 - 0.929) * t
        let green = 0.955 + (0.188 - 0.955) * t
        let blue = 0.912 + (0.027 - 0.912) * t
        return Color(red: red, green: green, blue: blue)
    }
}

#Preview {
    TransactionsHeatmapChart(
        monthColumns: [("Jun", 4), ("Jul", 4), ("Aug", 4), ("Sep", 4), ("Oct", 4)],
        transactions: [
            [0, 0, 1, 0, 2, 0, 1, 0, 0, 3, 1, 0, 2, 0, 1, 0, 0, 2, 1, 0],
            [0, 1, 0, 0, 1, 0, 0, 2, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1],
            [0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 2, 0, 0, 0, 1, 0, 0, 1, 0, 0],
            [1, 0, 0, 0, 1, 0, 2, 0, 0, 1, 0, 0, 0, 1, 0, 0, 2, 0, 0, 0],
            [0, 2, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 2, 0, 1, 0, 0, 1, 0],
            [0, 0, 1, 0, 0, 1, 0, 0, 2, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 2],
            [0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0]
        ]
    )
        .padding()
        .background(Color("CardBackground"))
}
