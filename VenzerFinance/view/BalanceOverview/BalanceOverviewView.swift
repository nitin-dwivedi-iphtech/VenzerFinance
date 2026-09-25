//
//  BalanceOverviewView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//
import SwiftUI

struct BalanceOverviewView: View {
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators:false) {
                VStack(spacing: 0) {
                    // Header Area
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Your Balance\nOverview")
                                .font(.system(size: 32, weight: .bold))
                                .lineLimit(2)
                            
                            Text("Track spending, earnings, and insights")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .padding(.top, 10)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    Spacer().frame(height: 40)
                    
                    // Main Balance Card & Action Buttons
                    ZStack {
                        // The main white scooped card with perfect outer circular bounds
                        BalanceOverviewCardShape()
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 20, x: 0, y: 10)
                            .frame(width: 320, height: 320)
                        
                        // Inner dashed arc
                        InnerDashedArc()
                            .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 6]))
                            .foregroundColor(.gray.opacity(0.3))
                            .frame(width: 240, height: 240)
                            .offset(y: -10)
                        
                        // Top floating $ badge
                        Circle()
                            .frame(width: 40, height: 40)
                            .overlay(Text("$").foregroundColor(.white).font(.headline))
                            .offset(y: -130)
                        
                        // Center Chart Mockup
                        MockChartView()
                            .frame(height: 80)
                            .offset(y: -50)
                        
                        // Balance Text
                        VStack(spacing: 4) {
                            Text("$4,309,573.02")
                                .font(.system(size: 22, weight: .bold))
                            
                            Text("Total Balance")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .offset(y: 20)
                        
                        // Floating Action Buttons aligned to the outer bottom curve
                        ZStack {
                            FloatingActionButton(icon: "chart.bar.fill", isSelected: false)
                                .offset(x: -115, y: 110)
                                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)// Far left
                            
                            FloatingActionButton(icon: "chart.pie.fill", isSelected: false)
                                .offset(x: -65, y: 95)
                                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4) // Mid left
                            
                            FloatingActionButton(icon: "waveform.path.ecg", isSelected: true)
                                .offset(x: 0, y: 85)
                                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)// Center (Active)
                            
                            FloatingActionButton(icon: "percent", isSelected: false)
                                .offset(x: 65, y: 95)
                                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)// Mid right
                            
                            FloatingActionButton(icon: "wallet.pass.fill", isSelected: false)
                                .offset(x: 115, y: 110)
                                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)// Far right
                        }
                    }
                    
                    
                    // Bottom Income Card
                    HStack {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "arrow.down.left")
                                        .foregroundColor(.green)
                                )
                            
                            Text("Income")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("February")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("$231,839.00")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color("CardColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
            }.background {
                CustomBackgroundView()
            }
        }
    }
}

#Preview {
    BalanceOverviewView()
}
