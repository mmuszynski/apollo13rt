//
//  ViewController+DataSource.swift
//  Apollo13Realtime
//
//  Created by Mike Muszynski on 6/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import UIKit

extension UIFont {
    static var menloBold15: UIFont {
        let descriptor = UIFontDescriptor(name: "Menlo", size: 15.0)
        return UIFont(descriptor: descriptor.withSymbolicTraits(.traitBold)!, size: 0)
    }
    static var menloRegular15: UIFont {
        let descriptor = UIFontDescriptor(name: "Menlo", size: 15.0)
        return UIFont(descriptor: descriptor, size: 0)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === airGroundTableView {
            return airGroundLoop.count
        } else {
            return flightDirectorLoop.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var entry: TranscriptEntry!
        if tableView === airGroundTableView {
            entry = airGroundLoop[indexPath.row]
        } else {
            entry = flightDirectorLoop[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TranscriptCell", for: indexPath) as! TranscriptTableViewCell
        
        if let startTime = entry.start  {
            cell.timestampLabel.text = timeFormatter.string(from: TimeInterval(startTime))
            cell.timestampLabel.alpha = 1.0
        } else {
            cell.timestampLabel.alpha = 0.0
        }
        
        cell.messageLabel.attributedText = entry.annotatedMessage
        cell.sourceLabel.text = entry.source
        
        cell.messageLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .menloRegular15)
        cell.sourceLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .menloBold15)
        
        cell.annotationStackView.arrangedSubviews.forEach {
            cell.annotationStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        entry.tokens?.enumerated().forEach({ (index, annotation) in
            let label = UILabel()
            
            let fontDescriptor = cell.messageLabel.font.fontDescriptor.withSymbolicTraits(.traitItalic)
            label.font = UIFont(descriptor: fontDescriptor!, size: 0)
            label.numberOfLines = 0
            
            label.text = "\(index+1): " + annotation
            cell.annotationStackView.addArrangedSubview(label)
        })
        entry.annotations?.forEach({ (annotation) in
            let label = UILabel()
            
            let fontDescriptor = cell.messageLabel.font.fontDescriptor.withSymbolicTraits(.traitItalic)
            label.font = UIFont(descriptor: fontDescriptor!, size: 0)
            label.numberOfLines = 0
            
            label.text = annotation
            cell.annotationStackView.addArrangedSubview(label)
        })
        
        if activeIndexPaths.contains(indexPath) {
            cell.backgroundColor = highlightColor
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
