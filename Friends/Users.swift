//
//  Users.swift
//  Friends
//
//  Created by alexander on 23.11.2019.
//  Copyright © 2020 alexander. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class Users: ObservableObject {
    
    @Published var items = [User]()
    @Published var alertItem: AlertItem?
    
    private let usersCacheEntityName = "UsersCache"
    private let moc: NSManagedObjectContext
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    init() {
        print("LoadData...")
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            moc = managedObjectContext
        } else {
            fatalError("Unable to read managed object context.")
        }
        
        getData()
    }
    
    func reloadData() {
        items = [User]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: usersCacheEntityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try moc.execute(batchDeleteRequest)
            try moc.save()
        } catch {
            assertionFailure("Error when fetching delete or after this saving data in Core: \(error.localizedDescription)")
        }
        
        getData()
    }
    
    func getData() {
        let requestUser = NSFetchRequest<NSFetchRequestResult>(entityName: usersCacheEntityName)

        guard let fetched = try? moc.fetch(requestUser) else {
            loadDataFromWeb()
            return
        }
    
        if fetched.count != 0 {
            
            guard let usersCache = fetched as? [UsersCache] else {
                assertionFailure("Error when casting fetch to [UsersCache]")
                
                loadDataFromWeb()
                return
            }
            
            if let decoded = try? JSONDecoder().decode([User].self, from: usersCache[0].storage!) {
                self.items = decoded.sorted(by: { $0.name < $1.name })
            } else {
                alertItem = AlertItem(title: Text("Invalid response from server"), message: Text("Try again later"), dismissButton: .default(Text("OK")))
            }

        } else {
            loadDataFromWeb()
        }
    }
    
    func loadDataFromWeb() {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        
        URLSession.shared.dataTask(with: url) { result in
            
            switch result {
                case .success(let response, let data):
                    
                    if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                        
                        DispatchQueue.main.async {
                            self.items = decoded.sorted(by: { $0.name < $1.name })
                        }
                        
                        let newCache = UsersCache(context: self.moc)
                        newCache.storage = data
                        do {
                            try self.moc.save()
                        } catch {
                            assertionFailure("Error saving data to Core: \(error.localizedDescription)")
                        }
                        
                    } else {
                        
                        DispatchQueue.main.async {
                            self.alertItem = AlertItem(title: Text("Invalid response from server"), message: Text("Try again later"), dismissButton: .default(Text("OK")))
                        }
                        
                    }
                    
                    break
                case .failure(let error):
                    
                    DispatchQueue.main.async {
                        self.alertItem = AlertItem(title: Text(error.localizedDescription), message: Text("Try again later"), dismissButton: .default(Text("OK")))
                    }
                    break
             }
        }.resume()
    }
}
