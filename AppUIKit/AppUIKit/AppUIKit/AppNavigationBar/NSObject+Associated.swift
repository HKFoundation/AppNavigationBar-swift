//
//  NSObject+Associated.swift
//  AppUIKit
//
//  Created by bormil on 2024/8/1.
//  Copyright © 2024 深眸科技（北京）有限公司. All rights reserved.
//

import Foundation
import ObjectiveC.runtime

public enum AssociationPolicy {
    case assign
    case retain
    case copy

    fileprivate var policy: objc_AssociationPolicy {
        switch self {
        case .assign: return .OBJC_ASSOCIATION_ASSIGN
        case .retain: return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        case .copy: return .OBJC_ASSOCIATION_COPY_NONATOMIC
        }
    }
}

public extension NSObjectProtocol {
    func setAssociatedObject(_ object: Any?, forKey key: UnsafeRawPointer, policy: AssociationPolicy = .retain) {
        objc_setAssociatedObject(self, key, object, policy.policy)
    }

    func associatedObject<T>(for key: UnsafeRawPointer, create: (() -> T?)? = nil) -> T? {
        var object = objc_getAssociatedObject(self, key) as? T
        if object == nil, let creator = create {
            object = creator()
            setAssociatedObject(object, forKey: key)
        }
        return object
    }
}
