//
//  HypnoApp.swift
//  HypnoApp
//
//  Created by Yalcin Emilli on 28.12.20.
//


import SwiftUI


@main
struct HypnoApp: App {
    
//    @StateObject private var meinekurse = MyKurse()
    @StateObject private var kurse = FetchJson()

    @StateObject private var storeManager = StoreManager ()
    
    var body: some Scene {
        WindowGroup {
          
            StartView().environmentObject(kurse).environmentObject(storeManager)
            }
}
}
