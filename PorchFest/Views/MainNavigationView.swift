//
//  MainNavigationView.swift
//  PorchFest
//
//  Created by Griffin Homan on 9/22/24.
//

import Foundation
import SwiftUI

struct MainNavigationView: View {
    
    var body: some View {
        TabView {
            Group {
                AroundMeView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Around Me")
                    }
                
                RecordView()
                    .tabItem {
                        Image(systemName: "play.circle")
                        Text("Record")
                    }
                
                HistoryView()
                    .tabItem {
                        Image(systemName: "clock")
                        Text("History")
                    }
                
                FavoritesView()
                    .tabItem {
                        Image(systemName: "star")
                        Text("Favorites")
                    }
            }
            .toolbarBackground(Color("primary"), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
    }
}

#Preview {
    MainNavigationView()
}

