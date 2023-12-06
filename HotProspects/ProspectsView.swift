//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Neto Lobo on 05/12/23.
//
import CodeScanner
import SwiftUI

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @Environment(Prospects.self) var prospects: Prospects
    @State private var isShowingScanner = false
    
    let filter: FilterType
    
    var body: some View {
        NavigationStack {
            List(filteredProspects) { prospect in
                VStack(alignment: .leading) {
                    Text(prospect.name)
                        .font(.headline)
                    Text(prospect.emailAddres)
                        .foregroundStyle(.secondary)
                }
            }
                .navigationTitle(title)
                .toolbar{
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
                .sheet(isPresented: $isShowingScanner, content: {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Desilio Neto\ndesilio@gmail.com", completion: handleScan)
                })
        }
        
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted}
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            let person = Prospect()
            person.name = details[0]
            person.emailAddres = details[1]
            prospects.people.append(person)
        case .failure(let error):
            print("Scanning failed \(error.localizedDescription)")
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .environment(Prospects())
}
