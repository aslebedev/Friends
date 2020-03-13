//
//  UserView.swift
//  Friends
//
//  Created by alexander on 23.11.2019.
//  Copyright © 2019 alexander. All rights reserved.
//

import SwiftUI

struct UserView: View {
    
    @State var users = [User]()
    @State var user: User!
    
    var body: some View {
            List {
                Section(header: Text("email:")) {
                    Text("\(user.email)")
                }
                
                Section(header: Text("Active:")) {
                    Text(user.isActive ? "Yes" : "No")
                }
                
                Section(header: Text("Registered:")) {
                    Text("\(user.registered)")
                }
                
                Section(header: Text("Age:")) {
                    Text("\(user.age)")
                }
                
                Section(header: Text("Address:")) {
                    Text("\(user.address)")
                }
                
                Section(header: Text("Company:")) {
                    Text("\(user.company)")
                }
                
                Section(header: Text("tags:")) {
                    Text("\(user.tags.joined(separator: ", "))")
                }
                
                Section(header: Text("About:")) {
                    Text("\(user.about)")
                }
                
                Section (header: Text("Friends:")) {
                    ForEach(user.friends.sorted(by: { $0.name < $1.name })) { friend in
                        if self.userValid(id: friend.id) {
                            NavigationLink(destination: UserView(users: self.users, user: self.getUser(id: friend.id))) {
                                Text(friend.name)
                            }
                        }
                    }

                }
            }
            .navigationBarTitle(user.name)
    }
    
    func userValid(id: UUID) -> Bool {
        if users.first(where: { $0.id == id }) != nil {
            return true
        }
        
        return false
    }
    
    func getUser(id: UUID) -> User {
        return users.first(where: { $0.id == id }) ?? user
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
