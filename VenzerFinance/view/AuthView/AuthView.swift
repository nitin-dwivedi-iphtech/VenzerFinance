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
    @State var isLoading:Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            if isLoading {
                ProgressView("Authenticating...")
                
                    .padding(.top, 40)
            } else {
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Image("loginImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 220)
                            .padding(.top, 20)
                        
                        Group {
                            if signUp {
                                SignUpView(signUp: $signUp, isLoading: $isLoading)
                                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                            } else {
                                LoginView(signUp: $signUp, isLoading: $isLoading)
                                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    AuthView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(AuthViewModel(context: PersistenceController.shared.container.viewContext))
}
