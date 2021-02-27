//
//  CAAnimator.swift
//  AnimatorChainDemo
//
//  Created by 罗树新 on 2021/2/26.
//

import Foundation

import QuartzCore

public class CAAnimator<Base> {
    var key: String = ProcessInfo.processInfo.globallyUniqueString

    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

extension CAAnimator {
    func make(_ clourse: (Base) -> Void) -> Self {
        clourse(self.base)
        return self
    }
}

public protocol CAAnimatorCompatible {}

public extension CAAnimatorCompatible {
    var Animator: CAAnimator<Self> { CAAnimator(self) }
}

public class GroupMaker {
    var animations: [CAAnimation] = []
    
    var animation: CAAnimator<CAAnimation> {
        let animation = CAAnimation()
        animations.append(animation)
        return CAAnimator<CAAnimation>(animation)

    }
    
    @discardableResult func basic(_ keyPath: Animator.KeyPath) -> CAAnimator<CABasicAnimation> {
        let basic = CABasicAnimation(keyPath: keyPath.rawValue)
        animations.append(basic)
        return CAAnimator<CABasicAnimation>(basic)
    }
    
    @discardableResult func keyframe(_ keyPath: Animator.KeyPath) -> CAAnimator<CAKeyframeAnimation> {
        let keyframe = CAKeyframeAnimation(keyPath: keyPath.rawValue)
        animations.append(keyframe)
        return CAAnimator<CAKeyframeAnimation>(keyframe)
    }
    
    @discardableResult func transition(_ type: Animator.TransitionType) -> CAAnimator<CATransition> {
        let transition = CATransition()
        transition.type = type.transitionType
        animations.append(transition)
        return CAAnimator<CATransition>(transition)
    }
    
    @discardableResult func spring(_ keyPath: Animator.KeyPath) -> CAAnimator<CASpringAnimation> {
        let spring = CASpringAnimation(keyPath: keyPath.rawValue)
        animations.append(spring)
        return CAAnimator<CASpringAnimation>(spring)
    }
    
    @discardableResult func property(_ keyPath: Animator.KeyPath) -> CAAnimator<CAPropertyAnimation> {
        let property = CAPropertyAnimation(keyPath: keyPath.rawValue)
        animations.append(property)
        return CAAnimator<CAPropertyAnimation>(property)
    }
    
    var group: CAAnimator<CAAnimationGroup> {
        let group = CAAnimationGroup()
        animations.append(group)
        return CAAnimator<CAAnimationGroup>(group)
    }
}
