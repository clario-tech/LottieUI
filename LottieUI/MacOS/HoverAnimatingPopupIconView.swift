//
//  AnimationHoverPopupIcon.swift
//  LottieUI
//
//  Created by Volodimir Moskaliuk on 10/27/19.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import AppKit
import Lottie

class HoverAnimatingPopupIconView: NSView {
    
    @IBInspectable private(set) var keyPath: String?
    @IBInspectable private(set) var animationName: String?
    @IBInspectable private(set) var rewindAfterStop: Bool = false
    
    @objc dynamic var hovered: Bool = false
    private var trackingArea: NSTrackingArea?
    private var animationView: AnimationView?
    
    convenience init(keyPath: String?, animationName: String?) {
        self.init(frame: .zero)
        self.keyPath = keyPath
        self.animationName = animationName
    }
    
    override func viewDidMoveToWindow() {
        guard let animationName = animationName else {
            return
        }
        if animationView == nil {
            animationView = AnimationView(name: animationName)
        }
        guard let animationView = animationView else {
            return
        }
        animationView.frame = bounds
        animationView.loopMode = .loop
        addSubview(animationView)
    }
    
    override func mouseEntered(with event: NSEvent) {
        animationView?.play()
        hovered = true
    }
    
    override func mouseExited(with event: NSEvent) {
        animationView?.stop()
        if rewindAfterStop {
            animationView?.play(toFrame: 0)
        }
        hovered = false
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let trackingArea = trackingArea {
            removeTrackingArea(trackingArea)
        }
        
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        trackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        guard let trackingArea = trackingArea else {
            return
        }
        addTrackingArea(trackingArea)
    }
}

extension HoverAnimatingPopupIconView: AnimationContent {
    func layerAnimationRemoved(layer: CALayer) {
        isHidden = true
        frame = .zero
        alphaValue = 0
    }
    
    func layerUpdated(layer: CALayer) {
        if layer.frame.width > 0 && layer.frame.height > 0 && !layer.isHidden {
            updateTrackingAreas()
        }
        isHidden = layer.isHidden
        alphaValue = CGFloat(layer.opacity)
        frame = layer.frame
    }
}
