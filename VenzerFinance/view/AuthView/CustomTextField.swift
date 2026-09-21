//
//  CustomTextField.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//
import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var prompt: String
    var iconName: String? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            if let iconName {
                Image(systemName: iconName)
                    .foregroundStyle(.gray)
                    .font(.system(size: 16))
            }
            
            TextField(
                "",
                text: $text,
                prompt: Text(prompt).foregroundColor(.gray.opacity(0.7))
            )
            .font(.system(size: 15))
            .foregroundStyle(.black)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.15).ignoresSafeArea()
        
        CustomTextField(
            text: .constant(""),
            prompt: "Search transactions...",
            iconName: "magnifyingglass"
        )
        .padding()
    }
}
