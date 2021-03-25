//
//  SlidingView.swift
//  
//
//  Created by Mike Enriquez on 3/23/21.
//

import SwiftUI

@available(iOS 14.0, *)
public struct SlidingView<Content: View, Key: Hashable>: View {
    @Environment(\.layoutDirection) var layoutDirection
    @StateObject private var draggableAnimations: ObservableDictionary<Key, DraggableAnimation>
    private let content: ([Key:DraggableAnimation], GeometryProxy) -> Content
    
    public init(keys: [Key], @ViewBuilder content: @escaping ([Key:DraggableAnimation], GeometryProxy) -> Content) {
        self.content = content

        let dictionary = keys.reduce(into: [Key: DraggableAnimation]()) { dict, key in
            dict[key] = DraggableAnimation()
        }
        
        _draggableAnimations = StateObject(wrappedValue: ObservableDictionary(dictionary: dictionary))
    }
    
    public var body: some View {
        GeometryReader { geometry in
            self.configureDraggableAnimations(geometry: geometry, layoutDirection: self.layoutDirection)
            ZStack {
                Color.clear.edgesIgnoringSafeArea(.all)
                self.content(self.draggableAnimations.dictionary, geometry)
            }
        }
        .environmentObject(draggableAnimations)
        .environmentObject(draggableAnimations.dictionary.values.first!)
    }
    
    private func configureDraggableAnimations(geometry: GeometryProxy, layoutDirection: LayoutDirection) -> some View {
        draggableAnimations.dictionary.values.forEach({ draggableAnimation in
            draggableAnimation.containerWidth = geometry.size.width
            draggableAnimation.layoutDirection = layoutDirection
        })
        
        return AnyView(EmptyView())
    }
}

public struct SingleKey: Hashable {}

@available(iOS 14.0, *)
extension SlidingView where Key == SingleKey {
    public init(@ViewBuilder content: @escaping (DraggableAnimation, GeometryProxy) -> Content) {
        self.init(keys: [SingleKey()]) { dictionary, geometry in
            content(dictionary.values.first!, geometry)
        }
    }
}
