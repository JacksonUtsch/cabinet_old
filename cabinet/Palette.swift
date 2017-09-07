//
//  Palette.swift
//  cabinet
//
//  Created by Jackson Utsch on 7/4/17.
//  Copyright © 2017 Jackson Utsch. All rights reserved.
//

import DynamicColor

struct colors {
    static let red = DynamicColor(hex: 0xe74b3b)
    static let yellow = DynamicColor(hex: 0xf0c40f)
    static let blue = DynamicColor(hex: 0x3498db)
    static let gray = DynamicColor(hex: 0x2c3e50)
    static let oldLace = DynamicColor(hex: 0xFDF6E4)
    static let fiord = DynamicColor(hex: 0x485C62)
    static let regantGrey = DynamicColor(hex: 0x738288)
}

public enum themeType:String {
    case softlight = "Soft Light"
    case dusk = "Dusk"
}

public var theme:themeType = .softlight

public struct themeStruct {
    let primary:DynamicColor
    let secondary:DynamicColor
    let highlight:DynamicColor
}

public func themeColors() -> themeStruct {
    switch theme {
    case .softlight:
        return themes.softlight
    case .dusk:
        return themes.dusk
    }
}

private struct themes {
    static let softlight = themeStruct(primary: colors.oldLace, secondary: colors.fiord, highlight: colors.red)
    static let dusk = themeStruct(primary: colors.oldLace, secondary: colors.fiord, highlight: colors.red)
}
