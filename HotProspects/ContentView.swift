//
//  ContentView.swift
//  HotProspects
//
//  Created by Neto Lobo on 05/12/23.
//

import SwiftUI

struct ContentView: View {
    @State var prospects = Prospects()
    
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
        .environment(prospects)
    }
}

#Preview {
    ContentView()
        
}
