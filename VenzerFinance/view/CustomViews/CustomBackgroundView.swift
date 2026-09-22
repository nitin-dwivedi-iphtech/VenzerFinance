//
//  CustomBackgroundView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 22/09/26.
//

import SwiftUI

struct CustomBackgroundView:View {
    var body: some View {
        ZStack {
            // Global background gradient
            LinearGradient(
                colors: [
                    Color.clear,
                    Color("BackgroundColor").opacity(0.5),
                    Color("BackgroundColor").opacity(0.15),
                    Color("BackgroundColor").opacity(0.6)
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            
            // Global watermark "V" shapes
            GeometryReader { proxy in
                ZStack {
                    Text("v")
                        .font(.system(size: proxy.size.width * 1.8, weight: .bold))
                        .foregroundColor(Color.black.opacity(0.025))
                        .rotationEffect(.degrees(-261))
                        .offset(
                            x: proxy.size.width * 0.85,
                            y: -proxy.size.height * 0.3
                        )
                    
                    Text("v")
                        .font(.system(size: proxy.size.width * 1.8, weight: .bold))
                        .foregroundColor(Color.black.opacity(0.025))
                        .rotationEffect(.degrees(-27))
                        .offset(
                            x: -proxy.size.width * 0.5,
                            y: -proxy.size.height * 0.7
                        )
                }
                .allowsHitTesting(false)
                
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
}

#Preview {
    CustomBackgroundView()
}
