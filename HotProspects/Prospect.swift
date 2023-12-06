//
//  Prospect.swift
//  HotProspects
//
//  Created by Neto Lobo on 05/12/23.
//

import SwiftUI

@Observable
class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddres = ""
    fileprivate (set) var isContacted = false
}

@Observable
class Prospects {
    private (set) var people: [Prospect]
    let saveKey = "SaveData"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func addProspect(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        prospect.isContacted.toggle()
        save()
    }
}
