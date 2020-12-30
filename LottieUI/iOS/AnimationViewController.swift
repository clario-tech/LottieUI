//
//  AnimationViewController.swift
//  LottieUI
//
//  Created by Viktor Radulov on 10/24/19.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import UIKit
import Lottie

open class AnimationViewController: UIViewController {
    
    private var canRunManualTransition = true
    
    public var animationView: AnimationView {
        assert(view as? AnimationView != nil, "Animation view controller root view should be AnimationView")
        // Empty AnimationViewController() edge case on uninstalling
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
}
