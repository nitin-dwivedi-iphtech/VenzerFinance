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
