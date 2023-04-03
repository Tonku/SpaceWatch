# SpaceWatch - iOS 14

## Overview

SpaceWatch is an iOS 14 app that provides information about astronauts

## Dependencies

SpaceWatch has 0 third-party dependencies. The app relies solely on Apple's frameworks and APIs.

## Features

- VIPER architecture with a Coordinator support and a bit of MVVM
- Unit tests for networking and business logic (only for selected files)
- Auto layout (programmatic and storyboard)
- SOLID principles and testable code
- Protocol-oriented approach
- Simple UI
- Image downloading system (not perfect, scope for improvement!)

## Device Orientation

SpaceWatch supports all device orientations. The app adjusts its layout based on the device's current orientation.

## Installation

To install SpaceWatch, simply download the project and open it in Xcode. You can then build and run the app on your iOS 14 device or simulator.

## API access

The server some times put rate limit. If experienced that I have hosted the astronaut list json and a single details json on cloudflare, to use that just use the commented out url in Networking files (AstronautListNetwork and AstronautDetailsNetwork)

