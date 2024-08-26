//
//  VoiceActivatedSystemCheckView.swift
//  CockpitTraining
//
//  Created by Umar Patel on 8/26/24.
//

import SwiftUI
import Speech

let voiceCommandActions: [String] = [""]

struct VoiceActivatedSystemCheckView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    @Binding var currentFeaturesToFlash: [String]
    @Binding var beginFlashing: Bool
    
    // Speech recognition local properties
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var request = SFSpeechAudioBufferRecognitionRequest()
    
    @State var currTranscription: SFTranscription = SFTranscription()
    
    @State var task : SFSpeechRecognitionTask!
    // This acts as a switch
    @State var isStart: Bool = false
    
    // Flag for when speech is cancelled
    @State var hasCancelledSpeechRec: Bool = false
    
    // To display while user is speaking command
    @State var commandSoFar: String = ""
    
    // To use to check which component to highlight in immersive view
    @State var finalCommand: String = ""
    
    @State var voiceCommandButtonText: String = "Begin Speaking"
    
    var body: some View {
        VStack {
            Text("Voice-Activation System Check")
                .font(.largeTitle)
                .frame(alignment: .center)
                .bold()
                .padding()
            
            // List the options for voice commands.
            ScrollView {
                VStack (alignment: .leading, spacing: 20) {
                    ForEach(CockpitComponentCommandMap, id: \.0) { component, commands in
                        VStack(alignment: .leading) {
                            Text(component)
                                .font(.system(size: 28))
                                .bold()
                                .padding(.bottom, 5)
                            
                            ForEach(commands, id: \.self) { command in
                                Text(command)
                                    .font(.system(size: 22))
                                    .padding()
                                
                            }
                        }
                        .padding(.horizontal)
                        Divider()
                        
                    }
                }
                .padding(.top)
                
            }
            .navigationTitle("Sample Cockpit Commands")
            
            Button(action: {
                // Start or Stop Speech recognition
                if !isStart {
                    isStart = true
                    voiceCommandButtonText = "Stop"
                    startSpeechRecognization()
                }
                else {
                    finalCommand = commandSoFar.lowercased()
                    print(finalCommand)
                    let componentToFlash = findComponent(for: finalCommand)
                    if componentToFlash != nil {
                        // This is where you initiate the component blinking
                        // Set the list of elements to flash
                        print("London")
                        currentFeaturesToFlash = getCorrespondingComponents(for: componentToFlash!)
                        // Set bool to begin flashing elements in immersive view
                        beginFlashing = true
                    }
                    // Maybe here you call a function to check the entity or something.
                    cancelSpeechRecognization()
                    isStart = false
                    voiceCommandButtonText = "Begin Speaking"
                    commandSoFar = ""
                }
                
            }) {
                HStack {
                    Text(voiceCommandButtonText)
                        .font(.system(size: 24))
                        .padding()
                    Image(systemName: "mic")
                        .font(.system(size: 24))
                        .padding()
                }
            }
            // Place command text here, as it is updating
            
            Text(commandSoFar)
                .font(.system(size: 24))
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
    
    // SFSpeechRecognizer functions
    
    func startSpeechRecognization() {
        request.taskHint = .dictation
        speechRecognizer?.defaultTaskHint = .dictation
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try! audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let node = audioEngine.inputNode
        
        
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        try! audioEngine.start()
        
        
        do {
            try audioEngine.start()
        } catch let error {
            print("Error comes here for starting the audio listener = \(error.localizedDescription)")
        }
        
        guard let myRecognization = SFSpeechRecognizer() else {
            print("Recognization is not allowed on your local")
            return
        }
        
        if !myRecognization.isAvailable {
            print("Recognization is not free right now. Please try again after some time.")
        }
        
        task = speechRecognizer?.recognitionTask(with: request, resultHandler: { (response, error) in
            
            guard let response = response else {
                if error != nil {
                    print(error.debugDescription)
                } else {
                    print("Problem in giving the response")
                }
                return
            }
            
            let message = response.bestTranscription.formattedString
            currTranscription = response.bestTranscription
            
            commandSoFar = message
        })
    }
    
    // To cancel speech request
    func cancelSpeechRecognization() {
        task.finish()
        task.cancel()
        
        task = nil
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
    }
    
    // To compare commands
    
    func findComponent(for command: String) -> String? {
        for (component, commands) in CockpitComponentCommandMap {
            if commands.contains(command) {
                return component
            }
        }
        return nil
    }
    
    func getCorrespondingComponents(for component: String) -> [String] {
        var features: [String] = []
        for currentFeatureComponents in CockpitComponentNameMap {
            if currentFeatureComponents.0 == component  {
                features = currentFeatureComponents.1
            }
        }
        return features
    }
}
