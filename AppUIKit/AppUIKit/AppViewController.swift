//
//  AppViewController.swift
//  AppUIKit
//
//  Created by Code on 2020/9/15.
//  Copyright © 2020 北京卡友在线科技有限公司. All rights reserved.
//

import UIKit

class AppViewController: UITableViewController, UIGestureRecognizerDelegate {
    deinit {
        debugPrint(classForCoder.description(), #function)
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 确保侧滑手势在有导航控制器的情况下才有效
        return navigationController?.viewControllers.count ?? 0 > 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        navigationItem.title = "AppViewController"

        navigationController?.interactivePopGestureRecognizer?.delegate = self

        navigationController?.navigationBar.barStyle = .black

        // 自定义返回按钮
        let pop = UIButton(type: .system)
        pop.setTitle("自定义返回", for: .normal)
        pop.setImage(UIImage(named: "arrow"), for: .normal)
        pop.tintColor = .white
        pop.addTarget(self, action: #selector(configPopEvent), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: pop)

        let color = AppDelegate.shared!.colors.randomElement()!
        view.backgroundColor = color
    }

    @objc func configPopEvent() {
        navigationController?.popViewController(animated: true)
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
            navigation.perform { op in
                op.backgroundEffect = AppNavigationBarOption.Effect.blur(effect)
            }
        case (0, 1):
            let color = AppDelegate.shared!.colors.randomElement()!
            cell?.detailTextLabel?.text = "\(color)"
            navigation.perform { op in
                op.backgroundEffect = AppNavigationBarOption.Effect.color(color)
            }
        case (0, 2):
            let image = AppDelegate.shared!.images.randomElement()!
            if let imageV = cell?.contentView.viewWithTag(999) as? UIImageView {
                imageV.image = image
            }
            navigation.perform { op in
                op.backgroundEffect = AppNavigationBarOption.Effect.image(image, UIView.ContentMode.scaleAspectFill)
            }
        case (2, 0):
            let color = AppDelegate.shared!.colors.randomElement()!
            cell?.detailTextLabel?.text = "\(color)"
            navigation.perform { op in
                op.tintColor = color
            }
        case (2, 1):
            navigation.perform { op in
                op.isWhiteBarStyle?.toggle()
                cell?.detailTextLabel?.text = String(describing: op.isWhiteBarStyle)
            }
        case (2, 2):
            let color = AppDelegate.shared!.colors.randomElement()!
            cell?.detailTextLabel?.text = "\(color)"
            view.backgroundColor = color
        case (3, 0):
            let vc = AppViewController()
            navigationController?.pushViewController(vc, animated: true)
        case (3, 1):
            let vc = AppViewController()
            navigationController?.pushViewController(vc, animated: true)
        case (4, 0):
            let vc = AppViewController()
            let navVc = UINavigationController(rootViewController: vc, preference: nil)
            present(navVc, animated: true, completion: nil)
        case (4, 1):
            let vc = AppViewController()
            let navVc = UINavigationController(rootViewController: vc, preference: nil)
            present(navVc, animated: true, completion: nil)
        default:
            break
        }
    }

    @objc
    func backgroundAlpha(sender: UISlider) {
        updateText(sender: sender)
        navigation.perform { op in
            op.backgroundAlpha = CGFloat(sender.value)
        }
    }

    @objc
    func shadowImageAlpha(sender: UISlider) {
        updateText(sender: sender)
        navigation.perform { op in
            op.shadowImageAlpha = CGFloat(sender.value)
        }
    }

    @objc
    func navigationBarAlpha(sender: UISlider) {
        updateText(sender: sender)
        navigation.perform { op in
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
