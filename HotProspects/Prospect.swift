//
//  Prospect.swift
//  HotProspects
//
//  Created by Neto Lobo on 05/12/23.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddres = ""
    var isContacted = false
}

@Observable
class Prospects {
    var people: [Prospect]
    
    init() {
        people = []
    }
}
