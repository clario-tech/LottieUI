# LottieUI

Framework for Lottie-driven UI. 

## Lottie-driven?

Check the [Medium article](https://medium.com/clario/a-lottie-driven-ui-architecture-for-macos-ios-applications-c3380989c885)

It means that the core of your screen will be Lottie animation. The animation will serve as a background and guide for controls.
This is similar to active prototypes like Figma. But using LottieUI you can create fast and beautiful native apps.

This project takes the great idea of Lottie and pushes it just a little bit further. It allows you to incorporate not only static
animations like spinners or preloaders. But now you can create interactive screens.

## Installing

### Submodule

You can add this project as a submodule and incorporate LottieUI.xcodeproj.
But don't forget to pull our submodules too!

### Cocoapods 

// TODO

### Swift Package Manager

- LottieUI lib for MacOS
- LottieUITouch lib for iOS

### Binary

Grab last artifacts from GithubActions or from Release page

## Sample

I will try to pack a sample with as many features as I can =) So check it to understand more.

## Usage

### Create an animation of your flow in After Effects. 

Download Adobe After Effects and design your beautiful screens. You can use AE templates to start working with already great looking animation. 
But be aware of supported features in Lottie. We constantly adding new, but there are too many of them for a side project.

### Export it using Bodymovin. 

Download Bodymovin plugin for AE. Select your main composition and export it using plugin UI.

We use only two preferences: 
- Assets -> Original Asset Names 
- Export Modes -> Standart

Everything else is disabled.

### Add controllers and controls.

 1. Create AnimationViewController in a storyboard. 
 2. Change the root view class to AnimationView. 
 3. Change the animation name to your JSON file. 
 4. Add AnimationContent controls to storyboard or programmatically using `addDependency()` method.
 
## Requirements to Build the Project

1. Access to LottieUI project and it's [dependencies](#project-dependencies);
2. Change Apple ID account in Signing&Capabilities;
3. Specific macOS and Xcode versions (see LottieUI.xcodeproj, Xcode 11.3, and MacOS 10.14 for now).

## Project Dependencies

Project dependencies are being handled by Git submodules.
Use SourceTree or run "git submodule init update" from the project root

# Development Process

## Git Branching Model

[Git-flow](http://nvie.com/posts/a-successful-git-branching-model/)


## Coding Style

* [Google Coding Standard](https://google.github.io/swift)
* [Swift Lint](https://github.com/realm/SwiftLint/blob/master/Rules.md)


## Versioning

Every version number is described as:
```
x.y.z
```
Where:
* x – major version;
* y – minor version;
* z – bugfix version.
