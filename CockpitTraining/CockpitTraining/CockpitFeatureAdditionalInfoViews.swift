//
//  CockpitFeatureAdditionalInfoViews.swift
//  CockpitTraining
//
//  Created by Umar Patel on 8/20/24.
//

import Foundation
import SwiftUI

struct CockpitFeatureInfoView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    @Binding var currentFeatureName: String
    @Binding var currentFeatureDescription: String
    
    var body: some View {
        ScrollView {
            VStack {
                Text(currentFeatureName)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(alignment: .center)
                    .bold()
                    .padding()
                Text("Description: \(currentFeatureDescription)")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .padding()
                // Include some images of this current feature in real life, along with the description
                Button(action: {
                    Task {
                        dismissWindow()
                    }
                }) {
                    Text("Close")
                }
            }
            .onAppear {
                dismissWindow(id: "Main")
            }
            .onDisappear {
                openWindow(id: "Main")
                Task {
                    await dismissImmersiveSpace()
                }
            }
        }
    }
}
