// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import WebP

struct ImageProcessingSliderView: View {
    @State var title: String
    @Binding var show: Bool
    @Binding var value: Double
    @Binding var text: String
    @State var execution: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                Spacer()
                Button(action: {
                    show.toggle()
                }) {
                    if(!show) {
                        Image(systemName: "arrowtriangle.down.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    else {
                        Image(systemName: "arrowtriangle.up.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
            }
            if(show) {
                Slider(
                    value: $value,
                    in: 0...100,
                    onEditingChanged:  { editing in
                        if(!editing) {
                            text = "\(Int(value))"
                            execution()
                        }
                    }
                )
                if #available(iOS 15.0, *) {
                    TextField("", text: $text)
                        .onSubmit {
                            value = Double(text) ?? value
                            if(value > 100) {
                                value = 100
                                text = "100"
                            } else if(value < 0) {
                                value = 0
                                text = "0"
                            }
                            execution()
                        }
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
    }
}

struct ImageProcessingView: View {
    @State private var compressionValue = 100.0
    @State private var compressionText = "0"
    @State private var showCompression = false

    @State private var resizeValue = 0.0
    @State private var resizeText = "0"
    @State private var showResize = false

    @State private var dimensions: String = "0x0"
    @State private var size: Int = 0
    @State private var smsCount: Int = 0
    
    @State private var displayImage: UIImage?
    @State var originalImage: UIImage

    var body: some View {
        VStack {
            VStack {
                Image(uiImage: displayImage ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                HStack {
                    Text("Res: \(dimensions) | Qua: \(compressionText) | Rez: \(resizeText)")
                        .bold()
                }.padding(.bottom, 16)
                HStack {
                    Text("~ SMS: \(smsCount) <-> Size: \(size) KB")
                        .bold()
                }
            }
            
            Divider()
            
            VStack {
                ImageProcessingSliderView(
                    title: "Compression (Quality)",
                    show: $showCompression,
                    value: $compressionValue,
                    text: $compressionText,
                ) {
                    processImage()
                }
                
                Divider()
                    .padding()

                ImageProcessingSliderView(
                    title: "Resize",
                    show: $showResize,
                    value: $resizeValue,
                    text: $resizeText,
                ) {
                    processImage()
                }
            }
            .padding()
            .onAppear {
                compressionText = "\(compressionValue)"
                resizeText = "\(resizeValue)"
            }
            Spacer()
            
            Button("Apply") {
                
            }
        }
        .onAppear {
            displayImage = originalImage
            processImage()
        }
    }
    
    func processImage() {
        Task {
            let currentImage = originalImage
            let currentQuality = Float(compressionValue)
            
            var width = currentImage.size.width - ((resizeValue/100) * currentImage.size.width)
            var height = currentImage.size.height - ((resizeValue/100) * currentImage.size.height)
            if(width == 0) { width = 1 }
            if(height == 0) { height = 1 }

            let data = try await Task.detached(priority: .userInitiated) {
                print("[+] Compressing image: \(currentQuality)")
                UIGraphicsBeginImageContext(
                    CGSizeMake(width, height))
                currentImage.draw(in: CGRectMake(0, 0, width, height))
                let newImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                let encoder = WebPEncoder()
                return try encoder.encode(
                    newImage,
                    config: .preset(
                        .picture,
                        quality: currentQuality
                    )
                )
            }.value
            displayImage = UIImage(data: data)!
            dimensions =
            "\(Int(displayImage!.size.width))x\(Int(displayImage!.size.height))"
            size = Int(Double(data.count) / 1024.0)
            smsCount = Int(Double(data.count) / 160)
        }
    }
}

#Preview {
    ImageProcessingView(
        originalImage: UIImage(packageResource: "c_2077", ofType: "jpg")!
    )
}
