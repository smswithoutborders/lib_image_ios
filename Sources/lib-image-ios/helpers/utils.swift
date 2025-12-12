//
//  utils.swift
//  lib-image-ios
//
//  Created by Sherlock on 11/12/2025.
//

import Foundation
import SwiftUI

func divideImagePayload(
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
        print("[+] Meta data: \(metaData)")
        
        let size = min(encodedPayload.count, (STANDARD_SEGMENT_SIZE - STANDARD_ENCODED_HEADER_SIZE))
        print("[+] Meta size: \(size)")
        print("[+] Meta payload - prefixed: \(encodedPayload.prefix(size))")

        let prefix = String(bytes: encodedPayload.prefix(size), encoding: .utf8) ?? ""
        print("[+] Storing prefix [\(segmentNumber)]: \(prefix)")
        
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
    
    print("[==>] working with: \(dividedImage[0])")
    
    if var header = Data(base64Encoded: String(dividedImage[0].prefix(12))){
        header[3] = UInt8(dividedImage.count)
        dividedImage[0].replaceSubrange(String.Index(encodedOffset: 0)..<String.Index(encodedOffset: 12),
                                        with: header.base64EncodedString())
    } else {
        print("Failed to adjust headers")
        return nil
    }
    return dividedImage
}
