//
//  payloadDisplay.swift
//  lib-image-ios
//
//  Created by Sherlock on 11/12/2025.
//

import SwiftUI

struct PayloadDisplay : View {
    @State var transmissionPayloads: [ImageTransmissionPayload]
    var body: some View {
        VStack {
            List(transmissionPayloads) { payload in
                VStack(alignment: .leading) {
                    Text(String("version: \(payload.version)"))
                    Text(String("session_id: \(payload.sessionId)"))
                    Text(String("seg_numner: \(payload.segNumber)"))
//                    if(payload.imageLength != nil) {
//                        Text(String("image_len: \(Int(String(bytes: payload.imageLength ?? [], encoding: .utf8)!))"))
//                        Text(String("text_len: \(Int(String(bytes: payload.textLength ?? [], encoding: .utf8)!))"))
//                    }
                    Text(String("payload: \(payload.payload)"))
                }
            }
        }
    }
}


#Preview {
    @State var transmissionPayloads: [ImageTransmissionPayload] = [
        ImageTransmissionPayload(
            version: 0,
            sessionId: 0,
            segNumber: 1,
            imageLength: [100],
            textLength: [100],
            payload: "Hello world"
        ),
        ImageTransmissionPayload(
            version: 0,
            sessionId: 0,
            segNumber: 2,
            payload: "Hello world"
        ),
    ]
    PayloadDisplay(transmissionPayloads: transmissionPayloads)
}
