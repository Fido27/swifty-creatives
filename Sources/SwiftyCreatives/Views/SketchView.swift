//
//  SketchView.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/28.
//

import MetalKit
import SwiftUI

#if !os(visionOS)

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public struct SketchView: ViewRepresentable {
    let renderer: RendererBase
    let drawProcess: Sketch
    public init(
        _ sketch: Sketch,
        blendMode: RendererBase.BlendMode = .alphaBlend,
        cameraConfig: CameraConfig = DefaultOrthographicConfig(),
        drawConfig: DrawConfig = DefaultDrawConfig()
    ) {
        self.drawProcess = sketch
        self.renderer = blendMode.getRenderer(
            sketch: self.drawProcess,
            cameraConfig: cameraConfig,
            drawConfig: drawConfig
        )
    }
    
    #if os(macOS)
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = TouchableMTKView(renderer: renderer)
        return mtkView
    }
    public func updateNSView(_ nsView: MTKView, context: Context) {}
    #elseif os(iOS) || os(tvOS)
    public func makeUIView(context: Context) -> MTKView {
        let mtkView = TouchableMTKView(renderer: renderer)
        return mtkView
    }
    public func updateUIView(_ uiView: MTKView, context: Context) {}
    #endif
}

#endif
