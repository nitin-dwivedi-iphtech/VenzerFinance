//
//  CardShape.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 18/09/26.
//

import SwiftUI

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
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Path { path in
                    let width = geo.size.width
                    let height = geo.size.height
                    let midY = height / 2
                    
                    path.move(to: CGPoint(x: 0, y: midY))
                    path.addCurve(to: CGPoint(x: width * 0.3, y: midY + 20),
                                  control1: CGPoint(x: width * 0.1, y: midY - 20),
                                  control2: CGPoint(x: width * 0.2, y: midY + 40))
                    path.addCurve(to: CGPoint(x: width * 0.5, y: midY),
                                  control1: CGPoint(x: width * 0.4, y: midY - 30),
                                  control2: CGPoint(x: width * 0.45, y: midY))
                    path.addCurve(to: CGPoint(x: width * 0.7, y: midY - 30),
                                  control1: CGPoint(x: width * 0.55, y: midY),
                                  control2: CGPoint(x: width * 0.6, y: midY - 50))
                    path.addCurve(to: CGPoint(x: width, y: midY - 10),
                                  control1: CGPoint(x: width * 0.8, y: midY + 20),
                                  control2: CGPoint(x: width * 0.9, y: midY - 20))
                }
                .stroke(
                    LinearGradient(colors: [.green.opacity(0.3), .green, .green.opacity(0.2)], startPoint: .leading, endPoint: .trailing),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                
                Circle()
                    .strokeBorder(Color.white, lineWidth: 2)
                    .background(Circle().fill(Color(red: 0.05, green: 0.22, blue: 0.18)))
                    .frame(width: 12, height: 12)
                    .position(x: geo.size.width * 0.5, y: geo.size.height / 2)
                
                Capsule()
                    .fill(Color(red: 0.05, green: 0.22, blue: 0.18))
                    .frame(width: 44, height: 20)
                    .overlay(Text("-27%").font(.system(size: 10, weight: .bold)).foregroundColor(.white))
                    .position(x: geo.size.width * 0.5, y: geo.size.height / 2 + 20)
            }
        }
        .frame(width: 220)
    }
}

#Preview {
    VStack(spacing: 30) {
        NotchedCardShape(position: .top, direction: .outward)
            .fill(Color.blue)
            .frame(width: 300, height: 120)
        
        NotchedCardShape(position: .bottom, direction: .inward)
            .fill(Color.green)
            .frame(width: 300, height: 120)
    }
    .padding(40)
}
