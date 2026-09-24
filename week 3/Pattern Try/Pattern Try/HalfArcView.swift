//
//  HalfArcView.swift
//  Pattern Try
//
//  Created by 袁梓祎 on 9/24/26.
//

import SwiftUI

// State for the half arc view (kept separate so the two views don't mix)
var halfRing = 0;
struct HalfArcData {
  var path: Path;
  var color: Color;
  var born: Date;  // when it was drawn, to fade to gray after 1 second
}
var halfPaths: [HalfArcData] = [];
let settledColor = Color(white: 0.85);  // light gray


// Pattern 2: half circles that open away from the center
// above center = top half, below = bottom half, left = left half, right = right half
struct HalfArcView: View {
  var body: some View {
    TimelineView(.animation(minimumInterval: animInterval)) { timeline in
      Canvas { context, size in
        let now = timeline.date
        nsize = CGSize(width: size.width/ncell, height: size.width/ncell)
        let ncols = Int(ncell)
        let nrows = Int((size.height / nsize.height).rounded(.up))
        var maxRing = 0

        // Add a half arc for every cell on the current ring
        for row in 0..<nrows {
          for col in 0..<ncols {
            // signed distance from canvas center, in cells: + is right / down
            let dx = ((Double(col) + 0.5) * nsize.width - size.width/2) / nsize.width
            let dy = ((Double(row) + 0.5) * nsize.height - size.height/2) / nsize.height
            let cellRing = Int((dx*dx + dy*dy).squareRoot())
            maxRing = max(maxRing, cellRing)
            if cellRing == halfRing {
              let loc = CGPoint(x: Double(col) * nsize.width, y: Double(row) * nsize.height)
              let path = halfArc(loc, dx: dx, dy: dy);
              let color = colorSpecs.randomElement()!
              halfPaths.append(HalfArcData(path: path, color: color, born: now));
            }
          }
        }

        // Draw all: random color for the first second, then light gray
        for p in halfPaths {
          let style = StrokeStyle(lineWidth: lineWidth, lineCap: .round);
          let age = now.timeIntervalSince(p.born)
          let color = age < 1.0 ? p.color : settledColor
          context.stroke(p.path, with: .color(color), style: style)
        }

        // Advance to next ring, start over after the outermost ring
        halfRing += 1;
        if halfRing > maxRing {
          halfRing = 0;
          halfPaths = [];
        }
      }
    }
  }
}

// Draw a half circle in the cell, opening away from the center
// dx, dy: which way this cell is from the center (+ is right / down)
func halfArc(_ p: CGPoint, dx: Double, dy: Double) -> Path {
  var path = Path()
  let r = nsize.width / 2;
  let center = CGPoint(x: p.x + r, y: p.y + nsize.height/2)
  // angles: 0 = right, 90 = down, 180 = left, 270 = up
  var start: Double
  if abs(dy) > abs(dx) {
    start = dy < 0 ? 180 : 0     // up: top half,  down: bottom half
  } else if abs(dx) > abs(dy) {
    start = dx < 0 ? 90 : 270    // left: left half, right: right half
  } else {
    start = [0, 90, 180, 270].randomElement()!  // exact diagonal or center: pick at random
  }
  path.addRelativeArc(center: center, radius: r,
                      startAngle: .degrees(start), delta: .degrees(180))
  return path;
}

#Preview {
  HalfArcView()
}
