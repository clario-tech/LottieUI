//
//  CompositeAnimationButton.swift
//  LottieUI
//
//  Created by Viktor Radulov on 11/2/19.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import Cocoa
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
    override var title: String {
        didSet {
            if let titlePlaceholder = titlePlaceholder, !title.isEmpty {
                animationView?.textProvider = DictionaryTextProvider([titlePlaceholder: title])
            }
        }
    }
    
    override var state: NSControl.StateValue {
        didSet {
            if let endFrame = startFrame() {
                isEnabled = false
                animationView?.play(fromFrame: animationView?.currentFrame, toFrame: endFrame, loopMode: .playOnce) { _ in
                    self.isEnabled = true
                }
            }
        }
    }
    
    override func viewDidMoveToWindow() {
        if let animationView = animationView {
            guard let startFrame = startFrame() else { return }
            animationView.currentFrame = startFrame
        }
    }
    
    override func sendAction(_ action: Selector?, to target: Any?) -> Bool {
        if let animationView = animationView {
            guard let endFrame = startFrame() else {
                _ = super.sendAction(action, to: target)
                return true
            }
            isEnabled = false
            animationView.play(fromFrame: animationView.currentFrame, toFrame: endFrame, loopMode: .playOnce) { _ in
                _ = super.sendAction(action, to: target)
                self.isEnabled = true
            }
        } else {
            return super.sendAction(action, to: target)
        }
        return true
    }
    
    private func startFrame() -> CGFloat? {
        (state == StateValue.on) ? animationView?.animation?.endFrame : animationView?.animation?.startFrame
    }
}
