//
//  AppNavigationBar.swift
//  AppUIKit
//
//  Created by bormil on 2024/8/1.
//  Copyright © 2024 深眸科技（北京）有限公司. All rights reserved.
//

import UIKit

class AppNavigationBar: UINavigationBar {
    internal var preference: AppNavigationBarOption?

    /// isBackgroundFakeBarHidden
    var isBackgroundFakeBarHidden: Bool {
        get { return fakeBar.isHidden }
        set {
            fakeBar.isHidden = newValue
        }
    }

    /* ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄*
     * // MARK: - 导航栏私有属性
     * ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄*/

    /// _tintColor
    private var _tintColor: UIColor = AppNavigationBarOption.default.tintColor {
        didSet { tintColor = _tintColor }
    }

    /// _barStyle
    private var _barStyle: UIBarStyle = AppNavigationBarOption.default.isWhiteBarStyle ? .black : .default {
        didSet { barStyle = _barStyle }
    }

    /// _alpha
    private var _alpha: CGFloat = AppNavigationBarOption.default.alpha {
        didSet { alpha = _alpha }
    }

    /// _option
    private var _option: AppNavigationBarOption?

    /// fakeBar
    private lazy var fakeBar = AppFakeBarView()

    private lazy var fromFakeBar = AppFakeBarView()

    private lazy var toFakeBar = AppFakeBarView()

    private var from: UIViewController?

    private var to: UIViewController?

    private var displayLink: CADisplayLink?

    /* ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄*
     * // MARK: - 重写系统属性
     * ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄*/

    /// tintColor
    override var tintColor: UIColor! {
        get { return super.tintColor }
        set { super.tintColor = self._tintColor }
    }

    /// barStyle
    override var barStyle: UIBarStyle {
        get { return super.barStyle }
        set { super.barStyle = self._barStyle }
    }

    /// alpha
    override var alpha: CGFloat {
        get { return super.alpha }
        set { super.alpha = self._alpha }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        displayLink = CADisplayLink(target: self, selector: #selector(refreshDisplay))
        displayLink?.add(to: .main, forMode: .common)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        guard let bgView = backgroundView() else {
            return
        }
        bgView.backgroundColor = .clear
        fakeBar.frame = bgView.bounds
    }
}

extension AppNavigationBar {
    func configUpdateToOption(_ option: AppNavigationBarOption) {
        _option = option
        fakeBar.configUpdateToOption(option, preference: preference)

        let tintColor = option._tintColor
            ?? preference?._tintColor
            ?? AppNavigationBarOption.default.tintColor
        _tintColor = tintColor

        let isWhiteBarStyle = option._isWhiteBarStyle
            ?? preference?._isWhiteBarStyle
            ?? AppNavigationBarOption.default.isWhiteBarStyle
        if isWhiteBarStyle {
            _barStyle = .black
        } else {
            _barStyle = .default
        }

        let alpha = option._alpha
            ?? preference?._alpha
            ?? AppNavigationBarOption.default.alpha
        _alpha = alpha

        removeWhiteCoverWhenNotTranslucent()
    }
}

extension AppNavigationBar {
    func removeTransitionFakeBar() {
        fromFakeBar.removeFromSuperview()
        toFakeBar.removeFromSuperview()

        from = nil
        to = nil
    }

    func addFromFakeBar(viewController from: UIViewController) {
        self.from = from
        addFakeBar(fake: fromFakeBar, to: from)
    }

    func addToFakeBar(viewController to: UIViewController) {
        self.to = to
        addFakeBar(fake: toFakeBar, to: to)
    }

    /// add fakeBar to view controller
    private func addFakeBar(fake: AppFakeBarView, to viewController: UIViewController) {
        guard let preference = preference else { return }
        let option = viewController.navigation.option
        UIView.performWithoutAnimation {
            removeWhiteCoverWhenNotTranslucent()

            fake.configUpdateToOption(viewController.navigation.option, preference: preference)
            if viewController.view.isKind(of: UIScrollView.self) || viewController.edgesForExtendedLayout == UIRectEdge(rawValue: 0) {
                viewController.view.clipsToBounds = false
            }

            // 因为这里的 FakeBar 加在控制器视图上 不是加在导航栏上 还要考虑原来导航栏的透明度
            let alpha = option._alpha ?? preference._alpha ?? AppNavigationBarOption.default.alpha
            let backgroundAlpha = option._backgroundAlpha ?? preference._backgroundAlpha ?? AppNavigationBarOption.default.backgroundAlpha
            let shadowImageAlpha = option._shadowImageAlpha ?? preference._shadowImageAlpha ?? AppNavigationBarOption.default.shadowImageAlpha

            fake.contentView.alpha = alpha * backgroundAlpha
            fake.shadowImageView.alpha = alpha * shadowImageAlpha

            viewController.view.addSubview(fake)
        }
    }
}

private extension AppNavigationBar {
    func backgroundView() -> UIView? {
        return subviews.first(where: {
            $0.isUIbarBackground() || $0.isUINavigationBarBackground()
        })
    }

