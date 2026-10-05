//
//  UserAvatarView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 30/09/26.
//

import SwiftUI

struct UserAvatarView: View {
    @Environment(\.colorScheme) private var scheme
    var user: User?
    var imageData: Data?
    var size: CGFloat

    init(user: User?, size: CGFloat) {
        self.user = user
        self.imageData = nil
        self.size = size
    }

    init(imageData: Data?, size: CGFloat) {
        self.user = nil
        self.imageData = imageData
        self.size = size
    }

    private var data: Data? {
        imageData ?? user?.image
    }

    var body: some View {
        Group {
            if let data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(accent.opacity(scheme == .dark ? 0.22 : 0.12))
                    .frame(width: size, height: size)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: size * 0.45, weight: .semibold))
                            .foregroundStyle(accent)
                    )
            }
        }
    }

    private var accent: Color {
        scheme == .dark ? Color("InsideCarBottomColor") : Color("CardColor")
    }
}
