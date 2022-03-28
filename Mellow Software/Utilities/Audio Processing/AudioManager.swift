//
//  AudioManager.swift
//  Mellow Software
//
//  Created by Abdul Waheed on 28/03/2022.
//

import Foundation
import AVFoundation

let kSoundsDirectoryName = "app_sounds"

class AudioManager {
    
    let sourceFile: AVAudioFile
    let format: AVAudioFormat
    var outputVolume = 0.5
    let fileName: String
    let fileFormat: String
    var engine: AVAudioEngine?
    var player: AVAudioPlayerNode?
    var reverb: AVAudioUnitReverb?
    var outputFile: AVAudioFile?
    
    init(fileName: String, volume: Double) {
        do {
            let parts = fileName.components(separatedBy: ".")
            self.fileName = parts[0]
            self.fileFormat = parts[1]
            let sourceFileURL = Bundle.main.url(forResource: parts[0], withExtension: parts[1])!
            sourceFile = try AVAudioFile(forReading: sourceFileURL)
            format = sourceFile.processingFormat
            outputVolume = volume
        } catch {
            fatalError("Unable to load the source audio file: \(error.localizedDescription).")
        }
    }
    
    func prepareToRender(){
        configureEngine()
        prepareDestinations()
    }
    
    func configureEngine(){
        engine = AVAudioEngine()
        player = AVAudioPlayerNode()
        reverb = AVAudioUnitReverb()
        
        guard let engine = engine, let player = player, let reverb  = reverb else { return  }
        engine.stop()
        engine.reset()
        engine.attach(player)
        engine.attach(reverb)

        // Set the desired reverb parameters.
        reverb.loadFactoryPreset(.mediumHall)
        reverb.wetDryMix = 50

        // Connect the nodes.
        engine.attach(player)
        engine.attach(reverb)
        player.volume = Float(outputVolume)
        engine.connect(player, to: reverb, format: format)
        engine.connect(reverb, to: engine.mainMixerNode, format: format)
        // Schedule the source file.
        player.scheduleFile(sourceFile, at: nil)
    }
    
    func prepareDestinations(){
        guard let engine = engine, let player = player else {
            return
        }
        do {
            // The maximum number of frames the engine renders in any single render call.
            let maxFrames: AVAudioFrameCount = 4096
            try engine.enableManualRenderingMode(.offline, format: format,
                                                 maximumFrameCount: maxFrames)
            try engine.start()
            player.play()
            
            let buffer = AVAudioPCMBuffer(pcmFormat: engine.manualRenderingFormat,
                                          frameCapacity: engine.manualRenderingMaximumFrameCount)!
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
   
            let soundsPath = documentsURL.appendingPathComponent(kSoundsDirectoryName)
            
            if !directoryExistsAt(path: soundsPath.absoluteString) {
                try? FileManager.default.createDirectory(at: soundsPath, withIntermediateDirectories: true, attributes: nil)
            }
            let outputURL = soundsPath.appendingPathComponent("\(fileName).\(fileFormat)")
            
            
            print("File will be saved: \(outputURL.absoluteString)")
            outputFile = try AVAudioFile(forWriting: outputURL, settings: sourceFile.fileFormat.settings)
            
            while engine.manualRenderingSampleTime < sourceFile.length {
                let frameCount = sourceFile.length - engine.manualRenderingSampleTime
                let framesToRender = min(AVAudioFrameCount(frameCount), buffer.frameCapacity)
                
                let status = try engine.renderOffline(framesToRender, to: buffer)
                
                switch status {
                    
                case .success:
                    // The data rendered successfully. Write it to the output file.
                    try outputFile?.write(from: buffer)
                case .insufficientDataFromInputNode:
                    // Applicable only when using the input node as one of the sources.
                    break
                    
                case .cannotDoInCurrentContext:
                    // The engine couldn't render in the current render call.
                    // Retry in the next iteration.
                    break
                    
                case .error:
                    // An error occurred while rendering the audio.
                    fatalError("The manual rendering failed.")
                @unknown default:
                    fatalError("The manual rendering failed.")
                }
            }
            
            player.stop()
            engine.stop()

            print("AVAudioEngine offline rendering finished.")

            //NSWorkspace.shared.activateFileViewerSelecting([outputFile!.url])
            outputFile = nil
        } catch {
            print(#function , " \(error).")
        }
        
    }
    
    func directoryExistsAt(path: String) -> Bool {
        let fileManager = FileManager.default
        var isdirectory : ObjCBool = true
        if fileManager.fileExists(atPath: path, isDirectory:&isdirectory) {
            if isdirectory.boolValue {
                // file exists and is a directory
                return true
            } else {
                // file exists and is not a directory
                return false
            }
        } else {
            // file does not exist
            return false
        }
    }
    
    class func performCleanupOfOldFiles(){
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let soundsPath = documentsURL.appendingPathComponent(kSoundsDirectoryName)
        
        try? FileManager.default.removeItem(at: soundsPath)
        print(soundsPath)
    }
}
