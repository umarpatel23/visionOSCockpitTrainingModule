//
//  IdentificationAndSequenceTrainingView.swift
//  CockpitTraining
//
//  Created by Umar Patel on 8/26/24.
//

import SwiftUI

struct IdentificationAndSequenceTrainingView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    var body: some View {
        VStack {
            Text("This experience is still under development. Please click close and choose one of the other cockpit simulation experiences")
                .padding()
            
            Button(action: {
                dismissWindow()
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

#Preview {
    IdentificationAndSequenceTrainingView()
}
