# BottomSheet for iOS
iOS 13+
Simple BottomSheet for iOS using UIKit custom transition.
Automatically calculates the bottom sheet height depending on the content size.
Easy to use:
```swift
 let vc = ExampleViewController()
 let delegate = BottomSheetTransitioningDelegate(configuration: .default)
 vc.modalPresentationStyle = .custom
 vc.transitioningDelegate = delegate // don't forget to retain the delegate (transitioningDelegate is weak)
 present(vc, animated: true)
```

### Swift Package Manager (SPM)

Add the following to your Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/vitalybatrakov/BottomSheet.git", branch: "main")
]
```

### It doesn’t support yet:

- Content scrolling if presented view controller's content height bigger that screen height;
- Using navigation (navigation controller) inside the bottom sheet.

![BottomSheet gif](bottom_sheet.gif)
