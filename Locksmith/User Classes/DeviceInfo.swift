//
//  DeviceInfo.swift
//  Locksmith
//
//  Created by Bradley Golski on 2/28/19.
//

import Foundation
import CoreGraphics
import UIKit

class DeviceInfo {
    var titleFontSize: CGFloat
    var screenWidth: CGFloat
    var screenHeight: CGFloat
    var statsFontSize: CGFloat
    init() {
        let screenSize: CGRect = UIScreen.main.bounds
        
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        titleFontSize = (screenWidth * 0.16)
//        let screenHeight = screenSize.height
        statsFontSize = (screenWidth * 0.152)
    
        
        
}
    func retrieveTitleFontSize() -> CGFloat {
        return titleFontSize
    }
    
    func retrieveStatsFontSize() -> CGFloat {
        return statsFontSize
    }
    
    func getScreenWidth() -> CGFloat {
        return screenWidth
    }
    
    func getScreenHeight() -> CGFloat {
        return screenHeight
    }
    
}
