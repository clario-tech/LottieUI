//
//  ViewController.swift
//  IosSample
//
//  Created by Viktor Radulov on 12/25/20.
//

import UIKit
import LottieUITouch

class ViewController: AnimationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.play(toMarker: "screen1")
    }
    
    @IBAction func next2(_ sender: Any) {
        animationView.play(toMarker: "screen2")
    }
}

