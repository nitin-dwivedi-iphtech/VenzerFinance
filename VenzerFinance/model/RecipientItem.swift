//
//  RecipientItem.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//
import SwiftUI

struct RecipientItem: Identifiable, Hashable {
    let id: String
    let name: String
    let detail: String
    let initials: String
    let tint: Color

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: RecipientItem, rhs: RecipientItem) -> Bool {
        lhs.id == rhs.id
    }
}
