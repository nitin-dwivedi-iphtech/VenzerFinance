//
//  Helper.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//

import Foundation

enum Helper {
    static func isFormValid(for fields: [String]) -> Bool {
        fields.allSatisfy { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
}
