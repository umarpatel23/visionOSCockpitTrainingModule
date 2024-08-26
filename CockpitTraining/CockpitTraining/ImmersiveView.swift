//
//  ImmersiveView.swift
//  CockpitTraining
//
//  Created by Umar Patel on 8/18/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct ImmersiveView: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State var entitiesInScene: [Entity] = []
        
    // This is the current experience
    @Binding var currentExperienceID: Int
    
    // This is for experience with id 0
    @Binding var currentFeatureName: String
    @Binding var currentFeatureDescription: String
        
    // This is for experience with id 1
    @Binding var currentFeatureSelected: String
    @Binding var hasChosenComponent: Bool
    
    // This is for experience with id 2
    @Binding var currentFeaturesToFlash: [String]
    @Binding var beginFlashing: Bool
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "CockpitControls", in: realityKitContentBundle) {
                // Maybe find all of the entities here using scene.entities or something?
                // Load Entities Here
                for feature in cockpitFeatureDescriptions {
                    entitiesInScene.append(scene.findEntity(named: feature.0)!)
                }
                content.add(scene)
            }
             
        }
        .gesture(SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded({ value in
                
                
                if currentExperienceID == 0 {
                    let currentEntityName = value.entity.name
                    
                    currentFeatureName = convertUnderscoreToSpace(currentEntityName)
                    currentFeatureDescription = cockpitFeatureDescriptions[currentEntityName]!
                    
                    print(currentFeatureName)
                    print(currentFeatureDescription)
                }
                
                
                if currentExperienceID == 1 {
                    hasChosenComponent = true
                    currentFeatureSelected = value.entity.name
                }
            })
        )
        .onChange(of: beginFlashing, initial: false, {
            if beginFlashing {
                flashFeatures()
            }
            
        })
        
    }
    
    func flashFeatures() {
        // Get entities
        let flashDuration: TimeInterval = 5.0
        let flashInterval: TimeInterval = 0.5
        let flashCount = Int(flashDuration / flashInterval)
        
        var originalMaterials: [String: [RealityKit.Material]] = [:]

        let entitiesToFlash = entitiesInScene.filter { entity in
            return currentFeaturesToFlash.contains(entity.name)
        }
        
        // Save original materials
        for entity in entitiesToFlash {
            if let modelComponent = entity.components[ModelComponent.self] {
                originalMaterials[entity.name] = modelComponent.materials
            }
        }
        
        
        // Define the flashing sequence
        var cancellable: AnyCancellable?
        var toggle = false

        cancellable = Timer.publish(every: flashInterval, on: .main, in: .common).autoconnect().sink { _ in
            toggle.toggle()
            for entity in entitiesToFlash {
                if var modelComponent = entity.components[ModelComponent.self] {
                    let newMaterial: SimpleMaterial
                    if toggle {
                        newMaterial = SimpleMaterial(color: .orange, isMetallic: false)
                    } else {
                        newMaterial = SimpleMaterial(color: .white, isMetallic: false)
                    }
                    
            
                    
//                    var newMaterial = SimpleMaterial(color: .white, isMetallic: false)
//                    if toggle {
//                        newMaterial.color = .init(tint: .orange)
//                        newMaterial.metallic = 0
//                    } else {
//                        newMaterial.color = .init(tint: .white)
//                        newMaterial.metallic = 0
//                    }
                    modelComponent.materials = [newMaterial]
                    entity.components[ModelComponent.self] = modelComponent
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + flashDuration) {
            cancellable?.cancel()
            for entity in entitiesToFlash {
                if let originalMaterial = originalMaterials[entity.name] {
                    if var modelComponent = entity.components[ModelComponent.self] {
                        modelComponent.materials = originalMaterial
                        entity.components[ModelComponent.self] = modelComponent
                    }
                }
            }
            
            beginFlashing = false
        }
    }
    
    func convertUnderscoreToSpace(_ input: String) -> String {
        return input.replacingOccurrences(of: "_", with: " ")
    }

    
}


