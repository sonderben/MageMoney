//
//  MageMoneyApp.swift
//  MageMoney
//
//  Created by Benderson Phanor on 25/3/22.
//

import SwiftUI

//@available(iOS 14.0, *)
//https://flaviocopes.com/swiftui-list/
//https://iharishsuthar.github.io/posts/swift-date/
@main
struct MageMoneyApp: App {
    let persistenceController = PersistenceControler.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    //@available(iOS 14.0, *)
    var body: some Scene {
       
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,persistenceController.container.viewContext)
        }.onChange(of: scenePhase, perform: { (newScenePhane) in
            switch newScenePhane{
            case .background:
                print("background")
            case .inactive:
                print("inactive")
            case .active:
                //let urls=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                //print(urls[urls.count-1] as URL)
                /*print("ÿhjyttykjuku")
                print(Locale.current.languageCode)
                print(Locale.current.currencyCode)
                print(Locale.current.currencySymbol)*/
                print("active")
            @unknown default:
                print("unkwnow")
            }
        })
    }
}
