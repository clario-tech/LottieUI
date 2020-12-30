//
//  CompositeAnimationButton.swift
//  LottieUI
//
//  Created by Viktor Radulov on 11/2/19.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import UIKit
import Lottie

class CompositeAnimationButton: AnimationButton {
    @IBInspectable var animationName: String? {
        didSet {
            if let animationName = animationName {
                animationView = AnimationView(name: animationName)
            }
        }
    }
    
    private var animationView: AnimationView? {
        didSet {
            if let animationView = animationView {
                oldValue?.removeFromSuperview()
                addSubview(animationView)
            }
        }
    }
    
    @IBInspectable var titlePlaceholder: String?
//    override var titleLabel: UILabel?
//    override var currentTitle: String? {
//        didSet {
//            if let titlePlaceholder = titlePlaceholder, !title.isEmpty {
//                animationView?.textProvider = DictionaryTextProvider([titlePlaceholder: title])
//            }
//        }
//    }
//
//    override var state: UIControl.State {
//        didSet {
//            if let endFrame = startFrame() {
//                isEnabled = false
//                animationView?.play(fromFrame: animationView?.currentFrame, toFrame: endFrame, loopMode: .playOnce) { _ in
//                    self.isEnabled = true
//                }
//            }
//        }
//    }
    
    override func didMoveToWindow() {
        if let animationView = animationView {
            guard let startFrame = startFrame() else { return }
            animationView.currentFrame = startFrame
        }
    }
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if let animationView = animationView {
            guard let endFrame = startFrame() else {
                super.sendAction(action, to: target, for: event)
                return
            }
            isEnabled = false
            animationView.play(fromFrame: animationView.currentFrame, toFrame: endFrame, loopMode: .playOnce) { _ in
                super.sendAction(action, to: target, for: event)
                self.isEnabled = true
            }
        } else {
            super.sendAction(action, to: target, for: event)
        }
    }
    
    private func startFrame() -> CGFloat? {
        state.contains(.selected) ? animationView?.animation?.endFrame : animationView?.animation?.startFrame
    }
}
