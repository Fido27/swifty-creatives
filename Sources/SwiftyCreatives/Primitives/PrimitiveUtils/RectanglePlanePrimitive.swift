//
//  RectanglePlanePrimitive.swift
//  
//
//  Created by Yuki Kuwashima on 2023/02/19.
//

import simd

public class RectanglePlanePrimitive<Info: PrimitiveInfo>: HitTestablePrimitive<Info> {
    private func calculateHitTest(origin: f3, direction: f3, testDistance: Float) -> (globalPos: f3, localPos: f3)? {
        
        let model = mockModel() * simd_transpose(cachedCustomMatrix)
        let selfPos_f4 = f4(pos.x, pos.y, pos.z, 1) * model
        let selfPos = f3(selfPos_f4.x, selfPos_f4.y, selfPos_f4.z)

        let a = f4(0, 0, 1, 1) * model

        let A = origin
        let B = origin + direction * testDistance
        let n = simd_normalize(f3(a.x, a.y, a.z) - selfPos)
        let P = selfPos

        let PAdotN = simd_dot(A-P, n)
        let PBdotN = simd_dot(B-P, n)
        
        guard (PAdotN >= 0 && PBdotN <= 0) || (PAdotN <= 0 && PBdotN >= 0) else {
            return nil
        }

        let ttt = abs(PAdotN) / (abs(PAdotN)+abs(PBdotN))
        let x = A + (B-A) * ( ttt )
        
        let inverseModel = simd_inverse(model)
        let processedLocalPos = f4(x.x, x.y, x.z, 1) * inverseModel
        
        guard abs(processedLocalPos.x) <= scale.x && abs(processedLocalPos.y) <= scale.y else {
            return nil
        }
        
        let processedLocalPos_f3 = f3(processedLocalPos.x, processedLocalPos.y, processedLocalPos.z)
        
        return (x, processedLocalPos_f3)
    }
    
    public func hitTestGetPos(origin: f3, direction: f3, testDistance: Float = 3000) -> f3? {
        if let result = calculateHitTest(origin: origin, direction: direction, testDistance: testDistance) {
            return result.globalPos
        } else {
            return nil
        }
    }
    
    public func hitTestGetNormalizedCoord(origin: f3, direction: f3, testDistance: Float = 3000) -> f2? {
        if let result = calculateHitTest(origin: origin, direction: direction, testDistance: testDistance) {
            let localPos = result.localPos
            return f2(localPos.x / scale.x, localPos.y / scale.y)
        } else {
            return nil
        }
    }
    
    public func drawWithCache(encoder: SCEncoder, customMatrix: f4x4) {
        draw(encoder)
        cachedCustomMatrix = customMatrix
    }
}
