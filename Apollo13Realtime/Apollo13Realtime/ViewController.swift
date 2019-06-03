//
//  ViewController.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 5/29/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVPlayer!
    
    /// The transcripts for the air-to-ground loop
    var airGroundLoop: Transcript!
    
    /// The transcript for the flight director's loop
    var flightDirectorLoop: Transcript!
    
    /// Loads the air-to-ground loop from disk
    ///
    /// - Throws: Errors propogated from the loading process
    func loadAirGroundLoopTranscripts() throws {
        let url = Bundle.main.url(forResource: "air-ground-loop", withExtension: "json")!
        airGroundLoop = try Transcript(url: url)
    }
    
    /// Loads the flight-director loop from disk
    ///
    /// - Throws: Errors propogated from the loading process
    func loadFlightDirectorLoop() throws {
        let url = Bundle.main.url(forResource: "flight-director-loop", withExtension: "json")!
        flightDirectorLoop = try Transcript(url: url)
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
        let triggerTimes = times.map { NSValue(time: CMTime(seconds: Double($0) - audioOffsetToMET, preferredTimescale: 10000000)) }
        let token = player.addBoundaryTimeObserver(forTimes: triggerTimes, queue: nil) {
            self.updateHighlighting()
        }
        observerTokens.append(token)
    }
    
    /// Adds updates at half second intervals to update the audio transport interface
    func setupMETUpdates() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let token = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: timeScale), queue: .main) { (_) in
            self.updateMETLabel()
        }
        observerTokens.append(token)
    }
    
    /// The tableview that displays the air-to-ground loop
    @IBOutlet weak var airGroundTableView: UITableView!

    /// The tableview that displays the air-to-ground loop
    @IBOutlet weak var flightDirectorTableView: UITableView!

    /// A formatter to produce a HH:MM:SS time string
    lazy var timeFormatter: DateComponentsFormatter = {
        //https://stackoverflow.com/questions/35215694/format-timer-label-to-hoursminutesseconds-in-swift/35215847
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
        formatter.allowedUnits = [ .hour, .minute, .second ] // Units to display in the formatted string
        formatter.zeroFormattingBehavior = [ .pad ] // Pad with zeroes where appropriate for the locale
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        try! loadAirGroundLoopTranscripts()
        try! loadFlightDirectorLoop()
        
        //load player
        let audioURL = Bundle.main.url(forResource: "full", withExtension: "m4a")!
        let asset = AVAsset(url: audioURL)
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
        
        setupTimingCuesFromTranscripts()
        setupMETUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateHighlighting()
    }
    
    lazy var highlightColor = UIColor(white: 0.0, alpha: 0.05)
    
    /// Highlights any rows with a given id
    ///
    /// - Parameters:
    ///   - tableView: The tableview to highlight
    ///   - id: The id of the transcript to highlight
    private func highlightRows(in tableView: UITableView, withIds ids: [Int]) {
        var matches = [(offset: Int, element: TranscriptEntry)]()
        if tableView === airGroundTableView {
            let airGroundMatches = airGroundLoop.enumerated().filter { (offset, element) -> Bool in
                return ids.contains(element.id)
            }
            matches.append(contentsOf: airGroundMatches)
        } else {
            let flightMatches = flightDirectorLoop.enumerated().filter { (offset, element) -> Bool in
                return ids.contains(element.id)
            }
            matches.append(contentsOf: flightMatches)
        }
        
        let paths = matches.map { IndexPath(row: $0.offset, section: 0) }.sorted { (path1, path2) -> Bool in
            path1.row < path2.row
        }
        
        self.activeIndexPaths = paths
        
        for indexPath in paths {
            let row = tableView.cellForRow(at: indexPath)
            row?.backgroundColor = highlightColor
        }
        
        if tableView === airGroundTableView {
            if earliestActiveAirGroundIndexPath != paths.first {
                earliestActiveAirGroundIndexPath = paths.first
            }
        } else {
            if earliestActiveFlightIndexPath != paths.first {
                earliestActiveFlightIndexPath = paths.first
            }
        }
        
        if let path = paths.first {
            tableView.scrollToRow(at: path, at: .top, animated: true)
        }
    }
    
    /// `IndexPath`s representing the table view cells that are currently active and should be highlighted
    var activeIndexPaths: [IndexPath] = []
    
    var earliestActiveFlightIndexPath: IndexPath? {
        didSet {
            guard let path = earliestActiveFlightIndexPath else { return }
            flightDirectorTableView.scrollToRow(at: path, at: .top, animated: true)
        }
    }
    
    var earliestActiveAirGroundIndexPath: IndexPath? {
        didSet {
            guard let path = earliestActiveAirGroundIndexPath else { return }
            airGroundTableView.scrollToRow(at: path, at: .top, animated: true)
        }
    }
    
    // MARK: Time Label Updating
    /// The MET offset in seconds for the beginning of the audio
    var audioOffsetToMET: TimeInterval = 200774
    
    /// The current time for the player in terms of Mission Elapsed Time
    var playerTimeInMET: TimeInterval {
        return player.currentTime().seconds + audioOffsetToMET
    }
    
    /// The MET label itself
    @IBOutlet var missionElapsedTimeLabel: UILabel!
    
    /// Updates the Mission Elapsed Time Label based on the time of the audio player
    func updateMETLabel() {
        let missionElapsedTime = self.playerTimeInMET
        guard let missionElapsedTimeString = self.timeFormatter.string(from: missionElapsedTime) else {
            return
        }
        self.missionElapsedTimeLabel.text = missionElapsedTimeString
    }
    
    var highlightedAirGroundIDs = [Int]()
    var highlightedFlightDirectorIDs = [Int]()
    
    /// Highlights the transcript entries being actively spoken
    ///
    /// This is a brute force approach to get it working. There probably would be a better way to check to see if things that are highlighted should be unhighlighted and vice versa
    func updateHighlighting() {
        airGroundTableView.visibleCells.forEach { $0.backgroundColor = .white }
        flightDirectorTableView.visibleCells.forEach { $0.backgroundColor = .white }
        
        highlightedAirGroundIDs = airGroundLoop.activeIDs(for: self.playerTimeInMET)
        highlightedFlightDirectorIDs = flightDirectorLoop.activeIDs(for: self.playerTimeInMET)
        
        highlightRows(in: airGroundTableView, withIds: highlightedAirGroundIDs)
        highlightRows(in: flightDirectorTableView, withIds: highlightedFlightDirectorIDs)
    }
    
    // MARK: Player Controls
    @IBAction func togglePlayer(_ sender: Any) {
        guard let player = player else { return }
        
        switch player.timeControlStatus {
        case .paused:
            player.play()
        case .waitingToPlayAtSpecifiedRate:
            break
        case .playing:
            player.pause()
        @unknown default:
            fatalError("Unimplemented player case")
        }
    }
    
    @IBAction func playerAheadShortest(_ sender: Any) {
        player.seek(to: player.currentTime() + CMTime(seconds: 5, preferredTimescale: 10000000), toleranceBefore: .zero, toleranceAfter: .zero)
        updateMETLabel()
        updateHighlighting()
    }
    
    @IBAction func playerBackShortest(_ sender: Any) {
        player.seek(to: player.currentTime() + CMTime(seconds: -5, preferredTimescale: 10000000), toleranceBefore: .zero, toleranceAfter: .zero)
        updateMETLabel()
        updateHighlighting()
    }
    
    @IBAction func playerAheadShort(_ sender: Any) {
        player.seek(to: player.currentTime() + CMTime(seconds: 15, preferredTimescale: 10000000), toleranceBefore: .zero, toleranceAfter: .zero)
        updateMETLabel()
        updateHighlighting()
    }
    
    @IBAction func playerBackShort(_ sender: Any) {
        player.seek(to: player.currentTime() + CMTime(seconds: -15, preferredTimescale: 10000000), toleranceBefore: .zero, toleranceAfter: .zero)
        updateMETLabel()
        updateHighlighting()
    }
    
    @IBAction func playerAheadLong(_ sender: Any) {
        player.seek(to: player.currentTime() + CMTime(seconds: 30, preferredTimescale: 10000000), toleranceBefore: .zero, toleranceAfter: .zero)
        updateMETLabel()
        updateHighlighting()
    }
    
    @IBAction func playerBackLong(_ sender: Any) {
        player.seek(to: player.currentTime() + CMTime(seconds: -30, preferredTimescale: 10000000), toleranceBefore: .zero, toleranceAfter: .zero)
        updateMETLabel()
        updateHighlighting()
    }
}

