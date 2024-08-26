//
//  ContentView.swift
//  CockpitTraining
//
//  Created by Umar Patel on 8/18/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    // This variable sets the current experience (4 total)
    @Binding var currentExperienceID: Int
    
    // This is for experience 1.
    
    
        
    var body: some View {
        NavigationStack {
            VStack {
                Text("Cockpit Training Simulator")
                    .font(.system(size: 40))
                
                Model3D(named: "PlaneModel", bundle: realityKitContentBundle)
                    .padding(.bottom, 50)
                
                Text("Welcome to the cockpit training simulator for flight controls!")
                Text("Designed and Developed by Umar Patel")
                
                
                NavigationLink(destination: CockpitMenuView(currentExperienceID: $currentExperienceID)) {
                    Label("Experience Options", systemImage: "ellipsis.circle")
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                
                
                // You could eventually remove this
//                Button(action: {
//                    print("Opening up window to bring up choices")
//                    
//                }) {
//                    HStack {
//                        Text("Enter Cockpit")
//                            .font(.system(size: 20))
//                            .padding()
//                        Image(systemName: "airplane")
//                            .font(.largeTitle)
//                            .foregroundStyle(.black)
//                            .padding()
//                    }
//                }
//                .padding()
                
            }
            .padding()
        }
        .navigationTitle("Cockpit Training Simulator")
    }
}
