//
//  CockpitTrainingApp.swift
//  CockpitTraining
//
//  Created by Umar Patel on 8/18/24.
//

import SwiftUI

@main
struct CockpitTrainingApp: App {
    @State var currentExperienceID: Int = 0     // This will be 0, 1, 2, or 3 depending on which experience is selected. It will be set and managed in the Menu View
    
    // These are the @State variables for the first experience: CockpitFeatureInfoView (ID: 0)
    @State var currentFeatureName: String = ""
    @State var currentFeatureDescription: String = "Tap a component to get started"
    
    // These are the @State variables for the second experience: PreAndPostFlightChecklist (ID: 1)
    @State var currentFeatureSelected: String = ""
    @State var hasChosenComponent: Bool = false
    
    // These are the @State variables for the third experience
    @State var currentFeaturesToFlash: [String] = []
    @State var beginFlashing: Bool = false
    
    var body: some Scene {
        
        
        WindowGroup (id: "Main"){
            ContentView(currentExperienceID: $currentExperienceID)
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(currentExperienceID: $currentExperienceID, currentFeatureName: $currentFeatureName, currentFeatureDescription: $currentFeatureDescription, currentFeatureSelected: $currentFeatureSelected, hasChosenComponent: $hasChosenComponent, currentFeaturesToFlash: $currentFeaturesToFlash, beginFlashing: $beginFlashing)
        }
        
        // This is for id: 0
        WindowGroup(id: "CockpitFeatureInfoDisplay") {
            CockpitFeatureInfoView(currentFeatureName: $currentFeatureName, currentFeatureDescription: $currentFeatureDescription)
        }
        .defaultSize(width: 500, height: 650)
        
        
        // This is for id: 1
        WindowGroup(id: "PreAndPostFlightChecklist") {
            PreAndPostFlightChecklist(currentFeatureSelected: $currentFeatureSelected, hasChosenComponent: $hasChosenComponent)
        }
        .defaultSize(width: 500, height: 650)
        
        
        WindowGroup(id: "VoiceActivatedSystemCheck") {
            VoiceActivatedSystemCheckView(currentFeaturesToFlash: $currentFeaturesToFlash, beginFlashing: $beginFlashing)
        }
        .defaultSize(width: 500, height: 650)
        
        WindowGroup(id: "IdentificationAndSequenceTraining") {
            IdentificationAndSequenceTrainingView()
        }
        .defaultSize(width: 500, height: 650)
        
        
    }
}
