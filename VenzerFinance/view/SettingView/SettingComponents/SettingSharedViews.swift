//
//  SettingSharedViews.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//

import SwiftUI

struct SettingCardContainer<Content: View>: View {
    let title: String
    let subtitle: String
    let iconName: String
    let content: Content
    var showEditBtn: Bool = false
    var onClick: ()->Void
    
    init(
        title: String,
        subtitle: String,
        iconName: String,
        showEditBtn: Bool = false,
        onClick: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.showEditBtn = showEditBtn
        self.onClick = onClick
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Circle().fill(Color("CardColor"))
                    .frame(width: 28, height: 28)
                    .overlay(Image(systemName: iconName).font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color("InsideCarBottomColor")))
                VStack(alignment: .leading, spacing: 1) {
                    Text(title).font(.system(size: 14, weight: .bold)).foregroundColor(.black)
                    Text(subtitle).font(.system(size: 11)).foregroundColor(.gray)
                }
                Spacer()
                if showEditBtn {
                    Button(action:{
                        onClick()
                    }) {
                        Image(systemName: "pencil.and.outline")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                            .foregroundStyle(.black)
                    }
                }
            }
            content
                .padding(4)
                .background(Color("InsideCarTopColor").opacity(0.38), in: RoundedRectangle(cornerRadius: 16))
        }
        .padding(16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.06), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

struct SimpleRow: View {
    let icon: String
    let title: String
    let value: String?
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.white).frame(width: 30, height: 30)
                .overlay(Image(systemName: icon).font(.system(size: 12, weight: .semibold)).foregroundColor(Color("CardColor")))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.black.opacity(0.8))
            
            Spacer()
            
            Text(value ?? "—")
                .font(.system(size: 13))
                .foregroundColor(.gray).lineLimit(1)
        }
        .padding(.horizontal, 10).padding(.vertical, 10)
    }
}

// Row with flag image
struct CountryRow: View {
    let value: String?
    let user: User?
    
    var body: some View {
        HStack(spacing: 12) {
            Circle().fill(Color.white).frame(width: 30, height: 30)
                .overlay(Image(systemName: "globe")
                    .font(.system(size: 12))
                    .foregroundColor(Color("CardColor")))
            
            Text("Country").font(.system(size: 13)).foregroundColor(.black.opacity(0.8))
            
            Spacer()
            
            if let raw = user?.country, let c = Country(rawValue: raw) {
                Image(c.flagImageName)
                    .resizable()
                    .frame(width: 22, height: 22)
                    .clipShape(Circle())
            }
            Text(value ?? "—").font(.system(size: 13)).foregroundColor(.gray)
        }
        .padding(.horizontal, 10).padding(.vertical, 10)
    }
}

// Simple divider
struct SimpleDivider: View {
    var body: some View { Divider().opacity(0.06).padding(.horizontal, 10) }
}

// Shape for top corners
struct CustomCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
