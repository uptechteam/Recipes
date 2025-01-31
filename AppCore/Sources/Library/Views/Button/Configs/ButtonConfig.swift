//
//  ButtonConfig.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import UIKit

public struct ButtonConfig: Equatable {

    // MARK: - Properties

    let buttonSize: ButtonSize
    let colorConfig: ColorConfig
    let imagePosition: ButtonImagePosition
    let isBackgroundVisible: Bool
    let isBorderVisible: Bool

    var borderWidth: CGFloat {
        isBorderVisible ? 1 : 0
    }

    var titleTypography: Typography {
        switch buttonSize {
        case .large, .medium:
            return .buttonLarge

        case .small:
            return .buttonSmall
        }
    }

    // MARK: - Lifecycle

    public init(
        buttonSize: ButtonSize = .large,
        colorConfig: ColorConfig = .secondary,
        imagePosition: ButtonImagePosition = .left,
        isBackgroundVisible: Bool = true,
        isBorderVisible: Bool = false
    ) {
        self.buttonSize = buttonSize
        self.colorConfig = colorConfig
        self.imagePosition = imagePosition
        self.isBackgroundVisible = isBackgroundVisible
        self.isBorderVisible = isBorderVisible
    }

    // MARK: - Public methods

    func backgroundColor(for state: ButtonState) -> UIColor {
        guard isBackgroundVisible else {
            return .clear
        }

        switch state {
        case .normal:
            return colorConfig.main

        case .highlighted:
            return colorConfig.secondary

        case .disabled:
            return .disabledBackground
        }
    }

    func borderColor(for state: ButtonState) -> UIColor {
        guard isBorderVisible else {
            return .clear
        }

        switch state {
        case .normal:
            return colorConfig.main

        case .highlighted:
            return colorConfig.secondary

        case .disabled:
            return .textDisabled
        }
    }

    func titleColor(for state: ButtonState) -> UIColor {
        switch state {
        case .normal:
            if isBackgroundVisible {
                return colorConfig == .white ? .appBlack : .appWhite
            } else {
                return colorConfig.main
            }

        case .highlighted:
            if isBackgroundVisible {
                return colorConfig == .white ? .appBlack : .appWhite
            } else {
                return colorConfig.secondary
            }

        case .disabled:
            return .textDisabled
        }
    }
}
