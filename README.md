# Lib Image iOS

Add repo as dependencies into your app

```curl
https://github.com/smswithoutborders/lib_image_ios
```

Usage

```swift
...

struct ImageProcessingView_Preview: PreviewProvider {
    static var previews: some View {
        let image = UIImage(packageResource: "c_2077", ofType: "jpg")!
        
        var model = ImageCustomizationViewModel()
        model.setImage(image)
        
        return ImageProcessingView(viewModel: .constant(model)){_ in }
    }
}

```

You can further divide the image into SMS sized segments

```swift
let dp : [String] = divideImagePayload(
    payload: [UInt8](Data(image).base64EncodedData()),
    version: 1,
    sessionId: 2,
    imageLength: UInt16(image.count),
    textLength: 0
)
```
