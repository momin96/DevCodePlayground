//
//  ContentView.swift
//  Find It Fast
//
//  Created by Nasir Ahmed Momin on 11/09/24.
//

import SwiftUI
import SwiftData

class ViewModel: ObservableObject {
    init() {
        
    }
}


struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}


struct Configuration {
    static var config: PlistConfig = {
        guard let url = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            fatalError("Couldn't find Info.plist file.")
        }
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: url)
            return try decoder.decode(PlistConfig.self, from: data)
        } catch let error {
            fatalError("Couldn't parse Config.plist data. \(error.localizedDescription)")
        }
    }()
}


struct PlistConfig: Codable {
    let firebaseApiKey: String
    let firebaseGcmSenderId: String
    let firebasePListVersion: String
    let firebaseBundleId: String
    let firebaseProjectId: String
    let firebaseStorageBucket: String
    let firebaseAppId: String
    
    enum CodingKeys: String, CodingKey {
        case firebaseApiKey = "FIRE_API_KEY"
        case firebaseGcmSenderId = "FIRE_GCM_SENDER_ID"
        case firebasePListVersion = "FIRE_PLIST_VERSION"
        case firebaseBundleId = "FIRE_BUNDLE_ID"
        case firebaseProjectId = "FIRE_PROJECT_ID"
        case firebaseStorageBucket = "FIRE_STORAGE_BUCKET"
        case firebaseAppId = "FIRE_GOOGLE_APP_ID"
    }
}

protocol Jsonable: Encodable { }

extension Jsonable {
    func toJSON() -> String? {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("jsonString \(jsonString)")
            return jsonString
        } catch {
            print("Error encoding PlistConfig to JSON: \(error)")
            return nil
        }
    }
}
