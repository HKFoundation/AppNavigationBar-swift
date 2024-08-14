//
//  ViewController.swift
//  KMNavigationBar
//
//  Created by km on 11/05/2019.
//  Copyright (c) 2019 km. All rights reserved.
//

import KMNavigationBar
import UIKit

class ViewController: UIViewController {
    deinit {
        debugPrint(classForCoder.description(), #function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        navigationItem.title = "ViewController"
//        navigationItem.backButtonTitle = "啦啦啦"

        // 设置自定义返回按钮
        // 创建一个按钮
        let customButton = UIButton(type: .system)
        customButton.setTitle("自定义返回", for: .normal)
        customButton.setImage(UIImage(named: "new_back_black"), for: .normal)
        customButton.tintColor = .red

        // 为按钮添加点击事件
//            customButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // 将自定义按钮用作 UIBarButtonItem 的 customView
        let backButtonItem = UIBarButtonItem(customView: customButton)
        navigationItem.leftBarButtonItem = backButtonItem

        if AppDelegate.shared!.isRandomTintColor {
            let color = AppDelegate.shared!.colors.randomElement()!
            navigationBarHelper.performUpdate { op in
                op.tintColor = UIColor.white
            }
        }

        if AppDelegate.shared!.isRandomBackgroundColor {
            let color = AppDelegate.shared!.colors.randomElement()!
            navigationBarHelper.performUpdate { op in
                op.backgroundEffect = .color(color)
            }
        }

        if navigationController?.navigationProxy.delegate == nil {
            navigationController?.navigationProxy.delegate = self
        }

        let button = UIButton(type: .custom)
        button.frame = .init(x: 0, y: 0, width: 44, height: 44)
        button.setTitle("present", for: .normal)
        button.addTarget(self, action: #selector(presentNextViewController), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    @objc func presentNextViewController() {
        let vc = AppDelegate.shared!.mainVc!
        let navVc = UINavigationController(rootViewController: vc, preference: nil)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        debugPrint(self, #function)
    }
}
