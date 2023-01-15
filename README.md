# iOSBottomSheet
iOS 13+
Simple and neat BottomSheet for iOS using UIKit custom transition.
Automatically calculates the bottom sheet height depending on the content size.
```java
bottomSheet.showWithSheetView(LayoutInflater.from(context).inflate(R.layout.my_sheet_layout, bottomSheet, false));
```

It doesn’t support yet:
========
-Content scrolling if presented view controller's content height bigger that screen height;
-Using navigation (navigation controller) inside the bottom sheet.

![BottomSheet gif](bottom_sheet.gif)