    func removeWhiteCoverWhenNotTranslucent() {
        guard isTranslucent == false else {
            return
        }
        configHideColorView(true)
    }

    func recoverWhiteCoverWhenNotTranslucent() {
        guard isTranslucent == false else {
            return
        }
        configHideColorView(false)
    }

    func configHideColorView(_ hide: Bool) {
        fakeBar.superview?.subviews.filter({
            $0 != fakeBar
        }).forEach({
            if let _ = $0.backgroundColor {
                $0.isHidden = hide
            }
        })
    }

    @objc func refreshDisplay() {
        if let view = fakeBar.superview {
            let rect = view.bounds
            if !fakeBar.frame.equalTo(rect) {
                fakeBar.frame = rect
            }

            if fromFakeBar.superview != nil,
               let from = from {
                var fakeFrame = view.convert(rect, to: from.view)
                if !fakeFrame.equalTo(fromFakeBar.frame) {
                    fakeFrame.origin.x = fakeBar.frame.origin.x
                    fromFakeBar.frame = fakeFrame
                }
            }
            if toFakeBar.superview != nil,
               let to = to {
                var fakeFrame = view.convert(rect, to: to.view)
                if !fakeFrame.equalTo(toFakeBar.frame) {
                    fakeFrame.origin.x = fakeBar.frame.origin.x
                    toFakeBar.frame = fakeFrame
                }
            }
        }

        guard fakeBar.superview == nil else { return }
        guard let bgView = backgroundView() else {
            return
        }
        bgView.insertSubview(fakeBar, at: 0)
    }
}

fileprivate class AppFakeBarView: UIView {
    lazy var effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    lazy var colorView = UIView()

    lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        return view
    }()

    lazy var shadowImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black
        return view
    }()

    lazy var contentView: UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        backgroundColor = .clear
        addSubview(contentView)
        addSubview(shadowImageView)
        [effectView, backgroundImageView, colorView].forEach {
            $0.isUserInteractionEnabled = false
            $0.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
            contentView.addSubview($0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
        effectView.frame = contentView.bounds
        backgroundImageView.frame = contentView.bounds
        colorView.frame = contentView.bounds

        let shadowImageH = 1.0 / UIScreen.main.scale
        shadowImageView.frame = CGRect(
            x: 0,
            y: bounds.height - shadowImageH,
            width: bounds.width,
            height: shadowImageH
        )
    }

    func configUpdateToOption(_ option: AppNavigationBarOption, preference: AppNavigationBarOption?) {
        effectView.isHidden = true
        backgroundImageView.isHidden = true
        colorView.isHidden = true
        let backgroundEffect = option.backgroundEffect
            ?? preference?.backgroundEffect
            ?? AppNavigationBarOption.default.backgroundEffect
        switch backgroundEffect {
        case let .blur(b):
            effectView.effect = UIBlurEffect(style: b)
            effectView.isHidden = false
        case let .image(i, c):
            backgroundImageView.image = i
            backgroundImageView.contentMode = c
            backgroundImageView.isHidden = false
        case let .color(c):
            colorView.backgroundColor = c
            colorView.isHidden = false
        }

        // to background alpha
        let backgroundAlpha = option._backgroundAlpha
            ?? preference?._backgroundAlpha
            ?? AppNavigationBarOption.default.backgroundAlpha
        contentView.alpha = backgroundAlpha

        // to shadow image alpha
        let shadowImageAlpha = option._shadowImageAlpha
            ?? preference?._shadowImageAlpha
            ?? AppNavigationBarOption.default.shadowImageAlpha
        shadowImageView.alpha = shadowImageAlpha
    }
}

fileprivate extension UIView {
    func name() -> String {
        return classForCoder.description().replacingOccurrences(of: "_", with: "")
    }

    func isUIbarBackground() -> Bool {
        let name = name()
        return name.contains("UIbarBackground")
            || name.contains("UIBarBackground")
    }

    func isUINavigationBarBackground() -> Bool {
        let name = name()
        return name.contains("UINavigationBarBackground")
    }
}
