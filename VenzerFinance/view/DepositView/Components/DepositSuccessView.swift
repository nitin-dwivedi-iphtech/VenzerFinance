//
//  DepositSuccessView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 30/09/26.
//

import SwiftUI

struct DepositSuccessView: View {
    @ObservedObject var viewModel: DepositViewModel
    @Binding var isPresented: Bool
    var onDone: () -> Void
    @State private var animate = false

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy • h:mm a"
        return f
    }()

    private var successGreen: Color {
        Color(red: 0.13, green: 0.52, blue: 0.28)
    }

    // Capture values before reset so receipt stays correct.
    @State private var snapshotAmount = ""
    @State private var snapshotFrom = ""
    @State private var snapshotTo = ""

    var body: some View {
        ZStack {
            Color.black.opacity(0.45).ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 16) {
                ZStack {
                    Circle().fill(successGreen.opacity(0.16)).frame(width: 92, height: 92)
                        .scaleEffect(animate ? 1 : 0.6).opacity(animate ? 1 : 0)
                    Circle().fill(successGreen).frame(width: 64, height: 64)
                        .shadow(color: successGreen.opacity(0.45), radius: 16, x: 0, y: 6)
                        .scaleEffect(animate ? 1 : 0.4).opacity(animate ? 1 : 0)
                    Image(systemName: "checkmark")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                        .scaleEffect(animate ? 1 : 0.4).opacity(animate ? 1 : 0)
                }
                .frame(height: 92)

                VStack(spacing: 4) {
                    Text("Move Successful")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    Text(Self.dateFormatter.string(from: Date()))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.55))
                }

                Text(snapshotAmount.isEmpty ? viewModel.formattedAmountWithSymbol : snapshotAmount)
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(.white)
                    .monospacedDigit()

                VStack(spacing: 0) {
                    receiptRow(icon: "arrow.up.circle.fill", title: "From", value: snapshotFrom.isEmpty ? viewModel.title(for: viewModel.fromAccount) : snapshotFrom)
                    Divider().overlay(Color.white.opacity(0.12))
                    receiptRow(icon: "arrow.down.circle.fill", title: "To", value: snapshotTo.isEmpty ? viewModel.title(for: viewModel.toAccount) : snapshotTo)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))

                Button(action: dismiss) {
                    HStack(spacing: 8) {
                        Text("Done").font(.system(size: 16, weight: .semibold))
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundStyle(Color("CardColor"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.white, in: Capsule())
                }
                .padding(.top, 2)
            }
            .padding(22)
            .background(Color("CardColor"))
            .clipShape(NotchedCardShape(position: .top, direction: .inward))
            .shadow(color: Color.black.opacity(0.3), radius: 28, x: 0, y: 14)
            .padding(.horizontal, 28)
            .scaleEffect(animate ? 1 : 0.88)
            .opacity(animate ? 1 : 0)
            .onAppear {
                snapshotAmount = viewModel.formattedAmountWithSymbol
                snapshotFrom = viewModel.title(for: viewModel.fromAccount)
                snapshotTo = viewModel.title(for: viewModel.toAccount)
                withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) { animate = true }
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isPresented = false
            viewModel.resetAfterSuccess()
            onDone()
        }
    }

    private func receiptRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 10) {
            Circle().fill(Color.white.opacity(0.12)).frame(width: 30, height: 30)
                .overlay(Image(systemName: icon).font(.system(size: 12, weight: .semibold)).foregroundStyle(.white))
            Text(title).font(.system(size: 12)).foregroundStyle(.white.opacity(0.65))
            Spacer(minLength: 8)
            Text(value).font(.system(size: 13, weight: .semibold)).foregroundStyle(.white).lineLimit(1)
        }
        .padding(.vertical, 9)
    }
}
