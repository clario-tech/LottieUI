//
//  AnimationContent.swift
//  LottieUI
//
//  Created by Viktor Radulov on 10/24/19.
//  Copyright © 2019 Clario Tech Limited. All rights reserved.
//

import Lottie

protocol AnimationContent: CompositionLayerDependency {
    var keyPath: String? { get }
}
