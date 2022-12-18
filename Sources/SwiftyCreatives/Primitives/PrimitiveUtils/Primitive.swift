//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2022/12/17.
//

import Metal

open class Primitive<Info: PrimitiveInfo>: PrimitiveBase {
    
    private var _color: [f4] = [f4.zero]
    private var _mPos: [f3] = [f3.zero]
    private var _mRot: [f3] = [f3.zero]
    private var _mScale: [f3] = [f3.one]
    
    public var color: f4 { _color[0] }
    public var pos: f3 { _mPos[0] }
    public var rot: f3 { _mRot[0] }
    public var scale: f3 { _mScale[0] }
    
    private var colorNeedsUpdate = true
    private var posNeedsUpdate = true
    private var rotNeedsUpdate = true
    private var scaleNeedsUpdate = true
    
    required public init() {}
    
    public func setColor(_ value: f4) {
        _color[0] = value
        colorNeedsUpdate = true
    }
    
    public func setPos(_ value: f3) {
        _mPos[0] = value
        posNeedsUpdate = true
    }
    
    public func setRot(_ value: f3) {
        _mRot[0] = value
        rotNeedsUpdate = true
    }
    
    public func setScale(_ value: f3) {
        _mScale[0] = value
        scaleNeedsUpdate = true
    }
    
    public func draw(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(Info.buffer, offset: 0, index: 0)
        encoder.setVertexBytes(_color, length: f4.memorySize, index: 1)
        encoder.setVertexBytes(_mPos, length: f3.memorySize, index: 2)
        encoder.setVertexBytes(_mRot, length: f3.memorySize, index: 3)
        encoder.setVertexBytes(_mScale, length: f3.memorySize, index: 4)
        encoder.drawPrimitives(type: Info.primitiveType, vertexStart: 0, vertexCount: Info.vertexCount)
    }
}
