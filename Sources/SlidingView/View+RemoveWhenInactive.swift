//
//  File.swift
//  
//
//  Created by Mike Enriquez on 3/25/21.
//

import SwiftUI

extension View {
    public func removeWhenInactive(percentage: CGFloat) -> some View {
        self.modifier(RemoveWhenInactive(percentage: percentage))
    }
}
