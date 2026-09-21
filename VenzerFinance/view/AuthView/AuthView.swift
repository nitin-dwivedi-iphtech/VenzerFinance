//
//  AuthView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//

import SwiftUI
import CoreData

struct AuthView: View {
    @State var signUp:Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            Image("loginImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 220)
                .padding(.top, 20)
            
            Group {
                if signUp {
                    SignUpView(signUp: $signUp, authViewModel: authViewModel)
                } else {
                    LoginView(signUp: $signUp, authViewModel: authViewModel)
                }
            }
        }
        .padding(.horizontal, 24)
    }
    
}

//#Preview {
//    AuthView(context: PersistenceController.shared.container.viewContext)
//}
