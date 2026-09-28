//
//  AmountInputSheet.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//

import SwiftUI

struct AmountInputSheet: View {
    @Binding var amountText: String
    var fromCountry: Country
    var toCountry: Country
    var rate: Double
    var maxBalance: Double
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter amount")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    HStack(spacing: 8) {
                        Text(fromCountry.currencySymbol)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.gray)
                        TextField("0.00", text: $amountText)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 28, weight: .medium))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.06), lineWidth: 1))
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                
                Text("1 \(fromCountry.currencyCode) = \(String(format: "%.4f", rate)) \(toCountry.currencyCode)")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                
                Button {
                    if let value = Double(amountText), value > maxBalance || value == 0 {
                        amountText = String(format: "%.2f", maxBalance)
                    }
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color("CardColor"), in: RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                
                Spacer()
            }
            .navigationTitle("Edit Amount")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.fraction(0.35), .medium])
        .presentationDragIndicator(.visible)
    }
}
