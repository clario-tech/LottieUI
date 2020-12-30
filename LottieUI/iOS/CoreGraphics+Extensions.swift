//
//  CoreGraphics+Extensions.swift
//  Lumis
//
//  Created by Viktor Radulov on 10/24/19.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import UIKit

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(
            x: lhs.x - rhs.x,
            y: lhs.y - rhs.y
        )
    }
    
    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
}

extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(
            width: lhs.width + rhs.width,
            height: lhs.height + rhs.height
        )
    }
    
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(
            width: lhs.width - rhs.width,
            height: lhs.height - rhs.height
        )
    }
    
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }
    
    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }
}
