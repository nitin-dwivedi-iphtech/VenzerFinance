//
//  SettingViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 22/09/26.
//

import Combine

class SettingViewModel:ObservableObject {
    @Published var account:Account?
    
    init() {
        fetchAccount()
    }
    
    private func fetchAccount() {
        self.account = DbService.shared.fetchAccount(for: AppState.shared.user)
    }
}
