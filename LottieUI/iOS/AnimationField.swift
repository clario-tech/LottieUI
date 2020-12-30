//
//  AnimationField.swift
//  LottieUI
//
//  Created by Viktor Radulov on 10/24/19.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import UIKit
import Lottie

class AnimationField: UITextField, AnimationContent {
    @IBInspectable private(set) var keyPath: String?
    @IBInspectable var ignoreLayerStyle: Bool = false
    private var handler: ButtonHandler?
    
    required init(keyPath: String?) {
        self.keyPath = keyPath
        super.init(frame: .zero)
        
        #if DEBUG
        borderStyle = .line
        #else
        stringValue = ""
        borderStyle = .none
        #endif
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        #if DEBUG
        borderStyle = .line
        #else
        stringValue = ""
        borderStyle = .none
        #endif
    }
    
    func layerAnimationRemoved(layer: CALayer) {}
    
    func layerUpdated(layer: CALayer) {
        if let contentLayer = (layer.sublayers?.first { $0 is CATextLayer }) as? CATextLayer {
            if let text = contentLayer.string as? NSAttributedString, text.length > 0 {
                update(from: text)
            } else {
                update(from: contentLayer)
            }
            
            if contentLayer.frame.width > 0 && contentLayer.frame.height > 0 {
                alpha = CGFloat(contentLayer.opacity)
                frame = CGRect(origin: layer.frame.origin + contentLayer.frame.origin, size: contentLayer.frame.size)
            }
        } else {
            alpha = CGFloat(layer.opacity)
            frame = layer.frame
        }
        isHidden = layer.isHidden || CGFloat(layer.opacity) < 0.1
    }
    
    func update(from string: NSAttributedString) {
        guard !ignoreLayerStyle else { return }
        
        let attributes = string.attributes(at: 0, effectiveRange: nil)
        if let textColor = attributes[.foregroundColor] as? UIColor {
            self.textColor = textColor
        }
        if let font = attributes[.font] as? UIFont {
            self.font = font
        }
        if let backgroundColor = attributes[.backgroundColor] as? UIColor {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = .clear
        }
    }
    
    func update(from contentLayer: CATextLayer) {
        guard !ignoreLayerStyle else { return }
        
        if let textColor = contentLayer.foregroundColor {
            self.textColor = UIColor(cgColor: textColor)
        }
        if let font = contentLayer.font as? UIFont {
            self.font = font
        } else if let font = contentLayer.font as? String {
            self.font = UIFont(name: font, size: contentLayer.fontSize)
        }
        if let backgroundColor = contentLayer.backgroundColor {
            self.backgroundColor = UIColor(cgColor: backgroundColor)
        } else {
            self.backgroundColor = .clear
        }
    }
}
