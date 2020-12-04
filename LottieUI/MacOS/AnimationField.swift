//
//  AnimationField.swift
//  LottieUI
//
//  Created by Viktor Radulov on 10/24/19.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import Cocoa
import Lottie

class AnimationField: NSTextField, AnimationContent {
    @IBInspectable private(set) var keyPath: String?
    @IBInspectable var ignoreLayerStyle: Bool = false
    private var handler: ButtonHandler?
    
    required init(keyPath: String?) {
        self.keyPath = keyPath
        super.init(frame: .zero)
        appearance = NSAppearance(named: .vibrantDark)
        #if DEBUG
        isBordered = true
        #else
        stringValue = ""
        isBordered = false
        #endif
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        appearance = NSAppearance(named: .vibrantDark)
        #if DEBUG
        isBordered = true
        #else
        stringValue = ""
        isBordered = false
        #endif
    }
    
    func layerAnimationRemoved(layer: CALayer) {}
    
    override var isHidden: Bool {
        didSet {
            if oldValue && !isHidden && previousKeyView as? AnimationField == nil {
                window?.makeFirstResponder(self)
            }
        }
    }
    
    func layerUpdated(layer: CALayer) {
        if let contentLayer = (layer.sublayers?.first { $0 is CATextLayer }) as? CATextLayer {
            if let text = contentLayer.string as? NSAttributedString, text.length > 0 {
                update(from: text)
            } else {
                update(from: contentLayer)
            }
            
            if contentLayer.frame.width > 0 && contentLayer.frame.height > 0 {
                alphaValue = CGFloat(contentLayer.opacity)
                frame = NSRect(origin: layer.frame.origin + contentLayer.frame.origin, size: contentLayer.frame.size)
            }
        } else {
            alphaValue = CGFloat(layer.opacity)
            frame = layer.frame
        }
        isHidden = layer.isHidden || CGFloat(layer.opacity) < 0.1
    }
    
    func update(from string: NSAttributedString) {
        guard !ignoreLayerStyle else { return }
        
        let attributes = string.attributes(at: 0, effectiveRange: nil)
        if let textColor = attributes[.foregroundColor] as? NSColor {
            self.textColor = textColor
        }
        if let font = attributes[.font] as? NSFont {
            self.font = font
        }
        if let backgroundColor = attributes[.backgroundColor] as? NSColor {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = .clear
        }
    }
    
    func update(from contentLayer: CATextLayer) {
        guard !ignoreLayerStyle else { return }
        
        if let textColor = contentLayer.foregroundColor {
            self.textColor = NSColor(cgColor: textColor)
        }
        if let font = contentLayer.font as? NSFont {
            self.font = font
        } else if let font = contentLayer.font as? String {
            self.font = NSFont(name: font, size: contentLayer.fontSize)
        }
        if let backgroundColor = contentLayer.backgroundColor {
            self.backgroundColor = NSColor(cgColor: backgroundColor)
        } else {
            self.backgroundColor = .clear
        }
    }
    
    override func resetCursorRects() {
        //Updating cursor cause "flushing" of animation and decrease performance. See LUMD-2268.
        guard let animationView = superview as? AnimationView, !animationView.isAnimationPlaying else { return }
        super.resetCursorRects()
    }
}
