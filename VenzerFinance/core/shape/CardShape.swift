//
//  CardShape.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 18/09/26.
//

import SwiftUI
import Foundation

struct NotchedCardShape: Shape {
    enum NotchPosition {
        case top
        case bottom
    }
    
    enum NotchDirection {
        case inward
        case outward
    }
    
    var notchWidth: CGFloat = 120
    var notchHeight: CGFloat = 10
    var cornerRadius: CGFloat = 24
    var position: NotchPosition = .top
    var direction: NotchDirection = .inward
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let midX = width / 2
        let halfNotch = notchWidth / 2
        
        let bottomRadius: CGFloat = (position == .bottom) ? 0 : cornerRadius
        
        let yOffset: CGFloat = (position == .top) ? 0 : height
        let multiplier: CGFloat = (position == .top) ? 1 : -1
        let notchY: CGFloat = yOffset + (notchHeight * (direction == .inward ? 1 : -1) * multiplier)
        
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        
        if position == .top {
            path.addLine(to: CGPoint(x: midX - halfNotch - 8, y: 0))
            path.addQuadCurve(
                to: CGPoint(x: midX - halfNotch, y: notchY),
                control: CGPoint(x: midX - halfNotch, y: 0)
            )
            path.addLine(to: CGPoint(x: midX + halfNotch, y: notchY))
            path.addQuadCurve(
                to: CGPoint(x: midX + halfNotch + 8, y: 0),
                control: CGPoint(x: midX + halfNotch, y: 0)
            )
        }
        
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        path.addArc(
            center: CGPoint(x: width - cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: width, y: height - bottomRadius))
        
        if bottomRadius > 0 {
            path.addArc(
                center: CGPoint(x: width - bottomRadius, y: height - bottomRadius),
                radius: bottomRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false
            )
        } else {
            path.addLine(to: CGPoint(x: width, y: height))
        }
        
        if position == .bottom {
            path.addLine(to: CGPoint(x: midX + halfNotch + 8, y: height))
            path.addQuadCurve(
                to: CGPoint(x: midX + halfNotch, y: notchY),
                control: CGPoint(x: midX + halfNotch, y: height)
            )
            path.addLine(to: CGPoint(x: midX - halfNotch, y: notchY))
            path.addQuadCurve(
                to: CGPoint(x: midX - halfNotch - 8, y: height),
                control: CGPoint(x: midX - halfNotch, y: height)
            )
        }
        
        if bottomRadius > 0 {
            path.addLine(to: CGPoint(x: bottomRadius, y: height))
            path.addArc(
                center: CGPoint(x: bottomRadius, y: height - bottomRadius),
                radius: bottomRadius,
                startAngle: .degrees(90),
                endAngle: .degrees(180),
                clockwise: false
            )
        } else {
            path.addLine(to: CGPoint(x: 0, y: height))
        }
        
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(
            center: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        
        return path
    }
}

struct BalanceOverviewCardShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        //  top outer circle arc
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(145),
            endAngle: .degrees(35),
            clockwise: false
        )
        
        //  left point to complete the shape
        let leftPoint = CGPoint(
            x: center.x + radius * cos(145 * .pi / 180),
            y: center.y + radius * sin(145 * .pi / 180)
        )
        
        // Flatter bottom curve
        let bottomScoopControl = CGPoint(
            x: rect.midX,
            y: rect.midY + (radius * 0.5)
        )
        
        path.addQuadCurve(to: leftPoint, control: bottomScoopControl)
        
        path.closeSubpath()
        return path
    }
}

//  Supporting Components

struct InnerDashedArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        return path
    }
}

struct MockChartView: View {
    var balance: Double
    var pillText: String

    init(balance: Double, pillText: String) {
        self.balance = balance
        self.pillText = pillText
    }

    init(pillText: String) {
        self.balance = Double(pillText) ?? 0
        self.pillText = pillText
    }

