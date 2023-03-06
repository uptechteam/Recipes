//
//  Typography.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

public enum Typography {
    case headerOne
    case headerTwo
    // Check if needed
    case headerThree
    case headerFour
    case subtitle
    case subtitleTwo
    case subtitleThree
    // Check if needed
    case subtitleFour
    case body
    case bodyTwo
    // Check if needed
    case bodyThree
    case description
    case buttonLarge
    case buttonSmall
    case other

    // MARK: - Properties

    public var font: UIFont {
        switch self {
        case .headerOne, .headerTwo, .headerFour, .subtitle, .subtitleTwo, .subtitleFour, .description:
            return FontFamily.RedHatDisplay.medium.font(size: fontSize)

        case .headerThree, .subtitleThree, .body, .bodyTwo, .bodyThree:
            return FontFamily.RedHatDisplay.regular.font(size: fontSize)

        case .buttonLarge, .buttonSmall:
            return FontFamily.RedHatText.medium.font(size: fontSize)

        case .other:
            return FontFamily.RedHatDisplay.bold.font(size: fontSize)
        }
    }

    public var fontSize: CGFloat {
        switch self {
        case .headerOne:
            return 40

        case .headerTwo, .headerThree:
            return 30

        case .headerFour:
            return 24

        case .subtitle:
            return 20

        case .subtitleTwo, .subtitleThree:
            return 18

        case .subtitleFour, .body, .buttonLarge:
            return 16

        case .bodyTwo, .description, .buttonSmall, .other:
            return 14

        case .bodyThree:
            return 13
        }
    }

    public var lineHeightMultiple: CGFloat {
        switch self {
        case .headerOne, .headerTwo, .headerThree, .subtitle:
            return 0.91

        case .headerFour:
            return 1.13

        case .subtitleTwo, .subtitleThree, .subtitleFour:
            return 1.01

        case .body:
            return 0.94

        case .bodyTwo, .description, .buttonSmall, .other:
            return 1.08

        case .bodyThree:
            return 1.16

        case .buttonLarge:
            return 1.32
        }
    }

    // MARK: - Public methods

    public func getParameters(color: UIColor) -> [NSAttributedString.Key: Any] {
        [.font: font, .foregroundColor: color]
    }
}
