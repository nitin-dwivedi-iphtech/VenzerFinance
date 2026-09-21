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
            
            // Global background gradient
            LinearGradient(
                colors: [
                    Color.clear,
                    Color("BackgroundColor").opacity(0.5),
                    Color("BackgroundColor").opacity(0.15),
                    Color("BackgroundColor").opacity(0.6)
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            
            // Global watermark "V" shapes
            GeometryReader { proxy in
                ZStack {
                    Text("v")
                        .font(.system(size: proxy.size.width * 1.8, weight: .bold))
                        .foregroundColor(Color.black.opacity(0.025))
                        .rotationEffect(.degrees(-261))
                        .offset(
                            x: proxy.size.width * 0.85,
                            y: -proxy.size.height * 0.3
                        )
                    
                    Text("v")
                        .font(.system(size: proxy.size.width * 1.8, weight: .bold))
                        .foregroundColor(Color.black.opacity(0.025))
                        .rotationEffect(.degrees(-27))
                        .offset(
                            x: -proxy.size.width * 0.5,
                            y: -proxy.size.height * 0.7
                        )
                }
                .allowsHitTesting(false)
                
                Group {
                    if appState.isLoggedIn {
                        subView()
                    } else {
                        AuthView()
                    }
                }
            }
            
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
                .padding(.bottom, 10)
        }
    }
}

//#Preview {
//    ContentView()
//}
