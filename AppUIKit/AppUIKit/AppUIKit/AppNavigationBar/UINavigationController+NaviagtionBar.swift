//
//  UINavigationController+NaviagtionBar.swift
//  AppUIKit
//
//  Created by bormil on 2024/8/1.
//  Copyright © 2024 深眸科技（北京）有限公司. All rights reserved.
//

import UIKit

public extension UINavigationController {
    typealias Preference = (AppNavigationBarOption) -> Void
    /// init with preference option
    convenience init(preference: Preference?) {
        self.init(viewControllers: [], toolbarClass: nil, preference: preference)
    }

    /// init with rootViewController and preference option
    convenience init(rootViewController: UIViewController, preference: Preference?) {
        self.init(viewControllers: [rootViewController], toolbarClass: nil, preference: preference)
    }

    /// init with viewControllers and preference option
    convenience init(viewControllers: [UIViewController], preference: Preference?) {
        self.init(viewControllers: viewControllers, toolbarClass: nil, preference: preference)
    }

    /// init with viewControllers, toolbarClass and preference option
    convenience init(viewControllers: [UIViewController], toolbarClass: AnyClass?, preference: Preference?) {
        // init
        self.init(navigationBarClass: AppNavigationBar.self, toolbarClass: toolbarClass)

        // config
        self.viewControllers = viewControllers
        preference?(self.preference)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        (navigationBar as? AppNavigationBar)?.preference = self.preference
        _ = navigationProxy
    }
}

extension UINavigationController {
    public var navigationProxy: AppNaviagtionBarProxy {
        if let proxy: AppNaviagtionBarProxy = associatedObject(for: &UINavigationController.navigationProxyKey) {
            return proxy
        } else {
            let proxy = AppNaviagtionBarProxy(navigationController: self)
            setAssociatedObject(proxy, forKey: &UINavigationController.navigationProxyKey, policy: .retain)
            return proxy
        }
    }

    var transition: AppNavigationTransition {
        if let transition: AppNavigationTransition = associatedObject(for: &UINavigationController.transitionKey) {
            return transition
        } else {
            let transition = AppNavigationTransition(navigationController: self)
            setAssociatedObject(transition, forKey: &UINavigationController.transitionKey, policy: .retain)
            return transition
        }
    }

    public var preference: AppNavigationBarOption {
        if let option: AppNavigationBarOption = associatedObject(for: &UINavigationController.preferenceKey) {
            return option
        } else {
            let option = AppNavigationBarOption.default.option()
            setAssociatedObject(option, forKey: &UINavigationController.preferenceKey, policy: .retain)
            return option
        }
    }

    /// navigationProxyKey
    private static var navigationProxyKey: Void?

    /// transitionKey
    private static var transitionKey: Void?

    /// preferenceKey
    private static var preferenceKey: Void?
}
