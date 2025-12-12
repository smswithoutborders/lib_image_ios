//
//  imagePayload.swift
//  lib-image-ios
//
//  Created by Sherlock on 11/12/2025.
//

import Foundation

public struct ImageTransmissionPayload: Identifiable {
    var version: UInt8
    var sessionId: UInt8
    var segNumber: UInt8
    var numberSegments: UInt8?
    var imageLength: [UInt8]?
    var textLength: [UInt8]?
    
    var payload: String
    
    public let id = UUID()
    
    public static func fromString(itp: [String]) -> [ImageTransmissionPayload] {
        var payloads: [ImageTransmissionPayload] = []
        for i in 0..<itp.count {
            if let data = Data(base64Encoded: String(itp[i].prefix(12))) {
                let inPayload = itp[i].substring(from: String.Index(encodedOffset: 12))
                
                let payload = (i == 0) ?
                ImageTransmissionPayload(
                    version: data[0],
                    sessionId: data[1],
                    segNumber: data[2],
                    numberSegments: data[3],
                    imageLength: [data[4], data[5]],
                    textLength: [data[6], data[7]],
                    payload: inPayload ?? "<empty payload>"
                ):
                ImageTransmissionPayload(
                    version: data[0],
                    sessionId: data[1],
                    segNumber: data[2],
                    payload: inPayload ?? "<empty payload>"
                )
                payloads.append(payload)
            }
        }
        
        return payloads
    }
}

