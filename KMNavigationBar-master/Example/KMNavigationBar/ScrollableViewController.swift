//
//  ScrollableViewController.swift
//  KMNavigationBar_Example
//
//  Created by KM on 2019/11/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import KMNavigationBar
import UIKit

class ScrollableViewController: UITableViewController, UIGestureRecognizerDelegate {
    deinit {
        debugPrint(classForCoder.description(), #function)
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 确保侧滑手势在有导航控制器的情况下才有效
        return navigationController?.viewControllers.count ?? 0 > 1
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.

        navigationItem.title = "ScrollableViewController"

        let color = AppDelegate.shared!.colors.randomElement()!
        view.backgroundColor = color

        let customButton = UIButton(type: .system)
        customButton.setTitle("自定义返回", for: .normal)
        customButton.setImage(UIImage(named: "icon_back"), for: .normal)
        customButton.tintColor = .white

        // 为按钮添加点击事件
        customButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // 将自定义按钮用作 UIBarButtonItem 的 customView
        let backButtonItem = UIBarButtonItem(customView: customButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let (section, row) = (indexPath.section, indexPath.row)
        guard let slider = cell.contentView.viewWithTag(999) as? UISlider else {
            return
        }
        var selector: Selector?
        switch (section, row) {
        case (1, 0):
            selector = #selector(backgroundAlpha(sender:))
        case (1, 1):
            selector = #selector(shadowImageAlpha(sender:))
        case (1, 2):
            selector = #selector(navigationBarAlpha(sender:))
        default:
            break
        }
        if let selector = selector {
            slider.addTarget(self, action: selector, for: .valueChanged)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (section, row, cell) = (indexPath.section, indexPath.row, tableView.cellForRow(at: indexPath))
        switch (section, row) {
        case (0, 0):
            let effect = AppDelegate.shared!.effects.randomElement()!
            switch effect.rawValue {
            case 0:
                cell?.detailTextLabel?.text = "UIBlurEffect.Style.extraLight"
            case 1:
                cell?.detailTextLabel?.text = "UIBlurEffect.Style.light"
            case 2:
                cell?.detailTextLabel?.text = "UIBlurEffect.Style.dark"
            default:
                break
            }
            navigationBarHelper.performUpdate { op in
                op.backgroundEffect = KMNavigationBarOption.Effect.blur(effect)
            }
        case (0, 1):
            let color = AppDelegate.shared!.colors.randomElement()!
            cell?.detailTextLabel?.text = "\(color)"
            navigationBarHelper.performUpdate { op in
                op.backgroundEffect = KMNavigationBarOption.Effect.color(color)
            }
        case (0, 2):
            let image = AppDelegate.shared!.images.randomElement()!
            if let imageV = cell?.contentView.viewWithTag(999) as? UIImageView {
                imageV.image = image
            }
            navigationBarHelper.performUpdate { op in
                op.backgroundEffect = KMNavigationBarOption.Effect.image(image, UIView.ContentMode.scaleAspectFill)
            }
        case (2, 0):
            let color = AppDelegate.shared!.colors.randomElement()!
            cell?.detailTextLabel?.text = "\(color)"
            navigationBarHelper.performUpdate { op in
                op.tintColor = color
            }
        case (2, 1):
            navigationBarHelper.performUpdate { op in
                op.isWhiteBarStyle?.toggle()
                cell?.detailTextLabel?.text = String(describing: op.isWhiteBarStyle)
            }
        case (2, 2):
            let color = AppDelegate.shared!.colors.randomElement()!
            cell?.detailTextLabel?.text = "\(color)"
            view.backgroundColor = color
        case (3, 0):
            let vc = AppDelegate.shared!.scrollableVc!
            navigationController?.pushViewController(vc, animated: true)
        case (3, 1):
            let vc = AppDelegate.shared!.mainVc!
            navigationController?.pushViewController(vc, animated: true)
        case (4, 0):
            let vc = AppDelegate.shared!.scrollableVc!
            let navVc = UINavigationController(rootViewController: vc, preference: nil)
            // navVc.modalPresentationStyle = .fullScreen
            present(navVc, animated: true, completion: nil)
        case (4, 1):
            let vc = AppDelegate.shared!.mainVc!
            let navVc = UINavigationController(rootViewController: vc, preference: nil)
            // navVc.modalPresentationStyle = .fullScreen
            present(navVc, animated: true, completion: nil)
        default:
            break
        }
    }

    @objc
    func backgroundAlpha(sender: UISlider) {
        updateText(sender: sender)
        navigationBarHelper.performUpdate { op in
            op.backgroundAlpha = CGFloat(sender.value)
        }
    }

    @objc
    func shadowImageAlpha(sender: UISlider) {
        updateText(sender: sender)
        navigationBarHelper.performUpdate { op in
            op.shadowImageAlpha = CGFloat(sender.value)
        }
    }

    @objc
    func navigationBarAlpha(sender: UISlider) {
        updateText(sender: sender)
        navigationBarHelper.performUpdate { op in
            op.alpha = CGFloat(sender.value)
        }
    }

    func updateText(sender: UISlider) {
        guard let cell = sender.superview?.superview as? UITableViewCell else { return }
        cell.detailTextLabel?.text = String(format: "%.1f", sender.value)
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
