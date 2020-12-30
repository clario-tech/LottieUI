//
//  AnimationBox.swift
//  LottieUI
//
//  Created by Viktor Radulov on 11/28/20.
//  Copyright © 2020 Clario Tech Limited. All rights reserved.
//

import UIKit
import Lottie

public class AnimationBox: UIView {
    @IBInspectable private(set) public var keyPath: String?
    
    // The first frame of the shape layers
    // is misplaced and will be ignored.
    // TODO: Fix this in Lottie
    var junkFrameIgnored = false
}

@objc
extension AnimationBox: AnimationContent {
    public func layerAnimationRemoved(layer: CALayer) {}
    
    public func layerUpdated(layer: CALayer) {
        if let contentLayer = (layer.sublayers?.first { $0 is CATextLayer }) as? CATextLayer {
            if contentLayer.frame.width > 0 && contentLayer.frame.height > 0 {
                isHidden = contentLayer.isHidden
                alpha = CGFloat(contentLayer.opacity)
                let position = layer.frame.origin + contentLayer.frame.origin
                frame = CGRect(origin: position, size: contentLayer.frame.size)
            }
        } else {
            isHidden = layer.isHidden
            alpha = CGFloat(layer.opacity)
            if let animationView = superview as? AnimationView,
               let keyPath = keyPath,
               let superlayer = self.layer.superlayer,
               let convertedFrame = animationView.convert(layer.frame, fromLayerAt: AnimationKeypath(keypath: keyPath), to: superlayer) {
                if junkFrameIgnored {
                    frame = convertedFrame
                } else {
                    junkFrameIgnored = true
                }
            } else {
                frame = layer.frame
            }
        }
        isHidden = layer.isHidden
    }
}
