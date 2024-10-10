//
//  AppNavigationTransition.swift
//  AppUIKit
//
//  Created by bormil on 2024/8/1.
//  Copyright © 2024 深眸科技（北京）有限公司. All rights reserved.
//

import UIKit

class AppNavigationTransition: NSObject {
    weak var navigationController: UINavigationController?
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }

    func transitionWillShow(viewController: UIViewController) {
        guard let preference = navigationController?.preference else {
            return
        }
        guard let bar = navigationController?.navigationBar as? AppNavigationBar else {
            return
        }
        guard let coordinator = navigationController?.transitionCoordinator else {
            bar.configUpdateToOption(viewController.navigation.option)
            return
        }
        coordinator.animate(alongsideTransition: { ctx in
            guard var from = ctx.viewController(forKey: .from),
                  var to = ctx.viewController(forKey: .to) else {
                return
            }

            from = from.configExcludeNavigationController()
            to = to.configExcludeNavigationController()

            let isEqual = AppNavigationBarOption.isEqual(lhs: from.navigation.option, rhs: to.navigation.option, preference: preference)
            if isEqual == false {
                // add fromFakeBar to from view controller
                bar.addFromFakeBar(viewController: from)

                // add toFakeBar to to view controller
                bar.addToFakeBar(viewController: to)

                // hidden backgroundFakeBar
                bar.isBackgroundFakeBarHidden = true
            }
            bar.configUpdateToOption(to.navigation.option)
        }) { ctx in
            if ctx.isCancelled, var from = ctx.viewController(forKey: .from) {
                from = from.configExcludeNavigationController()

                // rollback navigationBar and fakeBar option if transition is cancelled
                bar.configUpdateToOption(from.navigation.option)
            }
            // remove fromFakeBar and toFakeBar from superview
            bar.removeTransitionFakeBar()

            // show fakeBar
            bar.isBackgroundFakeBarHidden = false
        }
    }
}

fileprivate extension UIViewController {
    func configExcludeNavigationController() -> UIViewController {
        guard let navigation = self as? UINavigationController, let vc = navigation.viewControllers.last else { return self }
        return vc
    }
}
