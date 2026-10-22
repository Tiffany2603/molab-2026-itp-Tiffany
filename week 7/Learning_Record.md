# Week 07 Learning Record

Learning resources: [Week07 — Photo Media](https://github.com/molab-itp/content-2026-itp/blob/main/weeks/07_photo.md), [07-Instafilter](https://github.com/molab-itp/07-Instafilter), [Apple Photos picker sample](https://developer.apple.com/documentation/photokit/bringing-photos-picker-to-your-swiftui-app)

Goal: Build a small app that selects and processes photos, with a simple change to the class example.

Project: **Photo Compare**

## Code Questions and Notes

### Selecting a photo

***PhotosPicker*** opens the system photo picker. ***$selectedItem*** connects the selection to a ***@State*** property. The selected item represents a photo; it is not the image data yet. This is similar to choosing a file before using it in a p5.js sketch.

### Loading the image

***loadImage()*** uses ***Task*** and ***await*** to load the data with ***loadTransferable(type: Data.self)***. This resembles waiting for a JavaScript Promise. ***guard let*** checks that the data and images exist. A failed load displays a message instead of force unwrapping a missing value.

### Applying the effect

***CIImage*** is the input for Core Image. ***CIFilter.sepiaTone()*** adds a vintage brown tone, and ***CIContext.createCGImage*** renders the result for display. The idea is similar to using [***filter(GRAY)*** in p5.js](https://p5js.org/reference/p5/filter/) to change an image's colors, although the effect is different. Swift uses several image types for processing and display.

### Comparing before and after

The app stores ***originalImage*** and ***processedImage*** separately. ***showOriginal*** decides which one appears. Unlike the class example, the app focuses on one effect and makes it easy to compare the original and edited versions.

### Changing the strength

***Slider*** changes ***filterIntensity*** between 0 and 1. ***.onChange*** calls ***applyProcessing()*** when the value changes. The original Core Image input is reused each time, so moving the slider does not repeatedly filter an already edited result.

### Sharing and image orientation

***ShareLink*** shares the edited image through the system share sheet. The original library photo stays unchanged. Phone photos can store their rotation in metadata, so ***.applyOrientationProperty*** keeps the processed image upright.

## Final Project Research

The final-project direction remains a small everyday assistant based on phone portability and sensors. Apple's [device-motion guide](https://developer.apple.com/documentation/coremotion/getting-processed-device-motion-data) shows how ***CMMotionManager*** provides orientation, gravity, and motion data. One possible first tool is a simple level that helps check whether a surface is tilted.

The [Photos picker sample](https://developer.apple.com/documentation/photokit/bringing-photos-picker-to-your-swiftui-app) shows how to select and load a photo. A future assistant could attach a reference photo to a saved measurement. The next step is to try one sensor feature on a phone and decide whether the photo is useful. Sensor tools are not part of this week's photo app.

## Weekly Summary

This week's app follows the class photo-loading and Core Image workflow. The main variation is an original/edited comparison toggle with one adjustable vintage effect. The important distinction is between selecting an item, loading image data, processing it, and displaying or sharing the result.
