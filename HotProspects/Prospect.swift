//
//  Prospect.swift
//  HotProspects
//
//  Created by Neto Lobo on 05/12/23.
//

import SwiftUI

@Observable
class Prospect: Identifiable, Codable, Equatable {
    
    var id = UUID()
    var name = "Anonymous"
    var emailAddres = ""
    var timestamp = Date()
    fileprivate (set) var isContacted = false
    
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.emailAddres < rhs.emailAddres
    }
}

@Observable
class Prospects {
    private (set) var people: [Prospect]
//    let saveKey = "SaveData"
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SaveData")
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        people = []
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
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
