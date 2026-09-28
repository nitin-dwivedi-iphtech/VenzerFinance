//
//  FloatingButton.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//

import SwiftUI

struct FloatingActionButton: View {
    var icon: String
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(isSelected ? Color(red: 0.05, green: 0.22, blue: 0.18) : Color.white)
                .shadow(color: Color.black.opacity(isSelected ? 0.2 : 0.06), radius: 8, x: 0, y: 5)
            
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isSelected ? .white : Color(red: 0.05, green: 0.22, blue: 0.18))
        }
        .frame(width: isSelected ? 70 : 36, height: isSelected ? 36 : 50)
    }
}
