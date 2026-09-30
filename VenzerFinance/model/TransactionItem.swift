//
//  TransactionItem.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//
import Foundation

struct TransactionItem: Identifiable {
    let id: String
    let title: String
    let detail: String
    let icon: String
    let amount: String
    let isCredit: Bool

    init(id: String = UUID().uuidString, title: String, detail: String, icon: String, amount: String, isCredit: Bool) {
        self.id = id
        self.title = title
        self.detail = detail
        self.icon = icon
        self.amount = amount
        self.isCredit = isCredit
    }
}
