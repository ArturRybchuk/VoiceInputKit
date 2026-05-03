//
//  VoiceInputManager.swift
//  VoiceInputKit
//
//  Created by Artur Rybchuk on 5/3/26.
//

#if os(iOS)

import Foundation
import Speech
import AVFoundation

/// VoiceInputManager
/// Handles:
/// - permissions (speech + microphone)
/// - start / stop recording
/// - speech → text
/// - auto stop (5 seconds)
public final class VoiceInputManager {
    
    // MARK: - Properties
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private var stopTimer: Timer?
    
    public private(set) var isRecording = false
    
    
    // MARK: - Permissions
    
    public func requestPermissions(completion: @escaping (Bool) -> Void) {
        
        SFSpeechRecognizer.requestAuthorization { status in
            
            guard status == .authorized else {
                completion(false)
                return
            }
            
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                completion(granted)
            }
        }
    }
    
    
    // MARK: - Recording
    
    public func startRecording(onText: @escaping (String) -> Void,
                              onFinish: (() -> Void)? = nil) {
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest = request
        
        request.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) {
            buffer, _ in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine error: \(error)")
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request) {
            result, error in
            
            if let text = result?.bestTranscription.formattedString {
                onText(text)
            }
            
            if error != nil || result?.isFinal == true {
                self.stopRecording()
                onFinish?()
            }
        }
        
        isRecording = true
        
        startAutoStopTimer(onFinish: onFinish)
    }
    
    
    public func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        stopTimer?.invalidate()
        stopTimer = nil
        
        isRecording = false
    }
    
    
    public func toggleRecording(onText: @escaping (String) -> Void,
                                onFinish: (() -> Void)? = nil) {
        isRecording
        ? stopRecording()
        : startRecording(onText: onText, onFinish: onFinish)
    }
    
    
    // MARK: - Timer
    
    private func startAutoStopTimer(onFinish: (() -> Void)?) {
        stopTimer?.invalidate()
        
        stopTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            self.stopRecording()
            onFinish?()
        }
    }
}

#endif
