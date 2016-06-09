//
//  FacialExpression.swift
//  OscarNewFaceView
//
//  Created by Abiodun Shuaib on 09/06/2016.
//  Copyright © 2016 Abiodun Shuaib. All rights reserved.
//

import Foundation

struct FacialExpression {
    enum Eyes: Int {
        case Open,
        Closed,
        Squint
    }
    
    enum Eyebrows: Int {
        case Relaxed,
        Normal,
        Furrowed
        
        func moreRelaxed () -> Eyebrows{
            return Eyebrows(rawValue: rawValue - 1) ?? .Relaxed
        }
        func moreFurrowed () -> Eyebrows{
            return Eyebrows(rawValue: rawValue + 1) ?? .Furrowed
        }
    }
    
//    enum Mouth: Int {
//        case Frown,
//        Smirk,
//        Neutral,
//        Grin,
//        Smile
//        
//        func happierMouth() -> Mouth {
//            return Mouth(rawValue: rawValue + 1) ?? .Smile
//        }
//        func sadderMouth() -> Mouth {
//            return Mouth(rawValue: rawValue - 1) ?? .Frown
//        }
//    }
    
    var eyes: Eyes
    var eyeBrows: Eyebrows
//    var mouth: Mouth
}