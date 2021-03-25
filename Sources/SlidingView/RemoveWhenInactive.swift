//
//  SwiftUIView.swift
//  
//
//  Created by Mike Enriquez on 3/25/21.
//

import SwiftUI

public struct RemoveWhenInactive: AnimatableModifier {
    var percentage: CGFloat

    public var animatableData: CGFloat {
        get { percentage }
        set { percentage = newValue }
    }

    public func body(content: Content) -> some View {
        if animatableData == 0 {
            return AnyView(EmptyView())
        } else {
            return AnyView(content)
        }
    }
}
