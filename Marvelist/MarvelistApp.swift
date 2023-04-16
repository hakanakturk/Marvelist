//
//  MarvelistApp.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 13.04.2023.
//

import SwiftUI

@main
struct MarvelistApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .environmentObject(CharacterListViewModel())
        }
    }
}
