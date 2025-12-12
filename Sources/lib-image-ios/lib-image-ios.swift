// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import WebP

struct ImageProcessingSliderView: View {
    @State var title: String
    @Binding var show: Bool
    @Binding var value: Double
    @Binding var text: String
    @Binding var enabled: Bool
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
                .disabled(enabled)
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

struct ImageProcessingAnimatedView: View {
    @Binding var showAnimation: Bool
    @State var animate = false
    var body: some View {
        if(showAnimation) {
            if #available(iOS 14.0, *) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

public struct ImageProcessingView: View {
    @Binding var viewModel: ImageCustomizationViewModel

    @State var showCompression: Bool = false
    @State var compressionText: String = "100.0"
    @State var resizeText: String = "100.0"
    @State var showResize: Bool = false
    
    @State var dimensions: String = "0x0"
    @State var size: Int = 0
    @State var smsCount: Int = 0
    
    @State private var animate = false
    @State private var rawBytes: [UInt8] = []
    @State var execution: ([UInt8]) -> Void
    
    public init(viewModel: Binding<ImageCustomizationViewModel>, execution: @escaping ([UInt8]) -> Void) {
        _viewModel = viewModel
        self.execution = execution
    }
    

    public var body: some View {
        VStack {
            VStack {
                Image(uiImage: viewModel.displayImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                VStack {
                    HStack {
                        Text("Res: \(dimensions) | Qua: \(compressionText) | Rez: \(resizeText)")
                            .bold()
                    }
                    Spacer().frame(height: 16)
                    HStack {
                        Text("~ SMS: \(smsCount) <-> Size: \(size) KB")
                            .bold()
                    }
                }
                .padding()
            }
            
            Divider()
                .padding()

            VStack {
                ImageProcessingSliderView(
                    title: "Compression (Quality)",
                    show: $showCompression,
                    value: $viewModel.compressionValue,
                    text: $compressionText,
                    enabled: $animate
                ) {
                    processImage()
                }
                
                Divider()
                    .padding()

                ImageProcessingSliderView(
                    title: "Resize",
                    show: $showResize,
                    value: $viewModel.resizeValue,
                    text: $resizeText,
                    enabled: $animate
                ) {
                    processImage()
                }
            }
            .padding()
            .onAppear {
                compressionText = "\(viewModel.compressionValue)"
                resizeText = "\(viewModel.resizeValue)"
            }
            
            Spacer()
            ImageProcessingAnimatedView(showAnimation: $animate)
            Spacer()
            
            Button("Apply") {
                execution(rawBytes)
            }
            .disabled(animate)
        }
        .onAppear {
            processImage()
        }
    }
    
    func processImage() {
        Task {
            animate = true
            let currentImage = viewModel.originalImage
            let currentQuality = Float(viewModel.compressionValue)
            
            var width = currentImage.size.width - ((viewModel.resizeValue/100) * currentImage.size.width)
            var height = currentImage.size.height - ((viewModel.resizeValue/100) * currentImage.size.height)
            if(width == 0) { width = 1 }
            if(height == 0) { height = 1 }

            let data = try await Task.detached(priority: .userInitiated) {
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
            viewModel.setDisplayImage(UIImage(data: data)!)
            dimensions =
            "\(Int(viewModel.displayImage.size.width))x\(Int(viewModel.displayImage.size.height))"
            size = Int(Double(data.count) / 1024.0)
            smsCount = Int(Double(data.count) / 160)
            rawBytes = [UInt8](data)
            
            animate = false
        }
    }
    
}

struct ImageProcessingView_Preview: PreviewProvider {
    static var previews: some View {
        let image = UIImage(packageResource: "c_2077", ofType: "jpg")!
        
        var model = ImageCustomizationViewModel()
        model.setImage(image)
        
        return ImageProcessingView(viewModel: .constant(model)){_ in }
    }
}

#Preview {
    @State var animate = true
    ImageProcessingAnimatedView(showAnimation: $animate)
}
