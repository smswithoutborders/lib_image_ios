//
//  utils.swift
//  lib-image-ios
//
//  Created by Sherlock on 11/12/2025.
//

import Foundation
import SwiftUI

/**
 Payload :=
     Header = Base64 encoded string (12)
     Body = String encoded bytes
 */
public func divideImagePayload(
    payload: [UInt8],
    version: UInt8,
    sessionId: UInt8,
    imageLength: UInt16,
    textLength: UInt16,
) -> [String]? {
    let STANDARD_SEGMENT_SIZE = 153
    let STANDARD_ENCODED_HEADER_SIZE = 12

    var encodedPayload = payload
    var dividedImage: [String] = []
    
    var segmentNumber: UInt8 = 0
    let numberOfSegments: UInt8 = 0
    
    
    repeat {
        var metaData: [UInt8] = [version, sessionId, segmentNumber]
        if(Int(segmentNumber) == 0) {
            metaData += [numberOfSegments] + withUnsafeBytes(of: imageLength.littleEndian) { Array($0) }
            + withUnsafeBytes(of: textLength.littleEndian) { Array($0) }
        }
        
        let size = min(encodedPayload.count, (STANDARD_SEGMENT_SIZE - STANDARD_ENCODED_HEADER_SIZE))

        let prefix = String(bytes: encodedPayload.prefix(size), encoding: .utf8) ?? ""
        
        // comes up empty
        let buffer = Data(metaData).base64EncodedString() + prefix
        if(buffer.count > STANDARD_SEGMENT_SIZE) {
            print("Buffer size > $STANDARD_SEGMENT_SIZE --> ${buffer.length}")
            return nil
        }
        encodedPayload = [UInt8](encodedPayload.dropFirst(size))
        segmentNumber = UInt8(Int(segmentNumber) + 1)
        dividedImage.append(buffer)
    } while(!encodedPayload.isEmpty)
    
//    if var header = Data(base64Encoded: String(dividedImage[0].prefix(12))){
//        header[3] = UInt8(dividedImage.count)
//        dividedImage[0].replaceSubrange(String.Index(encodedOffset: 0)..<String.Index(encodedOffset: 12),
//                                        with: header.base64EncodedString())
//    } else {
//        print("Failed to adjust headers")
//        return nil
//    }
    let original = dividedImage[0]

    let start = original.startIndex
    let end = original.index(start, offsetBy: 12)

    guard
        let headerData = Data(base64Encoded: String(original[start..<end])),
        headerData.count >= 4
    else {
        print("Failed to decode header")
        return nil
    }

    var mutableHeader = headerData
    mutableHeader[3] = UInt8(dividedImage.count)

    let newHeader = mutableHeader.base64EncodedString()

    guard newHeader.count == 12 else {
        fatalError("Header size invariant broken")
    }

    dividedImage[0].replaceSubrange(start..<end, with: newHeader)
    return dividedImage
}
