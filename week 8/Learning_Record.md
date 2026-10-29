# Week 08 Learning Record

Learning resources: [Week08 — Video Media](https://github.com/molab-itp/content-2026-itp/blob/main/weeks/08_video.md), [08-CameraRecorder](https://github.com/molab-itp/08-CameraRecorder)

Goal: Adapt the class video example with a random nine-region filter composition.

Project: **Grid Camera**

## Code Questions and Notes

### Receiving live camera frames

***AVCaptureSession*** connects the camera input to a video output. ***captureOutput*** receives each new frame. This is similar to repeatedly processing an image in a p5.js sketch, but AVFoundation delivers the frames through a delegate method.

### Making nine regions

***GridFilter.apply(to:)*** uses nested loops for three rows and three columns. Each region keeps its original position, so the scene stays continuous. ***cropped(to:)*** selects a rectangle, and ***composited(over:)*** combines the filtered regions. This is similar to calculating cell positions when drawing a grid in p5.js.

### Keeping random effects stable

***shuffled()*** rearranges the nine effect choices. The array changes only at startup or when Shuffle Filters is pressed. Randomizing inside every frame would make the effects keep changing. One region shows the original image through the Normal choice.

### Recording the processed result

The preview and ***MovieWriter*** use the same final ***CIImage***. ***AVAssetWriter*** encodes the processed pixel buffers into an MP4. Frame timestamps preserve the timing of the camera stream. The recording contains the effects, rather than only showing them as interface overlays.

### Model and interface

The class example uses ***@Observable*** to connect its model to SwiftUI. This project follows that structure. Camera and recording work use one serial queue, while visible properties such as ***previewImage*** and ***isRecording*** update on the main queue. This avoids changing a filter while another part of the code is using it.

### Permissions and saving

The app requests camera access before starting. It requests add-only Photos access when saving a recording. A finished video remains available through Share Last Video if saving to Photos fails. Like the class recording path, this version records video without sound.

## Class Reference and My Changes

The camera input, per-frame Core Image processing, observable model, video writer, and Photos saving follow the class CameraRecorder workflow. The filter choices and parameter values also come from the class example.

My main changes are the nine-region layout, the random filter arrangement, and the Shuffle Filters button. The same composition is used for preview and recording. Camera setup runs once, and recording ends when the app enters the background.

## Final Project Research

The everyday-assistant idea still focuses on portability and phone sensors. Apple's [device-motion guide](https://developer.apple.com/documentation/coremotion/getting-processed-device-motion-data) describes orientation and gravity data that could support a simple level tool. This week's camera work adds another possible input: a reference image alongside a saved measurement. The next question is which small everyday task would benefit from combining these features.

## Weekly Summary

This project moves from processing a selected photo to processing a live camera stream. It reuses the class camera and recording structure, then adds region-based filters with arrays, nested loops, cropping, and composition. The iOS target compiled successfully. The next step is checking the preview, recording, and Photos saving on an iPhone.
