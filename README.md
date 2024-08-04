# ValifyFaceScanML

![](https://img.shields.io/cocoapods/l/ValifyFaceScanML)
![](https://img.shields.io/badge/Swift-5.0-orange)
![](https://img.shields.io/badge/Platform-iOS-blue)
![](https://img.shields.io/badge/pod-v1.0.0-red)


`ValifyFaceScanML` is a Swift framework designed to provide advanced face scanning and recognition capabilities using machine learning. With `ValifyFaceScanML`, developers can easily integrate face detection and recognition features into their iOS applications.

## Features

- **Face Detection**: Accurate detection of faces within images or video frames.
- **Face Recognition**: Identify and recognize faces based on pre-trained models.
- **Real-Time Processing**: Efficient and responsive face scanning in real-time.
- **Customizable**: Easy to configure and integrate into your existing projects.

## Requirements

- iOS 13.0 or later
- Swift 5.0 or later

## Installation

### Using CocoaPods

Add the following to your `Podfile`:

```ruby
pod 'ValifyFaceScanML'
```

Then run:

```bash
pod install
```

## Usage

1. **Import the Framework**

   ```swift
   import ValifyFaceScanML
   ```

2. **Initialize the Face Scanner**

   ```swift
   let faceScanner = ValifyFaceScan()
   ```

3. **Perform Face Detection**

   ```swift
     let picker = ValifyFaceScan()
        picker.didFinishPicking { [unowned picker] photo, _ in
            self.userImage.image = photo
            picker.dismiss(animated: true, completion: nil)
            print("Done")
        }
        present(picker, animated: true, completion: nil)
   ```

## License

`ValifyFaceScanML` is released under the MIT License. See the [LICENSE](LICENSE) file for details.

## Issues 

if you face this issue Error Sandbox: rsync.samba(4761) deny(1) file-write-create 
just search on ENABLE_USER_SCRIPT_SANDBOXING  in Build settings and set its Value NO

![](https://i.sstatic.net/vqk8D.png)

## Contact

For any questions or feedback, please reach out to  msaaad202020@gmail.com
