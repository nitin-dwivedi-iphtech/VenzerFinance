//
//  PersonalDetailsViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//
import Foundation
import Combine
import CoreData

class PersonalDetailsViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var dateOfBirth: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var residentialAddress: String = ""

    init() {
        loadUser()
    }

    private func loadUser() {
        if let user = AppState.shared.user {
            fullName = user.name ?? ""
            phone = user.phone ?? ""
            email = user.email ?? ""
            if fullName.isEmpty { fullName = "Maya Thompson" }
            if dateOfBirth.isEmpty { dateOfBirth = "18 Jun 1992" }
            if phone.isEmpty { phone = "+44 7700 900 184" }
            if email.isEmpty { email = "maya.thompson@example.com" }
            if residentialAddress.isEmpty { residentialAddress = "24 Willow Lane, Bristol BS1 4DA" }
        } else {
            fullName = "Maya Thompson"
            dateOfBirth = "18 Jun 1992"
            phone = "+44 7700 900 184"
            email = "maya.thompson@example.com"
            residentialAddress = "24 Willow Lane, Bristol BS1 4DA"
        }
    }

    func savePersonalDetails() {
        guard let user = AppState.shared.user else { return }
        DbService.shared.updatePersonalDetails(
            for: user,
            fullName: fullName,
            email: email,
            phone: phone
        )
    }

    func isValid() -> Bool {
        Helper.isFormValid(for: [fullName, email, phone])
    }
}
