//
//  DraggableAnimation.swift
//  
//
//  Created by Mike Enriquez on 3/23/21.
//

import SwiftUI

public class DraggableAnimation: ObservableObject {
    var positiveDragDirection: PositiveDragDirection
    var containerWidth: CGFloat
    var layoutDirection: LayoutDirection
    @Published private(set) public var percentage: CGFloat = 0
    private var dragGestureValue: DragGesture.Value?
    private var dragStartingPercentage: CGFloat?
    
    init(positiveDragDirection: PositiveDragDirection = .leadingToTrailing,
         containerWidth: CGFloat = UIScreen.main.bounds.width,
         layoutDirection: LayoutDirection = .leftToRight) {
        self.positiveDragDirection = positiveDragDirection
        self.containerWidth = containerWidth
        self.layoutDirection = layoutDirection
    }
    
    public func dragGesture(positiveDirection: PositiveDragDirection = .leadingToTrailing) -> some Gesture {
        self.positiveDragDirection = positiveDirection
        return DragGesture().onChanged(self.updateDrag()).onEnded(self.animateTowardsDragDirection())
    }
    
    public func anchor() {
        self.percentage = 0.001 // advance the percentage a bit to force removed views to be inserted. gives the animation a starting place.
        withAnimation {
            self.percentage = 1
        }
    }
    
    public func reset() {
        withAnimation {
            self.percentage = 0
        }
    }
    
    private func updateDrag() -> (DragGesture.Value) -> Void {
        return { [weak self] gesture in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dragGestureValue = gesture
            
            if strongSelf.dragStartingPercentage == nil {
                strongSelf.dragStartingPercentage = strongSelf.percentage
            }
            
            let shouldIncrease =
                (strongSelf.positiveDragDirection == .leadingToTrailing && strongSelf.layoutDirection == .leftToRight) ||
                (strongSelf.positiveDragDirection == .trailingToLeading && strongSelf.layoutDirection == .rightToLeft)
            let delta = shouldIncrease ? (gesture.translation.width / strongSelf.containerWidth) : (gesture.translation.width / strongSelf.containerWidth) * -1
            let unboundPercentage = delta + strongSelf.dragStartingPercentage!
            strongSelf.percentage = min(max(0, unboundPercentage), 1)
        }
    }
    
    private func animateTowardsDragDirection() -> (DragGesture.Value) -> Void {
        return { [weak self] gesture in
            guard let strongSelf = self else {
                return
            }

            let isActive = strongSelf.percentage > 0
            let movingRight = strongSelf.dragGestureValue!.location.x <= gesture.predictedEndLocation.x
            let movingLeft = !movingRight
            let rightIsPositive = (strongSelf.positiveDragDirection == .leadingToTrailing && strongSelf.layoutDirection == .leftToRight) ||
                (strongSelf.positiveDragDirection == .trailingToLeading && strongSelf.layoutDirection == .rightToLeft)
            let leftIsPositive = !rightIsPositive
            
            if isActive {
                withAnimation {
                    if (movingRight && rightIsPositive) || (movingLeft && leftIsPositive) {
                        strongSelf.percentage = 1
                    } else {
                        strongSelf.percentage = 0
                    }
                }
            }
            
            strongSelf.dragStartingPercentage = nil
        }
    }
}
