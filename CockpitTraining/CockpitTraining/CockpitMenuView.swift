//
//  CockpitMenuView.swift
//  CockpitTraining
//
//  Created by Umar Patel on 8/24/24.
//

import SwiftUI

struct CockpitMenuView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    // This is for the current experience (out of 4 total, indexed 0, 1, 2, and 3
    @Binding var currentExperienceID: Int
    
    // Checks to see whether an immersive space is open or not (can only have 1 open at a time)
    @State var isImmersiveSpaceOpen: Bool = false
    
    var body: some View {
        VStack {
            Text("Cockpit Menu")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                print("Go to All-Purpose Cockpit Features Info Experience")
                // open immersive space and corresponding window
                if !isImmersiveSpaceOpen {
                    isImmersiveSpaceOpen = true
                    Task {
                        await openImmersiveSpace(id: "ImmersiveSpace")
                        currentExperienceID = 0
                        openWindow(id: "CockpitFeatureInfoDisplay")     // Make sure you close the main content view on appear
                    }
                }
            }) {
                HStack {
                    Image(systemName: "info.square")
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                        .padding()
                    
                    Text("Getting Acquainted with the Cockpit")
                        .font(.system(size: 20))
                        .padding()
                }
            }
            .padding()
            
            Button(action: {
                print("Go to pre-flight checklist simmulation")
                if !isImmersiveSpaceOpen {
                    isImmersiveSpaceOpen = true
                    Task {
                        await openImmersiveSpace(id: "ImmersiveSpace")
                        currentExperienceID = 1
                        openWindow(id: "PreAndPostFlightChecklist")     // Make sure you close the main content view on appear
                    }
                }
            }) {
                HStack {
                    Image(systemName: "checkmark.rectangle")
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                        .padding()
                    
                    Text("Pre-Flight Checklist Simulation")
                        .font(.system(size: 20))
                        .padding()
                }
            }
            .padding()
            
            Button(action: {
                print("Go to Voice-Activated System Check")
                if !isImmersiveSpaceOpen {
                    isImmersiveSpaceOpen = true
                    Task {
                        await openImmersiveSpace(id: "ImmersiveSpace")
                        currentExperienceID = 2
                        openWindow(id: "VoiceActivatedSystemCheck")
                    }
                }
            }) {
                Image(systemName: "speaker.wave.2")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
                    .padding()
                Text("Voice Activation System Check")
                    .font(.system(size: 20))
                    .padding()
            }
            .padding()
            
            Button(action: {
                print("Open Idenitification and Sequence Training")
                if !isImmersiveSpaceOpen {
                    isImmersiveSpaceOpen = true
                    Task {
                        await openImmersiveSpace(id: "ImmersiveSpace")
                        currentExperienceID = 3
                        openWindow(id: "IdentificationAndSequenceTraining")
                    }
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
                    .padding()
                Text("Open Identification and Sequence Training")
                    .font(.system(size: 20))
                    .padding()
            }
            
        }
    }
}
