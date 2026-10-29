import CoreImage.CIFilterBuiltins
import Foundation

// Effects and parameter values follow the class CameraRecorder example.
enum VideoEffect: String, CaseIterable {
    case normal = "Normal", mono = "Mono", sepia = "Sepia"
    case pixellate = "Pixellate", comic = "Comic", bloom = "Bloom"
    case thermal = "False Color", vignette = "Vignette", crystallize = "Crystallize"

    func makeFilter() -> CIFilter? {
        let name: String
        switch self {
        case .normal: return nil
        case .mono: name = "CIPhotoEffectMono"
        case .sepia: name = "CISepiaTone"
        case .pixellate: name = "CIPixellate"
        case .comic: name = "CIComicEffect"
        case .bloom: name = "CIBloom"
        case .thermal: name = "CIFalseColor"
        case .vignette: name = "CIVignette"
        case .crystallize: name = "CICrystallize"
        }
        guard let filter = CIFilter(name: name) else { return nil }
        switch self {
        case .sepia: filter.setValue(0.7, forKey: kCIInputIntensityKey)
        case .pixellate: filter.setValue(30, forKey: kCIInputScaleKey)
        case .bloom:
            filter.setValue(2.0, forKey: kCIInputIntensityKey)
            filter.setValue(40.0, forKey: kCIInputRadiusKey)
        case .thermal:
            filter.setValue(CIColor.red, forKey: "inputColor0")
            filter.setValue(CIColor.green, forKey: "inputColor1")
        case .vignette:
            filter.setValue(0.5, forKey: kCIInputIntensityKey)
            filter.setValue(1.0, forKey: kCIInputRadiusKey)
        case .crystallize: filter.setValue(40.0, forKey: "inputRadius")
        default: break
        }
        return filter
    }
}

struct GridFilter {
    private(set) var effects: [VideoEffect] = []
    private var filters: [CIFilter?] = []

    init() { shuffle() }

    mutating func shuffle() {
        let previous = effects
        repeat { effects = VideoEffect.allCases.shuffled() } while effects == previous
        filters = effects.map { $0.makeFilter() }
    }

    // Integer boundaries prevent gaps when the width or height is not divisible by 3.
    static func cellRect(in bounds: CGRect, row: Int, column: Int) -> CGRect {
        let x0 = bounds.minX + floor(CGFloat(column) * bounds.width / 3)
        let x1 = bounds.minX + floor(CGFloat(column + 1) * bounds.width / 3)
        let y0 = bounds.minY + floor(CGFloat(row) * bounds.height / 3)
        let y1 = bounds.minY + floor(CGFloat(row + 1) * bounds.height / 3)
        return CGRect(x: x0, y: y0, width: x1 - x0, height: y1 - y0)
    }

    func apply(to image: CIImage) -> CIImage {
        var result = CIImage.empty()
        for row in 0..<3 {
            for column in 0..<3 {
                let index = row * 3 + column
                let rect = Self.cellRect(in: image.extent, row: row, column: column)
                var tile = image
                if let filter = filters[index] {
                    filter.setValue(image, forKey: kCIInputImageKey)
                    tile = filter.outputImage ?? image
                }
                // Keep each region at its original location: the scene stays continuous.
                result = tile.cropped(to: rect).composited(over: result)
            }
        }
        return result.cropped(to: image.extent)
    }
}
