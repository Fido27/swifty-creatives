//
//  BoxTests.swift
//
//
//  Created by Yuki Kuwashima on 2023/03/28.
//

@testable import SwiftyCreatives
import XCTest
import SwiftUI
import SnapshotTesting
import MetalKit

#if os(macOS)
final class BoxTests: XCTestCase {
    
    @MainActor
    func testBoxIsDrawed() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func draw(encoder: SCEncoder) {
                color(1)
                box(3)
            }
            override func afterCommit(texture: MTLTexture?) {
                self.expectation.fulfill()
                let desc = MTLTextureDescriptor()
                desc.width = texture!.width
                desc.height = texture!.height
                desc.textureType = .type2D
                let tex = ShaderCore.device.makeTexture(descriptor: desc)!
                
                let cb = ShaderCore.commandQueue.makeCommandBuffer()!
                let blitEncoder = cb.makeBlitCommandEncoder()!
                blitEncoder.copy(from: texture!, to: tex)
                blitEncoder.endEncoding()
                cb.commit()
                cb.waitUntilCompleted()
                
                let cgimage = tex.cgImage!
                let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
                assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording, testName: "testBoxIsDrawed")
            }
        }
        
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation)
        let swiftuiView = SketchView(sketch)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testBoxColorWorking() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func draw(encoder: SCEncoder) {
                color(1, 0.5, 0.2, 0.8)
                box(3)
            }
            override func afterCommit(texture: MTLTexture?) {
                self.expectation.fulfill()
                let desc = MTLTextureDescriptor()
                desc.width = texture!.width
                desc.height = texture!.height
                desc.textureType = .type2D
                let tex = ShaderCore.device.makeTexture(descriptor: desc)!
                
                let cb = ShaderCore.commandQueue.makeCommandBuffer()!
                let blitEncoder = cb.makeBlitCommandEncoder()!
                blitEncoder.copy(from: texture!, to: tex)
                blitEncoder.endEncoding()
                cb.commit()
                cb.waitUntilCompleted()
                
                let cgimage = tex.cgImage!
                let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
                assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording, testName: "testBoxColorWorking")
            }
        }
        
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation)
        let swiftuiView = SketchView(sketch)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testBoxRotationWorking() async throws {
        try SnapshotTestUtil.testGPU()
        
        class TestSketch: Sketch {
            let expectation: XCTestExpectation
            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
                super.init()
            }
            override func draw(encoder: SCEncoder) {
                color(1, 0.5, 0.2, 0.8)
                rotateX(0.5)
                rotateY(0.5)
                box(3)
            }
            override func afterCommit(texture: MTLTexture?) {
                self.expectation.fulfill()
                let desc = MTLTextureDescriptor()
                desc.width = texture!.width
                desc.height = texture!.height
                desc.textureType = .type2D
                let tex = ShaderCore.device.makeTexture(descriptor: desc)!
                
                let cb = ShaderCore.commandQueue.makeCommandBuffer()!
                let blitEncoder = cb.makeBlitCommandEncoder()!
                blitEncoder.copy(from: texture!, to: tex)
                blitEncoder.endEncoding()
                cb.commit()
                cb.waitUntilCompleted()
                
                let cgimage = tex.cgImage!
                let finalimage = NSImage(cgImage: cgimage, size: NSSize(width: 100, height: 100))
                assertSnapshot(matching: finalimage, as: .image, record: SnapshotTestUtil.isRecording, testName: "testBoxRotationWorking")
            }
        }
        
        let expectation = XCTestExpectation()
        let sketch = TestSketch(expectation)
        let swiftuiView = SketchView(sketch)
        let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), device: ShaderCore.device)
        swiftuiView.renderer.draw(in: mtkView)
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
