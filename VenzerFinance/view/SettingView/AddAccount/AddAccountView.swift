//
//  AddAccountView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//
import SwiftUI

struct AddAccountView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var accountNo: String = ""
    @State private var bankName: String = ""
    @State private var balanceText: String = ""
    
    private var previewName: String { bankName.isEmpty ? "Your Bank" : bankName }
    private var previewBalance: String { balanceText.isEmpty ? "$0.00" : "$\(balanceText)" }
    private var previewLastFour: String { accountNo.isEmpty ? "••••" : String(accountNo.suffix(4)) }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Circle().fill(Color.green).frame(width: 6, height: 6)
                        Text("LIVE PREVIEW").font(.system(size: 10, weight: .bold)).foregroundColor(.gray).tracking(0.8)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    AccountCardView(
                        displayName: previewName,
                        balanceText: previewBalance,
                        lastFour: previewLastFour,
                        bankLabel: "PayPal"
                    )
                    .padding(.horizontal, 16)
                    .animation(.easeInOut(duration: 0.25), value: accountNo)
                    .animation(.easeInOut(duration: 0.25), value: bankName)
                    .animation(.easeInOut(duration: 0.25), value: balanceText)
                }
                .padding(.top, 8)
                
                formCard
                saveButton
                secureNote
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Add Account")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 16, weight: .semibold)).foregroundColor(.black)
                        .frame(width: 36, height: 36).background(Color.white, in: Circle())
                        .overlay(Circle().stroke(Color.black.opacity(0.06), lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                }
            }
        }
        .background { CustomBackgroundView() }
    }
    
    private var formCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle().fill(Color("CardColor")).frame(width: 28, height: 28)
                    .overlay(Image(systemName: "creditcard.fill").font(.system(size: 12, weight: .semibold)).foregroundColor(Color("InsideCarBottomColor")))
                VStack(alignment: .leading, spacing: 1) {
                    Text("Account information").font(.system(size: 14, weight: .bold)).foregroundColor(.black)
                    Text("As shown on your statement").font(.system(size: 11)).foregroundColor(.gray)
                }
                Spacer()
                Circle().fill(Color("InsideCarTopColor")).frame(width: 28, height: 28)
                    .overlay(Image(systemName: "lock.shield.fill").font(.system(size: 11)).foregroundColor(Color("CardColor")))
            }
            
            VStack(spacing: 10) {
                field(title: "Account Number", text: $accountNo, icon: "number", placeholder: "0849 1234 5678", keyboard: .numberPad)
                field(title: "Bank Name", text: $bankName, icon: "building.columns.fill", placeholder: "e.g. PayPal, Chase")
                field(title: "Initial Balance", text: $balanceText, icon: "dollarsign.circle.fill", placeholder: "0.00", keyboard: .decimalPad)
            }
            .padding(12)
            .background(Color("InsideCarTopColor").opacity(0.38), in: RoundedRectangle(cornerRadius: 16))
        }
        .padding(16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.06), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 16)
    }
    
    private func field(title: String, text: Binding<String>, icon: String, placeholder: String = "", keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color("InsideCarBottomColor")
                        .opacity(0.18)).frame(width: 22, height: 22)
                    .overlay(Image(systemName: icon)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Color("CardColor")))
                
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
                    .tracking(0.2)
            }
            HStack(spacing: 8) {
                TextField(placeholder, text: text)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .keyboardType(keyboard)
                
                Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color("CardColor").opacity(0.7))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.06), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
    }
    
    private var saveButton: some View {
        VStack(spacing: 10) {
            Button {
                // handel saving in core data
                dismiss()
            } label: {
                HStack(spacing: 8) {
                    Text("Add Account")
                        .font(.system(size: 16, weight: .semibold))
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color("CardColor"), in: Capsule())
                .shadow(color: Color("CardColor").opacity(0.25), radius: 10, x: 0, y: 6)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 4)
    }
    
    private var secureNote: some View {
        HStack(spacing: 6) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 11))
                .foregroundColor(Color("InsideCarBottomColor"))
            
            Text("You can edit these details later in Account Details")
                .font(.system(size: 11))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    NavigationStack { AddAccountView() }
}
