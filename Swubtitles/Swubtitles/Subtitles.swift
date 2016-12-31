//
//  Subtitles.swift
//  Swubtitles
//
//  Created by Niklas Berglund on 2016-12-30.
//  Copyright © 2016 Klurig. All rights reserved.
//

import UIKit
import Foundation

public class Subtitles: NSObject {
    var titles: [Title]?
    
    public init(fileUrl: URL) {
        super.init()
        
        do {
            let fileContent = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8)
            titles = self.parseSRTSub(fileContent)
        }
        catch {
            debugPrint(error)
        }
    }
    
    func parseSRTSub(_ rawSub: String) -> [Title] {
        var allTitles = [Title]()
        let components = rawSub.components(separatedBy: "\r\n\r\n")
        
        for component in components {
            if component.isEmpty {
                continue
            }
            
            debugPrint(component)
            let scanner = Scanner(string: component)
            
            var indexResult: Int = -99
            var startResult: NSString?
            var endResult: NSString?
            var textResult: NSString?
            
            while scanner.isAtEnd == false {
                scanner.scanInt(&indexResult)
                scanner.scanUpToCharacters(from: CharacterSet.whitespaces, into: &startResult)
                
                scanner.scanUpTo("--> ", into: nil)
                scanner.scanLocation += 4
                scanner.scanUpToCharacters(from: CharacterSet.newlines, into: &endResult)
                
                scanner.scanUpToCharacters(from: CharacterSet.newlines, into: &textResult)
            }
            
            let textLines = textResult?.components(separatedBy: CharacterSet.newlines)
            let startTimeInterval: TimeInterval = timeIntervalFromString(startResult! as String)
            let endTimeInterval: TimeInterval = timeIntervalFromString(endResult! as String)
            
            
            let title = Title(withTexts: textLines!, start: startTimeInterval, end: endTimeInterval, index: indexResult)
            allTitles.append(title)
        }
        
        return allTitles
    }
    
    // TODO: Throw
    func timeIntervalFromString(_ timeString: String) -> TimeInterval {
        let scanner = Scanner(string: timeString)
        
        var hoursResult: Int = 0
        var minutesResult: Int = 0
        var secondsResult: NSString?
        var millisecondsResult: NSString?
        
        // Extract time components from string
        debugPrint(scanner.scanLocation)
        scanner.scanInt(&hoursResult)
        scanner.scanLocation += 1
        scanner.scanInt(&minutesResult)
        scanner.scanLocation += 1
        scanner.scanUpTo(",", into: &secondsResult)
        scanner.scanLocation += 1
        scanner.scanUpToCharacters(from: CharacterSet.newlines, into: &millisecondsResult)
        
        let secondsString = secondsResult! as String
        let seconds = Int(secondsString)
        
        let millisecondsString = millisecondsResult! as String
        let milliseconds = Int(millisecondsString)
        
        let timeInterval: Double = Double(hoursResult) * Double(3600) + Double(minutesResult) * Double(60) + Double(seconds!) + Double(Double(milliseconds!)/Double(1000))
        
        return timeInterval as TimeInterval
    }
}