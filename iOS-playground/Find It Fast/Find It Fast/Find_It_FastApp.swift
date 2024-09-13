//
//  Find_It_FastApp.swift
//  Find It Fast
//
//  Created by Nasir Ahmed Momin on 11/09/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct Find_It_FastApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let plist = Configuration.config
        let options = FirebaseOptions(googleAppID: plist.firebaseAppId, gcmSenderID: plist.firebaseGcmSenderId)
        options.apiKey = plist.firebaseApiKey
        options.projectID = plist.firebaseProjectId
        
        FirebaseApp.configure(options: options)
        
        return true
    }
}
