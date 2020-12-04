//
//  AnimationButton.swift
//  LottieUI
//
//  Created by Illia Herasymov on 24.10.2019.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import Cocoa
import Lottie

typealias ButtonHandler = (NSButton) -> Void
class AnimationButton: NSButton {
    
    @IBInspectable private(set) var keyPath: String?
    @IBInspectable private(set) var startMarker: String?
    @IBInspectable private(set) var endMarker: String?
    @IBInspectable private(set) var ignoreOpacityUpdates: Bool = false
    @IBInspectable private(set) var drawButton: Bool = false
    
    enum KeyEquivalent: String {
        case escape = "\u{1b}"
        case `return` = "\r"
    }
    
    var key: KeyEquivalent? {
        get {
            AnimationButton.KeyEquivalent(rawValue: keyEquivalent)
        }
        set {
            keyEquivalent = newValue?.rawValue ?? ""
        }
    }
    
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
        target = self
        action = #selector(doAction(_:))
    }
    
    @objc private
    func doAction(_ sender: Any) {
        handler?(self)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        #if DEBUG
        if isEnabled {
            NSColor.red.setStroke()
        } else {
            NSColor.yellow.setStroke()
        }
        NSBezierPath(rect: dirtyRect).stroke()
        #endif
        
        if drawButton
            && !isHidden // workaround for 10.12 https://jira.clario.co/browse/LUMD-3054
        {
            super.draw(dirtyRect)
        }
    }
    
    override func sendAction(_ action: Selector?, to target: Any?) -> Bool {
        guard let startMarker = startMarker,
            let animationView = superview as? AnimationView else {
            return super.sendAction(action, to: target)
        }
        
        isEnabled = false
        animationView.play(toMarker: startMarker)
        animationView.currentProgress = animationView.progressTime(forMarker: startMarker) ?? 0
        if let endMarker = endMarker {
            animationView.play(toMarker: endMarker) { _ in
                _ = super.sendAction(action, to: target)
                self.isEnabled = true
            }
            return true
        } else {
            animationView.play { _ in
                self.isEnabled = true
            }
            return super.sendAction(action, to: target)
        }
    }
}

@objc
extension AnimationButton: AnimationContent {
    func layerAnimationRemoved(layer: CALayer) {}
    
    func layerUpdated(layer: CALayer) {
        if let contentLayer = (layer.sublayers?.first { $0 is CATextLayer }) as? CATextLayer {
            if contentLayer.frame.width > 0 && contentLayer.frame.height > 0 {
                isHidden = contentLayer.isHidden
                if !ignoreOpacityUpdates {
                    alphaValue = CGFloat(contentLayer.opacity)
                }
                let position = layer.frame.origin + contentLayer.frame.origin
                frame = NSRect(origin: position, size: contentLayer.frame.size)
            }
        } else {
            isHidden = layer.isHidden
            if !ignoreOpacityUpdates {
                alphaValue = CGFloat(layer.opacity)
            }
            if let animationView = superview as? AnimationView,
               let keyPath = keyPath,
               let superlayer = self.layer?.superlayer,
               let convertedFrame = animationView.convert(layer.frame, fromLayerAt: AnimationKeypath(keypath: keyPath), to: superlayer) {
                frame = convertedFrame
            } else {
                frame = layer.frame
            }
        }
        isHidden = layer.isHidden
    }
}
