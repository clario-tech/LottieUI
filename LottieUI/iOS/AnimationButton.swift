//
//  AnimationButton.swift
//  LottieUI
//
//  Created by Illia Herasymov on 24.10.2019.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import UIKit
import Lottie

typealias ButtonHandler = (UIButton) -> Void

@objc
public class AnimationButton: UIButton {
    
    @IBInspectable private(set) public var keyPath: String?
    @IBInspectable private(set) var startMarker: String?
    @IBInspectable private(set) var endMarker: String?
    @IBInspectable private(set) var ignoreOpacityUpdates: Bool = false
    @IBInspectable private(set) var drawButton: Bool = false
    
    private var handler: ButtonHandler?
    
    required init(keyPath: String?) {
        self.keyPath = keyPath
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(keyPath: String, handler: @escaping ButtonHandler) {
        self.init(keyPath: keyPath)
        self.handler = handler
        
        addTarget(self, action: #selector(doAction(_:)), for: .touchDown)
    }
    
    @objc private
    func doAction(_ sender: Any) {
        handler?(self)
    }
    
    public override func draw(_ rect: CGRect) {
        #if DEBUG
        if isEnabled {
            UIColor.red.setStroke()
        } else {
            UIColor.yellow.setStroke()
        }
        UIBezierPath(rect: rect).stroke()
        #endif
        
        if drawButton
            && !isHidden // workaround for 10.12 https://jira.clario.co/browse/LUMD-3054
        {
            super.draw(rect)
        }
    }
    
    public override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        guard let startMarker = startMarker,
            let animationView = superview as? AnimationView else {
            super.sendAction(action, to: target, for: event)
            return
        }
        
        isEnabled = false
        animationView.play(toMarker: startMarker)
        animationView.currentProgress = animationView.progressTime(forMarker: startMarker) ?? 0
        if let endMarker = endMarker {
            animationView.play(toMarker: endMarker) { _ in
                super.sendAction(action, to: target, for: event)
                self.isEnabled = true
            }
        } else {
            animationView.play { _ in
                self.isEnabled = true
            }
            super.sendAction(action, to: target, for: event)
        }
    }
}

@objc
extension AnimationButton: AnimationContent {
    public func layerAnimationRemoved(layer: CALayer) {}
    
    public func layerUpdated(layer: CALayer) {
        if let contentLayer = (layer.sublayers?.first { $0 is CATextLayer }) as? CATextLayer {
            if contentLayer.frame.width > 0 && contentLayer.frame.height > 0 {
                isHidden = contentLayer.isHidden
                if !ignoreOpacityUpdates {
                    alpha = CGFloat(contentLayer.opacity)
                }
                let position = layer.frame.origin + contentLayer.frame.origin
                frame = CGRect(origin: position, size: contentLayer.frame.size)
            }
        } else {
            isHidden = layer.isHidden
            if !ignoreOpacityUpdates {
                alpha = CGFloat(layer.opacity)
            }
            if let animationView = superview as? AnimationView,
               let keyPath = keyPath,
               let superlayer = self.layer.superlayer,
               let convertedFrame = animationView.convert(layer.frame, fromLayerAt: AnimationKeypath(keypath: keyPath), to: superlayer) {
                frame = convertedFrame
            } else {
                frame = layer.frame
            }
        }
        isHidden = layer.isHidden
    }
}
