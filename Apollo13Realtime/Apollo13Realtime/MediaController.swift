//
//  AudioController.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 7/10/20.
//  Copyright © 2020 Mike Muszynski. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

extension CMTime {
    init(seconds: TimeInterval) {
        self.init(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    }
}

fileprivate extension AVPlayer {
    func zeroToleranceSeek(to time: CMTime) {
        self.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    func zeroToleranceSeekAhead(_ seconds: TimeInterval) {
        self.seek(to: self.currentTime() + CMTime(seconds: seconds), toleranceBefore: .zero, toleranceAfter: .zero)
    }
    func zeroToleranceSeekBack(_ seconds: TimeInterval) {
        self.seek(to: self.currentTime() - CMTime(seconds: seconds), toleranceBefore: .zero, toleranceAfter: .zero)
    }
}

fileprivate extension TimeInterval {
    static let audioOffsetToMET: TimeInterval = 200774
}

class MediaController: ObservableObject {
    
    init() {
        //load player
        let audioURL = Bundle.main.url(forResource: "full", withExtension: "m4a")!
        let asset = AVAsset(url: audioURL)
        let item = AVPlayerItem(asset: asset)
        audioPlayer = AVPlayer(playerItem: item)
        
        //Load events
        let decoder = JSONDecoder()
        let url = Bundle.main.url(forResource: "EventList", withExtension: "json")!
        let loadedEvents = try? decoder.decode(Array<Event>.self, from: Data(contentsOf: url))
        self.events = loadedEvents ?? []
        currentEvent = events.first

        setupKVOPublisher()
        setupTimingCuesFromTranscripts()
        setupMETUpdates()
    }
    
    @Published var audioPlayerStatus: AVPlayer.TimeControlStatus = .paused
    var audioPlayerStatusPublisher: Cancellable?
    func setupKVOPublisher() {
        audioPlayerStatusPublisher = audioPlayer.publisher(for: \.timeControlStatus, options: .prior)
            .sink(receiveValue: { (status) in
                self.audioPlayerStatus = status
            })
    }
    
    /// A formatter to produce a HH:MM:SS time string
    static var timeFormatter: DateComponentsFormatter = {
        //https://stackoverflow.com/questions/35215694/format-timer-label-to-hoursminutesseconds-in-swift/35215847
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
        formatter.allowedUnits = [ .hour, .minute, .second ] // Units to display in the formatted string
        formatter.zeroFormattingBehavior = [ .pad ] // Pad with zeroes where appropriate for the locale
        return formatter
    }()
    
    var audioPlayer: AVPlayer

    var airGroundLoop: Transcript = .airGroundLoop
    var flightDirectorLoop: Transcript = .flightDirectorLoop
    var events: [Event]
    @Published var currentEvent: Event?
    
    /// The curent MET
    @Published var missionElapsedTime: TimeInterval = .audioOffsetToMET
    
    // MARK: Time Label Updating
    /// The current time for the player in terms of Mission Elapsed Time
    var playerTimeInMET: TimeInterval {
        return audioPlayer.currentTime().seconds + .audioOffsetToMET
    }
    
    /// Apple suggests that we dispose of these when we are done with them
    var observerTokens: [Any] = []
    
    /// Adds boundaries for which the AVPlayer will update the visual cues
    func setupTimingCuesFromTranscripts() {
        //Create a set and add all the start times from both transcripts
        //Then add the end times
        var times = Set<Int>()
        times.formUnion(airGroundLoop.compactMap( { $0.start }))
        times.formUnion(flightDirectorLoop.compactMap( { $0.start }))
        times.formUnion(airGroundLoop.compactMap( { $0.usefulEnd }))
        times.formUnion(flightDirectorLoop.compactMap( { $0.usefulEnd }))
        
        //Convert all these times to CMTime wrapped in NSValue
        let triggerTimes = times.map { NSValue(time: CMTime(seconds: Double($0) - .audioOffsetToMET, preferredTimescale: 10000000)) }
        let token = audioPlayer.addBoundaryTimeObserver(forTimes: triggerTimes, queue: nil) {
            //self.updateHighlighting()
        }
        observerTokens.append(token)
    }
    
    /// Adds updates at half second intervals to update the audio transport interface
    func setupMETUpdates() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let token = audioPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: timeScale), queue: .main) { (_) in
            //Set MET
            self.missionElapsedTime = self.playerTimeInMET
            
            //Find events
            if let currentEvent = self.events.filter({ (event) -> Bool in
                event.metBegin < self.playerTimeInMET
            }).last {
                self.currentEvent = currentEvent
            }
        }
        observerTokens.append(token)
    }
    
    func togglePlayer() {
        
        switch self.audioPlayer.timeControlStatus {
        case .paused:
            self.audioPlayer.play()
        case .waitingToPlayAtSpecifiedRate:
            break
        case .playing:
            self.audioPlayer.pause()
        @unknown default:
            fatalError()
        }
        
    }
    
    func zeroToleranceSeekAhead(_ seconds: TimeInterval) {
        audioPlayer.zeroToleranceSeekAhead(seconds)
    }
    
    func zeroToleranceSeekBack(_ seconds: TimeInterval) {
        audioPlayer.zeroToleranceSeekBack(seconds)
    }
}
