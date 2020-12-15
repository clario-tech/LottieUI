//
//  ViewController.swift
//  LottieUISample
//
//  Created by Viktor Radulov on 12/5/20.
//

import Cocoa
import LottieUI

class ViewController: AnimationViewController {

    override func viewDidAppear() {
        super.viewDidAppear()
        
        animationView.play(toMarker: "screen1")
    }
    @IBAction func next(_ sender: Any) {
        animationView.play(toMarker: "screen2")
    }
}

