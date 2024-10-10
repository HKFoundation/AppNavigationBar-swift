//
//  AppNavigationBarOption.swift
//  AppUIKit
//
//  Created by bormil on 2024/8/1.
//  Copyright © 2024 深眸科技（北京）有限公司. All rights reserved.
//

import UIKit

public class AppNavigationBarOption {
    public struct `default` {
        static var backgroundEffect: AppNavigationBarOption.Effect = .blur(.light)
        static var backgroundAlpha: CGFloat = 1
        static var tintColor: UIColor = .black
        static var isWhiteBarStyle: Bool = false
        static var shadowImageAlpha: CGFloat = 0.5
        static var alpha: CGFloat = 1
        static func option() -> AppNavigationBarOption {
            let op = AppNavigationBarOption()
            op.backgroundEffect = `default`.backgroundEffect
            op.backgroundAlpha = `default`.backgroundAlpha
            op.tintColor = `default`.tintColor
            op.isWhiteBarStyle = `default`.isWhiteBarStyle
            op.shadowImageAlpha = `default`.shadowImageAlpha
            op.alpha = `default`.alpha
            return op
        }
    }

    /// set navigationBar.fakeBar's backgroundEffect, default: .blur(.light)
    public var backgroundEffect: AppNavigationBarOption.Effect? {
        get { return _backgroundEffect }
        set { _backgroundEffect = newValue }
    }

    /// set navigationBar.fakeBar's backgroundAlpha, default: 1
    public var backgroundAlpha: CGFloat? {
        get { return _backgroundAlpha }
        set {
            if let newValue = newValue {
                if newValue > 1 {
                    _backgroundAlpha = 1
                } else if newValue < 0 {
                    _backgroundAlpha = 0
                } else {
                    _backgroundAlpha = newValue
                }
            } else {
                _backgroundAlpha = nil
            }
        }
    }

    /// set navigationBar's tintColor, default: black
    public var tintColor: UIColor? {
        get { return _tintColor }
        set { _tintColor = newValue }
    }

    /// set navigationBar's isWhiteBarStyle, default: false
    public var isWhiteBarStyle: Bool? {
        get { return _isWhiteBarStyle }
        set { _isWhiteBarStyle = newValue }
    }

    /// set navigationBar's shadowImageAlpha, default: 0.5
    public var shadowImageAlpha: CGFloat? {
        get { return _shadowImageAlpha }
        set {
            if let newValue = newValue {
                if newValue > 1 {
                    _shadowImageAlpha = newValue
                } else if newValue < 0 {
                    _shadowImageAlpha = 0
                } else {
                    _shadowImageAlpha = newValue
                }
            } else {
                _shadowImageAlpha = nil
            }
        }
    }

    /// set navigationBar's alpha, default: 1
    public var alpha: CGFloat? {
        get { return _alpha }
        set {
            if let newValue = newValue {
                if newValue > 1 {
                    _alpha = 1
                } else if newValue < 0 {
                    _alpha = 0
                } else {
                    _alpha = newValue
                }
            } else {
                _alpha = nil
            }
        }
    }

    /* ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄*
     * // MARK: - Internal
     * ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄*/

    var _backgroundEffect: AppNavigationBarOption.Effect?
    var _backgroundAlpha: CGFloat?
    var _tintColor: UIColor?
    var _isWhiteBarStyle: Bool?
    var _shadowImageAlpha: CGFloat?
    var _alpha: CGFloat?

    /// init
    internal init() {}
}

extension AppNavigationBarOption: NSCopying, NSMutableCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return copys()
    }

    public func mutableCopy(with zone: NSZone? = nil) -> Any {
        return copys()
    }

    private func copys() -> AppNavigationBarOption {
        let model = AppNavigationBarOption()

        model._backgroundEffect = _backgroundEffect
        model._backgroundAlpha = _backgroundAlpha
        model._tintColor = _tintColor
        model._isWhiteBarStyle = _isWhiteBarStyle
        model._shadowImageAlpha = _shadowImageAlpha
        model._alpha = _alpha

        model.backgroundEffect = backgroundEffect
        model.backgroundAlpha = backgroundAlpha
        model.tintColor = tintColor
        model.isWhiteBarStyle = isWhiteBarStyle
        model.shadowImageAlpha = shadowImageAlpha
        model.alpha = alpha

        return model
    }
}

extension AppNavigationBarOption {
    static func isEqual(lhs: AppNavigationBarOption, rhs: AppNavigationBarOption, preference: AppNavigationBarOption) -> Bool {
        // alpha
        let alphaL = lhs._alpha
            ?? preference._alpha
            ?? AppNavigationBarOption.default.alpha
        let alphaR = rhs._alpha
            ?? preference._alpha
            ?? AppNavigationBarOption.default.alpha

        // backgroundEffect
        let backgroundEffectL = lhs._backgroundEffect
            ?? preference._backgroundEffect
            ?? AppNavigationBarOption.default.backgroundEffect
        let backgroundEffectR = rhs._backgroundEffect
            ?? preference._backgroundEffect
            ?? AppNavigationBarOption.default.backgroundEffect

        // backgroundAlpha
        let backgroundAlphaL = lhs._backgroundAlpha
            ?? preference._backgroundAlpha
            ?? AppNavigationBarOption.default.backgroundAlpha
        let backgroundAlphaR = rhs._backgroundAlpha
            ?? preference._backgroundAlpha
            ?? AppNavigationBarOption.default.backgroundAlpha

        let isEqualAlpha = alphaL == alphaR
        let isEqualEffect = backgroundEffectL == backgroundEffectR
        let isEqualBackgroundAlpha = backgroundAlphaL == backgroundAlphaR

        // check is same option
        return isEqualAlpha && isEqualEffect && isEqualBackgroundAlpha
    }
}

/// AppNavigationBarOption (Effect)
public extension AppNavigationBarOption {
    /// Effect
    enum Effect: Equatable {
        /// blur effect
        case blur(UIBlurEffect.Style)

        /// image
        case image(UIImage?, UIView.ContentMode)

        /// color
        case color(UIColor)

        /// ==
        public static func == (lhs: Effect, rhs: Effect) -> Bool {
            if case let .blur(styleL) = lhs, case let .blur(styleR) = rhs {
                return styleL == styleR
            } else if case let .image(imageL, modeL) = lhs, case let .image(imageR, modeR) = rhs {
                return imageL?.pngData() == imageR?.pngData() && modeL == modeR
            } else if case let .color(colorL) = lhs, case let .color(colorR) = rhs {
                return colorL == colorR
            } else {
                return false
            }
        }
    }
}
