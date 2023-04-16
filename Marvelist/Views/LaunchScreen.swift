//
//  LaunchScreen.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 14.04.2023.
//

import SwiftUI

struct LaunchScreen: View {
    
    @State private var isActive = false
        
    var body: some View {
        ZStack {
            if self.isActive {
                ContentView()
            } else {
                BackgroundGradient()
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("Marvelist")
                        .font(.custom("Courgette-Regular", size: 45.0))
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                    Spacer()
                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
