//
//  Home.swift
//  LittleLemon
//
//  Created by sakersun on 2025/8/15.
//

import SwiftUI

struct Home: View {
    let persistence = PersistenceController.shared
    var body: some View {
        TabView {
            Menu()
                .environment(
                    \.managedObjectContext,
                    persistence.container.viewContext
                )
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }.navigationBarBackButtonHidden(true)
            UserProfile().tabItem {
                Label("Profile", systemImage: "square.and.pencil")
            }.navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    Home()
}
