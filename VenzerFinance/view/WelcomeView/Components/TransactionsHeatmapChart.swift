//
//  TransactionsHeatmapChart.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//
import SwiftUI

struct TransactionsHeatmapChart: View {
    private let monthColumns: [(month: String, weeks: Int)] = [
        ("Jun", 4), ("Jul", 4), ("Aug", 4), ("Sep", 4), ("Oct", 4)
    ]

    private let transactions: [[Int]] = [
        [2, 4, 1, 3, 5, 2, 4, 3, 1, 4, 2, 5, 3, 2, 4, 1, 3, 5, 2, 4],   // Mon
        [3, 2, 5, 1, 4, 3, 2, 5, 3, 1, 4, 2, 5, 3, 1, 4, 2, 3, 5, 1],   // Tue
        [1, 3, 2, 4, 0, 5, 3, 1, 2, 4, 3, 1, 2, 5, 4, 3, 1, 2, 4, 0],   // Wed
        [4, 1, 3, 5, 3, 2, 6, 4, 1, 3, 5, 4, 2, 3, 6, 5, 3, 4, 1, 2],   // Thu
        [5, 3, 4, 2, 6, 4, 5, 3, 4, 2, 6, 5, 3, 4, 7, 6, 2, 5, 4, 3],   // Fri
        [6, 5, 3, 6, 7, 5, 8, 6, 5, 7, 6, 8, 5, 6, 7, 9, 4, 6, 8, 5],   // Sat
        [2, 1, 4, 2, 3, 1, 2, 4, 1, 3, 2, 4, 2, 3, 1, 5, 3, 2, 4, 1]    // Sun
    ]

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
            ForEach(monthColumns, id: \.month) { column in
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

    // Single day dot

    private func cell(count: Int) -> some View {
        Circle()
            .fill(cellColor(count: count))
            .frame(width: cellSize, height: cellSize)
            .shadow(color: glowColor(count: count), radius: glowRadius(count: count), x: 0, y: 1)
            .padding(.all, cellPadding)
    }

    // Colors

    private func intensity(count: Int) -> Double {
        guard count > 0 else { return 0 }
        return 0.3 + 0.7 * Double(count) / Double(Swift.max(maxCount, 1))
    }

    private func cellColor(count: Int) -> Color {
        guard count > 0 else {
            return Color.black.opacity(0.05)
        }

        let t = intensity(count: count)
        let red = 0.929 + (0.033 - 0.929) * t
        let green = 0.955 + (0.188 - 0.955) * t
        let blue = 0.912 + (0.027 - 0.912) * t
        return Color(red: red, green: green, blue: blue)
    }

    // Glow: greener dots glow more strongly

    private func glowColor(count: Int) -> Color {
        guard count > 0 else { return .clear }
        return cellColor(count: count).opacity(0.25 + 0.45 * intensity(count: count))
    }

    private func glowRadius(count: Int) -> CGFloat {
        guard count > 0 else { return 0 }
        return 1.5 + 4 * intensity(count: count)
    }
}

#Preview {
    TransactionsHeatmapChart()
        .padding()
        .background(.white)
}
