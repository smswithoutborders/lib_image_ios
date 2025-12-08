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
    @State var viewModel = CustomizationViewModel()
    
    @State private var avatarItem: PhotosPickerItem?
    
    @State private var imageViewActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: ImageProcessingView(viewModel: $viewModel){
                        imageViewActive.toggle()
                    },
                    isActive: $imageViewActive
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

#Preview {
    if #available(iOS 17.0, *) {
        demo()
    } else {
        // Fallback on earlier versions
    }
}
