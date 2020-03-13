//
//  ContentView.swift
//  Friends
//
//  Created by alexander on 23.11.2019.
//  Copyright © 2019 alexander. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var users = [User]()
   
    //  Showing alert States
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertDismissButton: Alert.Button?
    
    var body: some View {
        NavigationView {
            List(users) { user in
                NavigationLink(destination: UserView(users: self.users, user: user)) {
                    VStack (alignment: .leading) {
                        Text("\(user.name)")
                        Text("\(user.email)")
                            .font(.caption)
                    }
                }
            }
            .onAppear(perform: getData)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: alertDismissButton)
            }
            .navigationBarTitle("User List")
        }
    }
    
    func getData() {
/*
        // Тоже рабочий вариант, но работает в основном треде
        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            
            do {
                users = try decoder.decode([User].self, from: data)
                print(users)
            } catch {
                print(error.localizedDescription)
            }
        }
*/
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                self.showAlert(title: "No internet connection", message: "Try again later", dismissButton: .default(Text("OK")))
                return
            }
            
            if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                self.users = decoded.sorted(by: { $0.name < $1.name })
            } else {
                self.showAlert(title: "Invalid response from server", message: "Try again later", dismissButton: .default(Text("OK")))
            }
        }.resume()
    }
    
    func showAlert(title: String, message: String, dismissButton: Alert.Button? = nil) {
        self.alertTitle = title
        self.alertMessage = message
        self.alertDismissButton = dismissButton
        self.showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
