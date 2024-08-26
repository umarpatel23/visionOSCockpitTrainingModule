//
//  PreAndPostFlightChecklist.swift
//  CockpitTraining
//
//  Created by Umar Patel on 8/25/24.
//

import SwiftUI

struct PreAndPostFlightChecklist: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    @State private var currFeatureIndex: Int = 0
    let numFeatures = CockpitFeatureHints.count
    
    @State private var hintText: String = ""
    @State private var revealText: String = ""
    
    // This is the entity that the user just tapped in the Immersive view
    @Binding var currentFeatureSelected: String
    @Binding var hasChosenComponent: Bool
    
    var body: some View {
        VStack {
            Text("Find the corresponding component in the cockpit")
                .font(.system(size: 24))
                .frame(alignment: .center)
                .bold()
                .padding()
            
            Text("\(hintText)")
                .font(.title)
                .frame(alignment: .center)
                .bold()
                .padding()
            
            // Show if it's correct or not Correct or not
            if hasChosenComponent {
                // See if the name of the entity is the same as the name of the feature
                if isChoiceCorrect() {
                    Text("Correct")
                        .font(.title)
                        .frame(alignment: .center)
                        .bold()
                        .padding()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    hasChosenComponent = false
                                    // Now move on to the next one
                                    currFeatureIndex = getRandomIndex(upperBound: numFeatures, excluding: currFeatureIndex)!
                                    hintText = CockpitFeatureHints[currFeatureIndex].1
                                    
                                }
                            }
                        }

                }
                else {
                    Text("Incorrect. Try Again")
                        .font(.title)
                        .frame(alignment: .center)
                        .bold()
                        .padding()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    hasChosenComponent = false
                                }
                            }
                        }
                }
            }
            
            
            Button(action: {
                revealText = CockpitFeatureHints[currFeatureIndex].0
                
                // Maybe show the answer for 5 seconds and then move on to the next component
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        revealText = ""
                        currFeatureIndex = getRandomIndex(upperBound: numFeatures, excluding: currFeatureIndex)!
                        hintText = CockpitFeatureHints[currFeatureIndex].1
                    }
                }
                
            }) {
                HStack {
                    Image(systemName: "eye")
                        .font(.title)
                        .padding()
                    Text("Show Answer")
                        .font(.system(size: 18))
                        .padding()
                }
            }
            
            Text("\(revealText)")
                .font(.title)
                .frame(alignment: .center)
                .bold()
                .padding()
            
            Button(action: {
                dismissWindow()
            }) {
                Text("Close")
            }
        }
        .onAppear {
            dismissWindow(id: "Main")
            currFeatureIndex = getRandomIndex(upperBound: numFeatures, excluding: currFeatureIndex)!
            hintText = CockpitFeatureHints[currFeatureIndex].1
        }
        .onDisappear {
            openWindow(id: "Main")
            Task {
                await dismissImmersiveSpace()
            }
        }
    }
    
    // Create a function that generates a random index
    
    private func getRandomIndex(upperBound: Int, excluding x: Int) -> Int? {
        guard upperBound > 1 else { return 0 }
        
        var randomIndex = Int.random(in: 0..<upperBound)
        while randomIndex == x {
            randomIndex = Int.random(in: 0..<upperBound)
        }
        return randomIndex
    }
    
    // Checks to see if the current feature selected corresponds to the currentFeature being selected
    private func isChoiceCorrect() -> Bool {
        let componentNames = CockpitComponentNameMap[currFeatureIndex].1
        for componentName in componentNames {
            if componentName == currentFeatureSelected {
                return true
            }
        }
        return false
    }
    
    
}
