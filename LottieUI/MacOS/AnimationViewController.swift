//
//  AnimationViewController.swift
//  LottieUI
//
//  Created by Viktor Radulov on 10/24/19.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import AppKit
import Lottie

open class AnimationViewController: NSViewController {
    
    private var canRunManualTransition = true
    
    public var animationView: AnimationView {
        assert(view as? AnimationView != nil, "Animation view controller root view should be AnimationView")
        // Creating empty view to prevent from crashing.
        return (view as? AnimationView) ?? AnimationView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.subviews.compactMap { $0 as? AnimationContent }.forEach {
            if let keyPath = $0.keyPath {
                let animationKeyPath = AnimationKeypath(keypath: keyPath)
                if !animationView.addDependency($0, forLayerAt: animationKeyPath) {
                    assert(false, "No view for keyPath \(keyPath)")
                }
            } else {
                assert(false, "AnimationContent with no keyPath")
            }
        }
    }
    
    var previousStateProgressTime: Lottie.AnimationProgressTime? { nil }
    
    func didRollBack(from progress: Lottie.AnimationProgressTime) {
        //Implement in subclass
    }
    
    func rollBack(to progress: Lottie.AnimationProgressTime) {
        var canDoTransition = false
        let bounds = view.bounds
        guard canRunManualTransition, let representation = view.bitmapImageRepForCachingDisplay(in: bounds), let window = view.window else {
            return
        }
        canRunManualTransition = false
        let image = NSImage(size: bounds.size)
        view.cacheDisplay(in: bounds, to: representation)
        image.addRepresentation(representation)
        let imageView = NSImageView(frame: bounds)
        imageView.image = image
        view.addSubview(imageView)
        let currentProgress = animationView.currentProgress
        animationView.currentProgress = progress
        
        let swipeMultiplier: CGFloat = 10
        let minLengthToTransition = imageView.frame.width / 3
        let originalX = imageView.frame.origin.x
        while true {
            guard let event = window.nextEvent(matching: [.scrollWheel]) else { continue }
            if event.phase == .changed {
                let deltaX = swipeMultiplier * event.deltaX
                var newX = imageView.frame.origin.x + deltaX
                if newX < originalX {
                   newX = originalX
                }
                imageView.frame.origin.x = newX
                canDoTransition = imageView.frame.origin.x > minLengthToTransition
            } else {
                break
            }
        }
        
        let finalConstraintConstant = canDoTransition ? bounds.width : 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            imageView.animator().frame.origin.x = finalConstraintConstant
        }, completionHandler: {
            if !canDoTransition {
                self.animationView.currentProgress = currentProgress
            } else {
                self.didRollBack(from: currentProgress)
            }
            imageView.removeFromSuperview()
            self.canRunManualTransition = true
        })
    }
    
    public override func scrollWheel(with event: NSEvent) {
        if let previousTime = previousStateProgressTime, NSEvent.isSwipeTrackingFromScrollEventsEnabled, event.deltaX > 0, !animationView.isAnimationPlaying {
            rollBack(to: previousTime)
        } else {
            super.scrollWheel(with: event)
        }
    }
}
