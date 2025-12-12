//
//  demo.swift
//  lib-image-ios
//
//  Created by Sherlock on 08/12/2025.
//

import PhotosUI
import SwiftUI

@available(iOS 17.0, *)
struct demo: View {
    @State var viewModel = ImageCustomizationViewModel()
    
    @State private var avatarItem: PhotosPickerItem?
    
    @State private var imageViewActive = false
    @State private var displayPayloadActive = false
    
    @State private var imageTransmissionPayloads: [ImageTransmissionPayload] = []

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: ImageProcessingView(viewModel: $viewModel){ image in
                        Task {
                            print("[+] Image count: \(image.count)")
                            do {
                                let dp = divideImagePayload(
                                    payload: [UInt8](Data(image).base64EncodedData()),
                                    version: 1,
                                    sessionId: 2,
                                    imageLength: UInt16(image.count),
                                    textLength: 0
                                )
                                imageViewActive.toggle()
                                if(dp != nil) {
                                    imageTransmissionPayloads = ImageTransmissionPayload.fromString(itp: dp!)
                                    displayPayloadActive.toggle()
                                }
                            } catch {
                                print(error)
                            }
                        }
                    },
                    isActive: $imageViewActive
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: PayloadDisplay(transmissionPayloads: imageTransmissionPayloads),
                    isActive: $displayPayloadActive
                ) {
                    EmptyView()
                }
                
                VStack {
                    PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
                }
                .onChange(of: avatarItem) {
                    if(avatarItem != nil) {
                        Task {
                            if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                                let renderer = ImageRenderer(content: loaded)
                                viewModel.setImage(renderer.uiImage!)
                                avatarItem = nil
                                imageViewActive = true
                            } else {
                                print("Failed")
                            }
                        }
                    }
                }
                .onAppear() {
                    imageViewActive = false
                }
            }
        }
    }
}

//#Preview {
//    if #available(iOS 17.0, *) {
//        demo()
//    } else {
//        // Fallback on earlier versions
//    }
//}

@available(iOS 17.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        demo()
    }
}
