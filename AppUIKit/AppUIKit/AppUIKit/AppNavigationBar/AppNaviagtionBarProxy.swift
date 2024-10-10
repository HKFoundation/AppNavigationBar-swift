//
//  AppNaviagtionBarProxy.swift
//  AppUIKit
//
//  Created by bormil on 2024/8/1.
//  Copyright © 2024 深眸科技（北京）有限公司. All rights reserved.
//

import UIKit

public class AppNaviagtionBarProxy: NSObject {
    public weak var delegate: UINavigationControllerDelegate?
    fileprivate weak var navigationController: UINavigationController?

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController?.delegate = self
    }
}

extension AppNaviagtionBarProxy: UINavigationControllerDelegate {
    /// forwarding message call to UINavigationController.delegate if self (Proxy) don't respond
    override public func responds(to aSelector: Selector!) -> Bool {
        if #selector(AppNaviagtionBarProxy.navigationController(_:willShow:animated:)) == aSelector {
            return true
        } else {
            return delegate?.responds(to: aSelector) ?? false
        }
    }

    override public func forwardingTarget(for aSelector: Selector!) -> Any? {
        return delegate
    }

    /* ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄*
     * // MARK: - UINavigationControllerDelegate
     * ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄＊ ┄┅┄┅┄┅┄┅┄*/

    @objc public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.transition.transitionWillShow(viewController: viewController)
        delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
}
