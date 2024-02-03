//
//  Sketch.swift
//
//
//  Created by Yuki Kuwashima on 2023/01/05.
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

import simd
import SimpleSimdSwift
import MetalKit

open class Sketch: FunctionBase {
    public var metalDrawableSize: f2 = .zero
    public var customMatrix: [f4x4] = [f4x4.createIdentity()]
    public var privateEncoder: SCEncoder?
    public var deltaTime: Float = 0
    public var frameRate: Float { 1 / deltaTime }
    public var packet: SCPacket {
        SCPacket(privateEncoder: privateEncoder!, customMatrix: getCustomMatrix())
    }
    public init() {}
    #if os(visionOS)
    open func update() {}
    #else
    open func setupCamera(camera: MainCamera) {}
    open func update(camera: MainCamera) {}
    #endif
    open func draw(encoder: SCEncoder) {}
    
    open func afterCommit(texture: MTLTexture?) {}
    
    public func beforeDraw(encoder: SCEncoder) {
        self.customMatrix = [f4x4.createIdentity()]
        self.privateEncoder = encoder
    }
    open func preProcess(commandBuffer: MTLCommandBuffer) {}
    open func postProcess(texture: MTLTexture, commandBuffer: MTLCommandBuffer) {}
    public func getCustomMatrix() -> f4x4 {
        return customMatrix.reduce(f4x4.createIdentity(), *)
    }
    
    #if os(macOS)
    open func mouseMoved(with event: NSEvent, camera: MainCamera, viewFrame: CGRect) {}
    open func mouseDown(with event: NSEvent, camera: MainCamera, viewFrame: CGRect) {}
    open func mouseDragged(with event: NSEvent, camera: MainCamera, viewFrame: CGRect) {}
    open func mouseUp(with event: NSEvent, camera: MainCamera, viewFrame: CGRect) {}
    open func mouseEntered(with event: NSEvent, camera: MainCamera, viewFrame: CGRect) {}
    open func mouseExited(with event: NSEvent, camera: MainCamera, viewFrame: CGRect) {}
    open func keyDown(with event: NSEvent, camera: MainCamera, viewFrame: CGRect) {}
    open func keyUp(with event: NSEvent, camera: MainCamera, viewFrame: CGRect) {}
    open func viewWillStartLiveResize(camera: MainCamera, viewFrame: CGRect) {}
    open func resize(withOldSuperviewSize oldSize: NSSize, camera: MainCamera, viewFrame: CGRect) {}
    open func viewDidEndLiveResize(camera: MainCamera, viewFrame: CGRect) {}
    open func scrollWheel(with event: NSEvent, camera: MainCamera, viewFrame: CGRect) {}
    #endif
    
    #if os(iOS)
    open func onScroll(delta: CGPoint, camera: MainCamera, view: UIView, gestureRecognizer: UIPanGestureRecognizer) {}
    open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, camera: MainCamera, view: UIView) {}
    open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, camera: MainCamera, view: UIView) {}
    open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, camera: MainCamera, view: UIView) {}
    open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?, camera: MainCamera, view: UIView) {}
    #endif
}
