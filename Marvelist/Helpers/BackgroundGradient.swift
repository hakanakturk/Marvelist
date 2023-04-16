//
//  BackgroundGradient.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 15.04.2023.
//


import SwiftUI

struct BackgroundGradient: View {
    @Environment(\.colorScheme) var colorScheme
    
    let light = LinearGradient(colors: [.red, .orange, .blue], startPoint: .topTrailing, endPoint: .bottomLeading)
    
    let dark = LinearGradient(colors: [.red, .black, .blue], startPoint: .topTrailing, endPoint: .bottomLeading)
    
    @ViewBuilder var body: some View {
        if colorScheme == .light {
            light
        } else {
            dark
        }
    }
}
