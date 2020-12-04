//
//  AnimationProgressIndicator.swift
//  LottieUI
//
//  Created by Viktor Radulov on 1/19/20.
//  Copyright © 2020 Clario Tech Limited. All rights reserved.
//

import Lottie

class AutoAnimationView: AnimationView {
    @IBInspectable var startWhenAppear: Bool = false
    @objc dynamic var animating: Bool = false {
        didSet {
            if animating {
                startAnimation(nil)
            } else {
                stopAnimation(nil)
            }
        }
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if startWhenAppear {
            window != nil ? startAnimation(nil) : stopAnimation(nil)
        }
    }
    
    open func startAnimation(_ sender: Any?) {
        play()
    }

    open func stopAnimation(_ sender: Any?) {
        stop()
    }
    
    override func setNilValueForKey(_ key: String) {
        guard key != #keyPath(animating) else {
            animating = false
            return
        }
        
        super.setNilValueForKey(key)
    }
}

class AnimationProgressIndicator: AutoAnimationView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isHidden = true
    }
    
    override open func startAnimation(_ sender: Any?) {
        isHidden = false
        loopMode = .loop
        play()
    }

    override open func stopAnimation(_ sender: Any?) {
        stop()
        isHidden = true
    }
}
