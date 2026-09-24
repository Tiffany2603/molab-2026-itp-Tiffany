//
//  ContentView.swift
//  Pattern Try
//
//  Created by 袁梓祎 on 9/24/26.
//

import SwiftUI

let animInterval = 0.30; // update very tenth of a second
let ncell = 15.0
let lineWidth = 6.0
let colorSpecs = [Color.red, Color.green, Color.yellow, Color.black];

var ring = 0;  // which ring we are drawing, 0 = center
var nsize: CGSize = .zero;
struct PathData {
  var path: Path;
  var color: Color;
}
var paths: [PathData] = [];

// Switch between the two pattern views with a button at the bottom
struct ContentView: View {
  @State private var showHalfArcs = false

  var body: some View {
    VStack {
      if showHalfArcs {
        HalfArcView()
      } else {
        RingArcView()
      }
      Button(showHalfArcs ? "Show Arcs" : "Show Half Arcs") {
        showHalfArcs.toggle()
      }
      .buttonStyle(.borderedProminent)
      .padding()
    }
  }
}


// Pattern 1: random quarter arcs, spreading out from the center in round rings
struct RingArcView: View {
  var body: some View {
    TimelineView(.animation(minimumInterval: animInterval)) { timeline in
      Canvas { context, size in
        // print("size", size)
        nsize = CGSize(width: size.width/ncell, height: size.width/ncell)
        let ncols = Int(ncell)
        let nrows = Int((size.height / nsize.height).rounded(.up))
        var maxRing = 0

        // Add a path for every cell on the current ring
        for row in 0..<nrows {
          for col in 0..<ncols {
            // distance from cell center to canvas center, in cells
            let dx = abs((Double(col) + 0.5) * nsize.width - size.width/2) / nsize.width
            let dy = abs((Double(row) + 0.5) * nsize.height - size.height/2) / nsize.height
            // round rings: straight-line distance (use max(dx, dy) for square rings)
            let cellRing = Int((dx*dx + dy*dy).squareRoot())
            maxRing = max(maxRing, cellRing)
            if cellRing == ring {
              let loc = CGPoint(x: Double(col) * nsize.width, y: Double(row) * nsize.height)
              let path = randomArc(loc);  // swap for randomSlash(loc) to get straight lines
              let color = colorSpecs.randomElement()!
              paths.append(PathData(path: path, color: color));
            }
          }
        }

        // Draw all the paths in paths array
        for p in paths {
          let style = StrokeStyle(lineWidth: lineWidth, lineCap: .round);
          context.stroke(p.path, with: .color(p.color), style: style)
        }

        // Advance to next ring, start over after the outermost ring
        ring += 1;
        if ring > maxRing {
          ring = 0;
          paths = [];
        }
        // must read to trigger update
        _ = timeline.date
      }
    }
  }
}

// Draw a diagonal line in random direction
func randomSlash(_ p: CGPoint) -> Path {
  var path = Path()
  let x = p.x;
  let y = p.y;
  let xlen = nsize.width;
  let ylen = nsize.height;
  if Bool.random() {
    // Draw line top left to bottom right
    path.move(to: CGPoint(x: x, y: y))
    path.addLine(to: CGPoint(x: x+xlen, y: y+ylen))
  }
  else {
    // Draw line top right to bottom left
    path.move(to: CGPoint(x: x+xlen, y: y))
    path.addLine(to: CGPoint(x: x, y: y+ylen))
  }
  return path;
}

// Draw two quarter circles at opposite corners, in random direction
func randomArc(_ p: CGPoint) -> Path {
  var path = Path()
  let x = p.x;
  let y = p.y;
  let xlen = nsize.width;
  let ylen = nsize.height;
  let r = xlen / 2;
  // angles: 0 = right, 90 = down, 180 = left, 270 = up
  if Bool.random() {
    // Arcs around top left and bottom right corners  ╯╭
    path.move(to: CGPoint(x: x+r, y: y))
    path.addRelativeArc(center: CGPoint(x: x, y: y), radius: r,
                        startAngle: .degrees(0), delta: .degrees(90))
    path.move(to: CGPoint(x: x+xlen-r, y: y+ylen))
    path.addRelativeArc(center: CGPoint(x: x+xlen, y: y+ylen), radius: r,
                        startAngle: .degrees(180), delta: .degrees(90))
  }
  else {
    // Arcs around top right and bottom left corners  ╰╮
    path.move(to: CGPoint(x: x+xlen, y: y+r))
    path.addRelativeArc(center: CGPoint(x: x+xlen, y: y), radius: r,
                        startAngle: .degrees(90), delta: .degrees(90))
    path.move(to: CGPoint(x: x, y: y+ylen-r))
    path.addRelativeArc(center: CGPoint(x: x, y: y+ylen), radius: r,
                        startAngle: .degrees(270), delta: .degrees(90))
  }
  return path;
}

#Preview {
  ContentView()
}