    // 0...1 sensitive in 0-2000 range: 200->0.29, 700->0.58, 5k->0.91
    var normalized: Double {
        guard balance > 0 else { return 0 }
        return balance / (balance + 500.0)
    }
    var value: Double {
        
        1 + (normalized * 5)
    }
    
    var amp: CGFloat {
        CGFloat(6 + (normalized * 34))
    }
    
    var pillDisplay: String {
        String(format: "%.2f", balance)
    }

    private func cubic(_ t: CGFloat, _ a: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
        let u = 1 - t
        return u * u * u * a + 3 * u * u * t * b + 3 * u * t * t * c + t * t * t * d
    }

    // Exact point on segment-2 at x == targetX
    private func dotOnCurve(width: CGFloat, midY: CGFloat, amp: CGFloat, targetX: CGFloat) -> CGPoint {
        let p0 = CGPoint(x: width * 0.3, y: midY + amp * 0.6)
        let p1 = CGPoint(x: width * 0.4, y: midY - amp * 0.9)
        let p2 = CGPoint(x: width * 0.45, y: midY - amp * 0.8)
        let p3 = CGPoint(x: width * 0.5, y: midY)
        var lo: CGFloat = 0
        var hi: CGFloat = 1
        var i = 0
        while i < 24 {
            let mid = (lo + hi) / 2
            if cubic(mid, p0.x, p1.x, p2.x, p3.x) < targetX {
                lo = mid
            } else {
                hi = mid
            }
            i += 1
        }
        let t = (lo + hi) / 2
        return CGPoint(x: targetX, y: cubic(t, p0.y, p1.y, p2.y, p3.y))
    }
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let midY = height / 2
            let amp = self.amp
            let control2Y = midY - (amp * 0.8)
            let dot = dotOnCurve(width: width, midY: midY, amp: amp, targetX: width * 0.41875)
            let circleX = dot.x
            let circleY = dot.y
            
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: midY))
                    path.addCurve(to: CGPoint(x: width * 0.3, y: midY + amp * 0.6),
                                  control1: CGPoint(x: width * 0.1, y: midY - amp * 0.6),
                                  control2: CGPoint(x: width * 0.2, y: midY + amp * 1.2))
                    
                    path.addCurve(to: CGPoint(x: width * 0.5, y: midY),
                                  control1: CGPoint(x: width * 0.4, y: midY - amp * 0.9),
                                  control2: CGPoint(x: width * 0.45, y: control2Y))
                    
                    path.addCurve(to: CGPoint(x: width * 0.7, y: midY - amp),
                                  control1: CGPoint(x: width * 0.55, y: midY),
                                  control2: CGPoint(x: width * 0.6, y: midY - amp - amp * 0.6))
                    
                    path.addCurve(to: CGPoint(x: width, y: midY - (amp * 0.35)),
                                  control1: CGPoint(x: width * 0.8, y: midY + amp * 0.6),
                                  control2: CGPoint(x: width * 0.9, y: midY - amp * 0.5))
                }
                .stroke(
                    LinearGradient(colors: [.green.opacity(0.3), .green, .green.opacity(0.2)], startPoint: .leading, endPoint: .trailing),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .animation(.easeInOut(duration: 0.5), value: amp)
                
                Circle()
                    .strokeBorder(Color.white, lineWidth: 2)
                    .background(Circle().fill(Color(red: 0.05, green: 0.22, blue: 0.18)))
                    .frame(width: 12, height: 12)
                    .position(x: circleX, y: circleY)
                
                Capsule()
                    .fill(Color(red: 0.05, green: 0.22, blue: 0.18))
                    .frame(width: 52, height: 20)
                    .overlay(Text(pillDisplay).font(.system(size: 10, weight: .bold)).foregroundColor(.white))
                    .position(x: circleX, y: circleY - 20)
            }
        }
        .frame(width: 220)
    }
}

#Preview {
    VStack(spacing: 30) {
        MockChartView(pillText: "4700.0")
    }
    .padding(40)
}
