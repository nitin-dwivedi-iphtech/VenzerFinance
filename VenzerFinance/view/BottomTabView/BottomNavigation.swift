//
//  BottomNavigation.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//

import SwiftUI

struct BottomNavigation: View {
    @Binding var currentTab: Tab
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases) { tab in
                let isSelected = currentTab == tab
                
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        currentTab = tab
                    }
                } label: {
                    Image(systemName: tab.rawValue)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(isSelected ? .black : .white)
                    
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background {
                            if isSelected {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 50, height: 50) 
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                }
            }
        }
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color("CardColor"))
                .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 65)
    }
}

#Preview {
    BottomNavigation(currentTab: .constant(.home))
    
}
