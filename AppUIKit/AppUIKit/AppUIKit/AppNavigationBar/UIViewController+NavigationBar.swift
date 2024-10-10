//
//  UIViewController+NavigationBar.swift
//  AppUIKit
//
//  Created by bormil on 2024/8/1.
//  Copyright © 2024 深眸科技（北京）有限公司. All rights reserved.
//

import UIKit

public extension UIViewController {
    var navigation: AppNavigationBarHelper {
        if let helper: AppNavigationBarHelper = associatedObject(for: &UIViewController.barHelperKey) {
            return helper
        } else {
            let helper = AppNavigationBarHelper(viewController: self)
            setAssociatedObject(helper, forKey: &UIViewController.barHelperKey, policy: .retain)
            return helper
        }
    }

    /// barHelperKey
    private static var barHelperKey: Void?
}

public class AppNavigationBarHelper: NSObject {
    public fileprivate(set) var option: AppNavigationBarOption = AppNavigationBarOption.default.option() // ()
    fileprivate weak var viewController: UIViewController?
    fileprivate weak var navigationBar: UINavigationBar?
    required init(viewController: UIViewController) {
        self.viewController = viewController
        navigationBar = viewController.navigationController?.navigationBar
        if let preference = viewController.navigationController?.preference.mutableCopy() as? AppNavigationBarOption {
            option = preference
        }
        super.init()
    }

    public func perform(_ update: ((AppNavigationBarOption) -> Void)? = nil) {
        guard let bar = navigationBar as? AppNavigationBar else {
            return
        }
        update?(option)
        bar.configUpdateToOption(option)
    }
}
