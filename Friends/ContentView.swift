//
//  ContentView.swift
//  Friends
//
//  Created by alexander on 23.11.2019.
//  Copyright © 2020 alexander. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var users = Users()
    
    var body: some View {
        NavigationView {
            List(users.items) { user in
                NavigationLink(destination: UserView(users: self.users.items, user: user)) {
                    VStack (alignment: .leading) {
                        Text("\(user.name)")
                        Text("\(user.email)")
                            .font(.caption)
                    }
                }
            }
            .alert(item: $users.alertItem) { alertItem in
                    Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            .navigationBarTitle("User List")
            .navigationBarItems(
                trailing:
                    Button( action: {
                        self.users.reloadData()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
