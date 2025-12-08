// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

struct ImageProcessingSliderView: View {
    @State var title: String
    @Binding var show: Bool
    @Binding var value: Double
    @Binding var text: String
    
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
                        }
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
    }
}

struct ImageProcessingStatsCardView: View {
    @State var name: String
    @State var value: String

    var body: some View {
        VStack {
            Text(name)
            Text(value)
        }
        .padding()
        .background(Color.accentColor)
        .cornerRadius(8)
    }
}

struct ImageProcessingView: View {
    @State private var compressionValue = 50.0
    @State private var compressionText = "0"
    @State private var showCompression = false

    @State private var resizeValue = 50.0
    @State private var resizeText = "0"
    @State private var showResize = false

    @State private var dimensions: String = "0x0"
    @State var image: UIImage

    var body: some View {
        VStack {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
//                Spacer().frame(height: 32)
                Text(dimensions)
                    .bold()
            }
            
            Spacer().frame(height: 42)
            Divider()
            
            VStack {
                ImageProcessingSliderView(
                    title: "Compression (Quality)",
                    show: $showCompression,
                    value: $compressionValue,
                    text: $compressionText,
                )
                
                Spacer().frame(height: 42)

                ImageProcessingSliderView(
                    title: "Resize",
                    show: $showResize,
                    value: $resizeValue,
                    text: $resizeText,
                )

                Spacer()
                
                HStack {
                    ImageProcessingStatsCardView(name: "SMS", value: "0")
                    Spacer().frame(width: 32)
                    ImageProcessingStatsCardView(name: "Size", value: "0")
                }
            }
            .padding()
            .onAppear {
                compressionText = "\(compressionValue)"
                resizeText = "\(resizeValue)"
                dimensions =
                "\(Int(image.size.width))x\(Int(image.size.height))"
            }
        }
    }
}

#Preview {
    ImageProcessingView(
        image: UIImage(packageResource: "c_2077", ofType: "jpg")!
    )
}
