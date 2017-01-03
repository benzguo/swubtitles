//
//  OpenSubtitlesHash.swift
//  Swubtitles
//
//  This Swift 3 version is based on Swift 2 version by eduo:
//  https://gist.github.com/eduo/7188bb0029f3bcbf03d4
//
//  Created by Niklas Berglund on 2017-01-01.
//  Copyright © 2017 Klurig. All rights reserved.
//

import Foundation

class OpenSubtitlesHash: NSObject {
    let chunkSize: Int = 65536;
    
    struct VideoHash {
        var fileHash: String
        var fileSize: UInt64
    }
    
    func hashFor(_ path: String) -> VideoHash {
        var fileHash = VideoHash(fileHash: "", fileSize: 0)
        let fileHandler = FileHandle(forReadingAtPath: path)!
        
        let fileDataBegin: NSData = fileHandler.readData(ofLength: chunkSize) as NSData
        fileHandler.seekToEndOfFile()
        
        let fileSize: UInt64 = fileHandler.offsetInFile
        if (UInt64(chunkSize) > fileSize) {
            return fileHash
        }
        
        fileHandler.seek(toFileOffset: max(0, fileSize - UInt64(chunkSize)))
        let fileDataEnd: NSData = fileHandler.readData(ofLength: chunkSize) as NSData
        
        var hash: UInt64 = fileSize
        
        var data_bytes = UnsafeBufferPointer<UInt64>(
            start: UnsafePointer(fileDataBegin.bytes.assumingMemoryBound(to: UInt64.self)),
            count: fileDataBegin.length/MemoryLayout<UInt64>.size
        )
        hash = data_bytes.reduce(hash,&+)
        
        data_bytes = UnsafeBufferPointer<UInt64>(
            start: UnsafePointer(fileDataEnd.bytes.assumingMemoryBound(to: UInt64.self)),
            count: fileDataEnd.length/MemoryLayout<UInt64>.size
        )
        hash = data_bytes.reduce(hash,&+)
        
        fileHash.fileHash = String(format:"%qx", arguments: [hash])
        fileHash.fileSize = fileSize
        
        fileHandler.closeFile()
        return fileHash
    }
}