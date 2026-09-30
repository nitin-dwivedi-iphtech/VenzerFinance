//
//  RecipientSheetView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct RecipientSheetView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @Binding var isPresented: Bool
    @State private var query: String = ""

    private var filtered: [RecipientItem] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return viewModel.recipients }
        return viewModel.recipients.filter {
            $0.name.localizedCaseInsensitiveContains(q)
                || $0.detail.localizedCaseInsensitiveContains(q)
        }
    }

    var body: some View {
        ZStack {
            CustomBackgroundView()

            VStack(spacing: 0) {
                header
                searchField

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        if viewModel.recipients.isEmpty {
                            emptyNoUsers
                        } else if filtered.isEmpty {
                            emptyNoMatch
                        } else {
                            ForEach(filtered) { recipient in
                                row(recipient)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .padding(.bottom, 24)
                    .animation(.easeInOut(duration: 0.2), value: filtered.count)
                }
            }.padding()
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Select Recipient")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color("CardText"))

                Text(headerSubtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
            }

            Spacer()

            Button { isPresented = false } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color("CardText"))
                    .frame(width: 34, height: 34)
                    .background(Color("CardText").opacity(0.08), in: Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
    }

    private var headerSubtitle: String {
        let count = viewModel.recipients.count
        guard count > 0 else { return "Invite users to get started" }
        return count == 1 ? "1 person" : "\(count) people"
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.gray)

            TextField("Search name or bank", text: $query)
                .font(.system(size: 14))
                .foregroundStyle(Color("CardText"))
                .submitLabel(.search)

            if !query.isEmpty {
                Button { query = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(Color("CardText").opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }


    private func row(_ recipient: RecipientItem) -> some View {
        let isSelected = viewModel.selectedRecipient?.id == recipient.id

        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.select(recipient)
                isPresented = false
            }
        } label: {
            HStack(spacing: 12) {
                Text(recipient.initials)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 46, height: 46)
                    .background(recipient.tint, in: Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(recipient.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color("CardText"))

                    Text(recipient.detail)
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }

                Spacer(minLength: 8)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(red: 0.13, green: 0.52, blue: 0.28))
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
            .padding(12)
            .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? Color("CardColor") : Color.black.opacity(0.06),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    private var emptyNoUsers: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color("CardBackground"))
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color("CardColor"))
                )
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)

            Text("No recipients found")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color("CardText"))

            Text("No other users exist yet.\nCreate another account to send money.")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private var emptyNoMatch: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color("CardBackground"))
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24))
                        .foregroundStyle(Color("CardColor"))
                )
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)

            Text("No matches")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color("CardText"))

            Text("Nothing matches \"\(query.trimmingCharacters(in: .whitespacesAndNewlines))\".")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
