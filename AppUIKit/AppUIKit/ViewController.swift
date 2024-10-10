//
//  ViewController.swift
//  AppUIKit
//
//  Created by Code on 2020/9/15.
//  Copyright © 2020 北京卡友在线科技有限公司. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    deinit {
//        debugPrint(classForCoder.description(), #function)
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 确保侧滑手势在有导航控制器的情况下才有效
        return navigationController?.viewControllers.count ?? 0 > 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "ViewController"
        navigationController?.navigationBar.barStyle = .black
//        navigationController?.interactivePopGestureRecognizer?.delegate = self

        if AppDelegate.shared!.isRandomTintColor {
            let color = AppDelegate.shared!.colors.randomElement()!
            navigation.perform { op in
                op.tintColor = color
            }
        }

        if AppDelegate.shared!.isRandomBackgroundColor {
            let color = AppDelegate.shared!.colors.randomElement()!
            navigation.perform { op in
                op.backgroundEffect = .color(color)
            }
        }

        if navigationController?.navigationProxy.delegate == nil {
            navigationController?.navigationProxy.delegate = self
        }

        // 自定义返回按钮
        let pop = UIButton(type: .system)
        pop.setTitle("自定义", for: .normal)
        pop.setImage(UIImage(named: "arrow"), for: .normal)
        pop.tintColor = .red
        pop.addTarget(self, action: #selector(configPopEvent), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: pop)

        if AppDelegate.shared!.isRandomTintColor {
            let color = AppDelegate.shared!.colors.randomElement()!
            navigation.perform { op in
                op.tintColor = color
            }
        }

        if AppDelegate.shared!.isRandomBackgroundColor {
            let color = AppDelegate.shared!.colors.randomElement()!
            navigation.perform { op in
                op.backgroundEffect = .color(color)
            }
        }

        let present = UIButton(type: .custom)
        present.frame = .init(x: 0, y: 0, width: 44, height: 44)
        present.setTitle("present", for: .normal)
        present.addTarget(self, action: #selector(configPresentEvent), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: present)
    }

    @objc func configPopEvent() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }

    @objc func configPresentEvent() {
        let vc = AppDelegate.shared!.main!
        let navigation = UINavigationController(rootViewController: vc, preference: nil)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        debugPrint(self, #function)
    }
}
