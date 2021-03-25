# SlidingView

SlidingView is a SwiftUI view container that makes it easy to hide/show supplementary views. Animations are customizable and can be "percent" driven by drag gestures. Used for creating a "Side Menu", "Slide Out", "Navigation Drawer", "Hamburger Menu/Drawer/Sidebar", etc...

## How it works

The basic idea of `SlidingView` is that it is a view container that provides you with `DraggableAnimation` instances and a `GeometryProxy`.

```swift
SlidingView { draggableAnimation, geometry in
    draggableAnimation.percentage    // A CGFloat value from 0 to 1.
    draggableAnimation.dragGesture() // A DragGesture that updates the percentage value while the user is dragging.
    draggableAnimation.anchor()      // Animates the percentage to 1.
    draggableAnimation.reset()       // Animates the percentage to 0.
    geometry // A GeometryProxy. The same you would get from a GeometryReader.
}
```

### Percentage

Use the `percentage` value in your view modifiers.  For example, this view will fade in as the percentage incases to 1:

```swift
  .opacity(Double(draggableAnimation.percentage))
```

This view will slide in from the left as the percentage increases to 1:

```swift
  // when the percentage is 0, the view is offset one container width to the left.
  // when the percentage is 1, the view is offset to zero.
  .offset(x: -geometry.size.width + (geometry.size.width * draggableAnimation.percentage))
```

The percentage can be used with any animatable view modifier, including custom view modifiers that conform to `AnimatableModifier`.

### Drag Gesture

The `dragGesture()` function returns a `DragGesture` that is configured to update the `percentage`.  Pass it to a `gesture` view modifier to enable dragging on that view.

```swift
  .gesture(draggableANimation.dragGesture())
```

### Programmatic Animation

The `percentage` value can be animated by calling `anchor()` or `reset()` on the `draggableAnimation`.  The `draggableAnimation` is available by any view in the `SlidingView` heiarchy through an `@EnvironmentObject`.

```swift
struct AnchorButton: View {
    @EnvironmentObject var draggableAnimation: DraggableAnimation

    var body: some View {
        Button(action: {
            draggableAnimation.anchor()
        }) {
            Image(systemName: "list.bullet")
        }
    }
}
```

## Examples

Below are some examples of what is possible with `SlidingView`.  The code for these examples can be found in the [SlidingViewExamples repo](https://github.com/enriquez/SlidingViewExamples).

### Twitter Example

A simple side menu.

![SwiftUI Containers - Twitter](https://user-images.githubusercontent.com/61213/112880578-9ab64f80-9098-11eb-96c5-aedaae4060e4.png)


### Instagram Example

Uses two `DraggableAnimation` instances.  One for the share view that appears under the left side and one for the messages view that appears on the right.  This example shows how you can combine the gestures to make it easy to switch between each animation in a single gesture.

![SwiftUI Containers - Instagram Share](https://user-images.githubusercontent.com/61213/112880655-b6b9f100-9098-11eb-843b-8d928a8b6fc3.png)

![SwiftUI Containers - Instagram Messages](https://user-images.githubusercontent.com/61213/112880671-bb7ea500-9098-11eb-9555-8f0ee123f9db.png)

### Lock Screen Example

Uses two `DraggableAnimation` instances.  Features a custom `AnimatableModifier` for the camera's transition.

![SwiftUI Containers - Lock Screen Widgets](https://user-images.githubusercontent.com/61213/112880725-cd604800-9098-11eb-896b-7d7a0fd347a3.png)

![SwiftUI Containers - Lock Screen Camera](https://user-images.githubusercontent.com/61213/112880846-fbde2300-9098-11eb-81d5-43956f855c83.png)

## Requirements

 iOS 14

## Installation

SlidingView is available as a Swift Package.

In Xcode, select File -> Swift Packages -> Add Package Dependency...  Use this url for the package: https://github.com/enriquez/SlidingView.git

## MIT License

Copyright 2021 Mike Enriquez

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
