//
//  Lottie+Extension.swift
//  Lumis
//
//  Created by Illia Herasymov on 24.10.2019.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import Cocoa
import Lottie

extension AnimationView {
    func add<T: AnimationContent & NSView>(animationContent: T) {
        guard let keyPath = animationContent.keyPath else { return }
        let animationKeyPath = AnimationKeypath(keypath: keyPath)
        addSubview(animationContent)
        if !addDependency(animationContent, forLayerAt: animationKeyPath) {
            assert(false, "No button for keyPath \(keyPath)")
        }
    }
    
    func resetAnimation(to marker: String) {
        skipAnimation(to: marker)
        forceDisplayUpdate()
    }
    
    func skipAnimation(to marker: String) {
        if let progress = progressTime(forMarker: marker) {
            currentProgress = progress
        }
    }
}
