// HistApex 应用图标
// 按 King Top 产品矩阵网页中的 .pol-mark 复刻：
// 白色粗体 P + linear-gradient(135deg, #0f6c7d, #d6413a 58%, #d9a441)。
// 运行：swift scripts/make_icon.swift

import AppKit
import CoreGraphics

let S = 1024
let cs = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(
    data: nil,
    width: S,
    height: S,
    bitsPerComponent: 8,
    bytesPerRow: 0,
    space: cs,
    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
)!

func color(hex: UInt32) -> CGColor {
    let r = CGFloat((hex >> 16) & 0xff) / 255
    let g = CGFloat((hex >> 8) & 0xff) / 255
    let b = CGFloat(hex & 0xff) / 255
    return CGColor(colorSpace: cs, components: [r, g, b, 1])!
}

let gradient = CGGradient(
    colorsSpace: cs,
    colors: [
        color(hex: 0x0f6c7d),
        color(hex: 0xd6413a),
        color(hex: 0xd9a441)
    ] as CFArray,
    locations: [0, 0.58, 1]
)!

// CSS linear-gradient(135deg, ...) 的视觉方向：左上青绿 -> 中部红 -> 右下金色。
ctx.drawLinearGradient(
    gradient,
    start: CGPoint(x: 0, y: 1024),
    end: CGPoint(x: 1024, y: 0),
    options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
)

NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: false)

let paragraph = NSMutableParagraphStyle()
paragraph.alignment = .center

let attrs: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 360, weight: .black),
    .foregroundColor: NSColor.white,
    .paragraphStyle: paragraph
]

let text = NSAttributedString(string: "P", attributes: attrs)
let textSize = text.size()
text.draw(at: NSPoint(x: (CGFloat(S) - textSize.width) / 2,
                      y: (CGFloat(S) - textSize.height) / 2 - 14))

NSGraphicsContext.restoreGraphicsState()

let img = ctx.makeImage()!
let rep = NSBitmapImageRep(cgImage: img)
let png = rep.representation(using: .png, properties: [:])!
let out = URL(fileURLWithPath: "HistApex/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png")
try png.write(to: out)
print("icon written to \(out.path) (no alpha)")
