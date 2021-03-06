//
//
//sooop/StreamReader.swift
//https://gist.github.com/sooop/a2b110f8eebdf904d0664ed171bcd7a2
//
//

import Foundation

class StreamReader {
    let encoding: String.Encoding
    let chunkSize: Int
    let fileHandle: FileHandle
    var buffer: Data
    let delimPattern : Data
    var isAtEOF: Bool = false
    
    init?(url: URL, delimeter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096)
    {
        guard let fileHandle = try? FileHandle(forReadingFrom: url) else { return nil }
        self.fileHandle = fileHandle
        self.chunkSize = chunkSize
        self.encoding = encoding
        buffer = Data(capacity: chunkSize)
        delimPattern = delimeter.data(using: .utf8)!
    }
    
    deinit {
        fileHandle.closeFile()
    }
    
    func rewind() {
        fileHandle.seek(toFileOffset: 0)
        buffer.removeAll(keepingCapacity: true)
        isAtEOF = false
    }
    
    func nextLine() -> String? {
        if isAtEOF { return nil }
        repeat {
            do {
                if let range = buffer.range(of: delimPattern, options: [], in: buffer.startIndex..<buffer.endIndex) {
                    let subData = buffer.subdata(in: buffer.startIndex..<range.lowerBound)
                    let line = String(data: subData, encoding: encoding)
                    buffer.replaceSubrange(buffer.startIndex..<range.upperBound, with: [])
                    return line
                } else {
    //                let tempData = fileHandle.readData(ofLength: chunkSize)
                    let tempData = try fileHandle.read(upToCount: chunkSize)
                    if tempData == nil || tempData!.count == 0 {
                        isAtEOF = true
                        return (buffer.count > 0) ? String(data: buffer, encoding: encoding) : nil
                    } else {
                        buffer.append(tempData!)
                    }
                }
            } catch let err {
                print(err)
            }
        } while true
    }
}
