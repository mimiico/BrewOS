// The Swift Programming Language
// https://docs.swift.org/swift-book

print("Hello, world!")
import SwiftIO
import MadBoard
import ST7789
import MadGraphics
import BrewUI

// -----------------------------------------------------------------------------
// MARK: - Sample Usage: ContentView and App Launch
// This sample content view is written in a SwiftUI-like style.
// (Note: No text is drawn; you simply see outlined rectangles.)

struct ContentView: BrewView {
    let body: Group
    // let font = Font(path: "/lfs/Resources/Fonts/Graduate-Regular.ttf")
    init() {
        body = Group {
            Button(text: "Option A", frame: Frame(x: 20, y: 20, width: 200, height: 30)) {
                // Action for Button 1.
            }
            Button(text: "Option B", frame: Frame(x: 20, y: 70, width: 200, height: 30)) {
                // Action for Button 2.
            }
            Button(text: "Option C", frame: Frame(x: 20, y: 120, width: 200, height: 30),
                   foregroundColor: Color.blue.rawValue) {
                // Action for Button 3.
            }

            Text("Hello, world!", frame: Frame(x: 20, y: 170, width: 200, height: 30))
        }
    }
    
    public func render(in context: inout BrewUIContext) {
        body.render(in: &context)
    }
    
    public func actionForButton(at index: Int) -> (() -> Void)? {
        return body.actionForButton(at: index)
    }
    
    public func buttonCount() -> Int {
        return body.buttonCount()
    }
}

// ----------------------------------------------------------------------------
// MARK: - App Entry Point
// Wrap all the global initialization inside a @main type.

let bl = DigitalOut(Id.D2)
let rst = DigitalOut(Id.D12)
let dc = DigitalOut(Id.D13)
let cs = DigitalOut(Id.D5)
let spi = SPI(Id.SPI0, speed: 30_000_000)
let screen = ST7789(spi: spi, cs: cs, dc: dc, rst: rst, bl: bl, rotation: .angle90)
var screenBuffer = [UInt16](repeating: 0, count: screen.width * screen.height)
let layer = Layer(at: .zero, anchorPoint: .zero,
                    width: screen.width, height: screen.height)
var frameBuffer = [UInt32](repeating: 0, count: screen.width * screen.height)

let pot = AnalogIn(Id.A0)
let hwButton = DigitalIn(Id.D1)
let buzzer = PWMOut(Id.PWM5A)
buzzer.suspend()  // Buzzer off initially

let contentView = ContentView()

var app = BrewUIApp(content: contentView,
                    pot: pot,
                    hwButton: hwButton,
                    buzzer: buzzer,
                    screen: screen,
                    layer: layer,
                    screenBuffer: screenBuffer,
                    frameBuffer: frameBuffer)
app.run()
