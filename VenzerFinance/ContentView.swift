//
//  ContentView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 18/09/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var appState = AppState.shared
    @StateObject private var authViewModel:AuthViewModel
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        _authViewModel = StateObject(wrappedValue: AuthViewModel(context: context))
    }
    
    var body: some View {
        ZStack {
            
            Group {
                if appState.isLoggedIn {
                    subView()
                } else {
                    AuthView()
                }
            }
        }
        .background {
            CustomBackgroundView()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .environmentObject(authViewModel)
    }
}

struct subView: View {
    @State private var currentTab: Tab = .home
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab content switcher
            Group {
                switch currentTab {
                case .home:
                    WelcomeView()
                case .balanceOverview:
                    Text("Balance Overview View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .chart:
                    Text("Chart View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .setting:
                    Text("Setting View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom bottom tab bar
            BottomNavigation(currentTab: $currentTab)
                .padding(.bottom, 3)
        }
    }
}

#Preview {
    ContentView()
}
