//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Neto Lobo on 05/12/23.
//
import CodeScanner
import UserNotifications
import SwiftUI

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortOrder {
        case name, recent
    }
    
    @Environment(Prospects.self) var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var isShowingConfirmationDialog = false
    @State private var order = SortOrder.recent
    
    let filter: FilterType
    
    
    var body: some View {
        NavigationStack {
            List(filteredProspects) { prospect in
                HStack {
                    Image(systemName: prospect.isContacted ?
                          "person.crop.circle.fill.badge.checkmark" : "person.crop.circle.badge.xmark")
                    
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddres)
                            .foregroundStyle(.secondary)
                    }
                }
                .swipeActions {
                    if prospect.isContacted {
                        Button {
                            prospects.toggle(prospect)
                        } label: {
                            Label("Mar Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                        }
                        .tint(.blue)
                    } else {
                        Button {
                            prospects.toggle(prospect)
                        } label: {
                            Label("Mar Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                        }
                        .tint(.green)
                        
                        Button {
                            addNotification(for: prospect)
                        } label: {
                            Label("Remind Me", systemImage: "bell")
                        }
                        .tint(.orange)
                    }
                }
            }
            .navigationTitle(title)
            .onAppear { loadProspects() }
            .onChange(of: prospects.people){ loadProspects() }
            .toolbar{
                ToolbarItem {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
                
                ToolbarItem {
                    Button {
                        isShowingConfirmationDialog = true
                    } label: {
                        Label("Sort", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Desilio Neto\ndesilio@gmail.com", completion: handleScan)
            }
            .confirmationDialog("Change the order:", isPresented: $isShowingConfirmationDialog) {
                Button("Name") {
                    filteredProspects = filteredProspects.sorted { $0.name < $1.name }
                }
                
                Button("Most recent") {
                    filteredProspects = filteredProspects.sorted { $0.timestamp.timeIntervalSince1970 > $1.timestamp.timeIntervalSince1970 }
                }
                
                Button("Cancel", role: .cancel) {}
            }
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
    
    @State var filteredProspects = [Prospect]()
    
    
    func loadProspects() {
        switch filter {
        case .none:
            filteredProspects = prospects.people
        case .contacted:
            filteredProspects = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            filteredProspects = prospects.people.filter { !$0.isContacted}
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
            prospects.addProspect(person)
        case .failure(let error):
            print("Scanning failed \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddres
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh!")
                    }
                }
            }
        }
        
    }
}

#Preview {
    ProspectsView(filter: .none)
        .environment(Prospects())
}
