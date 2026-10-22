# Photo Compare

A simple photo app based on the class [07-Instafilter example](https://github.com/molab-itp/07-Instafilter). Choose a photo, adjust a vintage effect, and switch between the original and edited versions.

## Run

1. Open `Photo Compare/Photo Compare.xcodeproj` in Xcode.
2. Select the `Photo Compare` scheme and an iPhone Simulator or your iPhone.
3. For a physical device, select a development team in Signing & Capabilities.
4. Run the app. The selected device needs at least one photo in its photo library.

Minimum iOS version: 17. No packages or API keys are needed.

## Use

1. Tap Choose Photo and select an image.
2. Move the Vintage slider to adjust the sepia effect from 0% to 100%.
3. Turn on Show Original to compare the unedited photo. Turn it off to return to the effect.
4. Reset Effect returns the strength to 70% and shows the edited version.
5. Share Edited Photo opens the system share sheet for the filtered image, even when viewing the original.

The app keeps the chosen photo in memory for the current session. Editing does not replace the original in the photo library. Sharing or saving an edited copy is a separate action in the share sheet.

## Code and Class Reference

- `ContentView.swift`: photo selection, preview, controls, image loading, and filtering.
- `Photo_CompareApp.swift`: app entry point.
- From the [class source](https://github.com/molab-itp/07-Instafilter/blob/main/project13/Instafilter/ContentView.swift): `PhotosPicker`, `loadTransferable`, `Task`, `CIFilter`, `CIContext`, a slider, and `ShareLink`.
- My variation: keep one sepia filter and add an original/edited comparison toggle, a percentage display, and a reset button. The original image is kept separately from the processed result.

Image loading applies orientation metadata so a portrait photo stays upright after processing. An outdated download is ignored if a different photo is selected before it finishes. Load and processing errors appear below the controls.

## Verification

The iOS device target compiled successfully without code signing. Interactive photo selection, the effect preview, and sharing need to be tried in Simulator or on an iPhone. The command-line environment could not run Simulator or render Core Image pixels, so it did not provide a visual check.
