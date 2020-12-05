//
//  AppDelegate.swift
//  LottieUISample
//
//  Created by Viktor Radulov on 12/5/20.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let window = NSApp.windows.first {
            window.styleMask.remove(.unifiedTitleAndToolbar)
            window.styleMask.insert(.fullSizeContentView)
            window.styleMask.insert(.titled)
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

