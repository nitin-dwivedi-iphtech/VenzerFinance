//
//  TransactionSuccessView.swift
//  VenzerFinance
//

import SwiftUI

struct TransactionSuccessView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @Binding var isPresented: Bool
    var endShow:()->Void
    @State private var animate = false

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy • h:mm a"
        return formatter
    }()

    private var successGreen: Color {
        Color(red: 0.13, green: 0.52, blue: 0.28)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.45).ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(successGreen.opacity(0.16))
                        .frame(width: 92, height: 92)
                        .scaleEffect(animate ? 1 : 0.6)
                        .opacity(animate ? 1 : 0)

                    Circle()
                        .fill(successGreen)
                        .frame(width: 64, height: 64)
                        .shadow(color: successGreen.opacity(0.45), radius: 16, x: 0, y: 6)
                        .scaleEffect(animate ? 1 : 0.4)
                        .opacity(animate ? 1 : 0)

                    Image(systemName: "checkmark")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                        .scaleEffect(animate ? 1 : 0.4)
                        .opacity(animate ? 1 : 0)
                }
                .frame(height: 92)

                VStack(spacing: 4) {
                    Text("Transfer Successful")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)

                    Text(Self.dateFormatter.string(from: Date()))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.55))
                }

                Text(viewModel.formattedAmountWithSymbol)
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .monospacedDigit()

                VStack(spacing: 0) {
                    receiptRow(
                        icon: "wallet.pass.fill",
                        title: "From",
                        value: viewModel.accountTitle
                    )

                    Divider().overlay(Color.white.opacity(0.12))

                    receiptRow(
                        icon: "person.fill",
                        title: "To",
                        value: viewModel.selectedRecipient?.name ?? "Recipient",
                        avatar: viewModel.selectedRecipient
                    )

                    Divider().overlay(Color.white.opacity(0.12))

                    receiptRow(
                        icon: "bolt.fill",
                        title: "Fee",
                        value: "\(viewModel.currencySymbol)0.00"
                    )
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))

                Button(action: dismiss) {
                    HStack(spacing: 8) {
                        Text("Done")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundStyle(Color("CardColor"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.white, in: Capsule())
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
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
                withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                    animate = true
                }
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isPresented = false
            viewModel.resetAfterSuccess()
            endShow()
        }
    }

    private func receiptRow(icon: String, title: String, value: String, avatar: RecipientItem? = nil) -> some View {
        HStack(spacing: 10) {
            if let avatar {
                Text(avatar.initials)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .background(avatar.tint, in: Circle())
            } else {
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                    )
            }

            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.65))

            Spacer(minLength: 8)

            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
        }
        .padding(.vertical, 9)
    }
}

struct TransactionEmptyStateView: View {
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
                .foregroundStyle(Color("CardText"))
            Text("Add an account in Settings to start sending money.")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .padding(.horizontal, 20)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.06), lineWidth: 1))
    }
}
