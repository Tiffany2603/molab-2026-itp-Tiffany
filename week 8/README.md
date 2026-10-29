# Grid Camera

A portrait camera app based on the class [08-CameraRecorder](https://github.com/molab-itp/08-CameraRecorder) example. One continuous camera image is divided into nine regions, with a different effect in each region. The same composition is used for the preview and recorded video.

## Run

1. Open `Grid Camera/Grid Camera.xcodeproj` in Xcode.
2. Connect an iPhone and select it as the run destination.
3. Select your development team in Signing & Capabilities, then run.
4. Allow camera access. Allow Photos additions when saving your first recording.

Minimum iOS version: 17. This project uses the front camera in portrait orientation. A physical phone is needed to test the camera; Simulator displays a message when the front camera is unavailable. No packages or API keys are needed.

## Use

- The nine choices are Normal, Mono, Sepia, Pixellate, Comic, Bloom, False Color, Vignette, and Crystallize. Each appears once, in a random cell.
- Shuffle Filters changes the arrangement. The arrangement stays fixed between button presses and can also be changed during recording.
- Start Recording records the processed nine-region image. Stop Recording finishes the silent MP4 and saves it to Photos.
- Share Last Video shares the latest finished recording. It also provides a way to keep a recording if Photos access is denied. This copy is in temporary app storage, so save or share it if you want to keep it.
- Returning the app to the background stops the camera and ends any current recording. Keep the app open until saving completes.

The scene stays continuous across the cells: this is not nine smaller copies of the same camera image. False Color is a visual effect, not a temperature measurement. Capture uses a modest resolution to reduce the work required for nine live effects.

## Code and Sources

| File | Responsibility |
| --- | --- |
| `ContentView.swift` | Preview and Shuffle, Record, and Share controls |
| `CameraModel.swift` | Camera permission, frame delivery, lifecycle, and Photos saving |
| `GridFilter.swift` | Filter choices, random ordering, region cropping, and composition |
| `MovieWriter.swift` | Encode processed frames into a silent H.264 MP4 |
| `Grid_CameraApp.swift` | App entry point |

From the class source: [camera and recording workflow](https://github.com/molab-itp/08-CameraRecorder/blob/main/CaptureRecorder/Model.swift), [filter choices and parameters](https://github.com/molab-itp/08-CameraRecorder/blob/main/CaptureRecorder/Model-filterImage.swift), and an observable model driving a SwiftUI preview. The writer uses the same AVAssetWriter and pixel-buffer-adaptor approach as class to support iOS 17.

My main change is the nine-region composition and Shuffle Filters button. A nested loop crops nine filtered regions and composites them at their original positions. Integer boundaries prevent gaps when the frame dimensions are not divisible by three. Both preview and recording receive that same final image. Setup is performed once, camera work runs on one serial queue, and a completed video remains shareable if Photos saving fails.

The project includes camera and add-only Photos usage descriptions. Audio capture is not enabled, matching the silent recording path in the class example.

## Verification

The iOS device target compiled successfully without code signing. Automated checks cover random effect arrangements, complete region coverage without overlaps, odd frame dimensions, and the composed image extent. Camera output, visual filter results, orientation, encoding performance, and saving to Photos still require an iPhone test.
