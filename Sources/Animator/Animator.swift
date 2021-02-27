//
//  Animator.swift
//  AnimatorChainDemo
//
//  Created by 罗树新 on 2021/2/26.
//

import Foundation
import QuartzCore
import UIKit

public class Animator {

    private lazy var step: Animator.Step = Animator.Step()
    
    public lazy var chain: Animator.Chain = Animator.Chain()
    
    public lazy var keyframe: Animator.Keyframes = Animator.Keyframes()
    
    public func transition(from view: UIView) -> Animator.Transition {
        Animator.Transition(view)
    }
    
    public func perform(animation: UIView.SystemAnimation) -> Animator.Perform {
        Animator.Perform(animation)
    }
   
    public enum KeyPath: String {
        case scale = "transform.scale"
        case scaleX = "transform.scale.x"
        case scaleY = "transform.scale.y"
        case scaleZ = "transform.scale.z"
        case rotationX = "transform.rotation.x"
        case rotationY = "transform.rotation.y"
        case rotationZ = "transform.rotation.z"
        case opacity
        case margin
        case zPosition
        case backgroundColor
        case cornerRadius
        case borderWidth
        case bounds
        case contents
        case contentsRect
        case frame
        case hidden
        case mask
        case masksToBounds
        case position
        case shadowColor
        case shadowOffset
        case shadowOpacity
        case shadowRadius
    }
    
    public enum TransitionType {
        case pageCurl
        case pageUnCurl
        case rippleEffect
        case suckEffect
        case cube
        case oglFlip
        case cameraIrisHollowOpen
        case cameraIrisHollowClose
        case fade
        case moveIn
        case push
        case reveal
        
        var transitionType: CATransitionType {
            switch self {
            case .pageCurl: return CATransitionType(rawValue: "pageCurl")
            case .pageUnCurl: return CATransitionType(rawValue: "pageUnCurl")
            case .rippleEffect: return CATransitionType(rawValue: "rippleEffect")
            case .suckEffect: return CATransitionType(rawValue: "suckEffect")
            case .cube: return CATransitionType(rawValue: "cube")
            case .oglFlip: return CATransitionType(rawValue: "oglFlip")
            case .cameraIrisHollowOpen: return CATransitionType(rawValue: "cameraIrisHollowOpen")
            case .cameraIrisHollowClose: return CATransitionType(rawValue: "cameraIrisHollowClose")
            case .fade: return CATransitionType.fade
            case .moveIn: return CATransitionType.moveIn
            case .push: return CATransitionType.push
            case .reveal: return CATransitionType.reveal
            }
        }
    }
    
    private class Step {
        
        fileprivate(set) var duration: TimeInterval = 0.25
        
        fileprivate(set) var delay: TimeInterval = 0.0
        
        fileprivate(set) var dampingRatio: CGFloat?
        
        fileprivate(set) var velocity: CGFloat?

        fileprivate(set) var options: UIView.AnimationOptions = .curveEaseInOut
                
        fileprivate(set) var animation: () -> Void = {}
        
        fileprivate(set) var completion: ((Bool) -> Void)?
    }
    
    public class Transition {
        
        init(_ view: UIView) {
            self.fromView = view
        }
        
        fileprivate(set) var duration: TimeInterval = 0.25
        
        fileprivate(set) var fromView: UIView
        
        fileprivate(set) var toView: UIView?

        fileprivate(set) var options: UIView.AnimationOptions = .curveEaseInOut
                
        fileprivate(set) var animation: (() -> Void)?
        
        fileprivate(set) var completion: ((Bool) -> Void)?
    }
    
    @available(iOS 7.0, *)
    public class Perform {
        
        init(_ animation: UIView.SystemAnimation) {
            self.animation = animation
        }
        
        fileprivate(set) var animation: UIView.SystemAnimation
        
        fileprivate(set) var views: [UIView]?
        
        fileprivate(set) var options: UIView.AnimationOptions = []
        
        fileprivate(set) var animations: (() -> Void)?
        
        fileprivate(set) var completion: ((Bool) -> Void)? = nil
        
        func run() {
            DispatchQueue.main.async {
                if let views = self.views, views.count > 0 {
                    UIView.perform(self.animation, on: views, options: self.options, animations: self.animations, completion: self.completion)
                }
            }
        }
    }
    
    @available(iOS 12.0, *)
    public class Modify {
        
        fileprivate(set) var repeatCount: CGFloat = 1
        
        fileprivate(set) var autoreverses: Bool = true

        fileprivate(set) var animations: (() -> Void)?

    }
    
    
    
    @available(iOS 7.0, *)
    public class Keyframes {
        
        fileprivate(set) var steps: [Animator.Keyframes.Step] = []
        
        fileprivate(set) var duration: TimeInterval = 0.25

        fileprivate(set) var delay: TimeInterval = 0.0

        fileprivate(set) var options: UIView.KeyframeAnimationOptions = []

        fileprivate(set) var completion: ((Bool) -> Void)? = nil
        
        public class Step {
            
            fileprivate(set) var startTime: Double = 0.0

            fileprivate(set) var duration: Double = 0.0

            fileprivate(set) var animations: () -> Void = {}
        }
    }
    
    
    public class Chain {
        
        private var steps: [Animator.Step] = []

        var step: Animator.Chain {
            let s = Animator.Step()
            self.steps.append(s)
            return self
        }
    }
    
}

public extension Animator {
    
    @available(iOS 4.0, *)
    @discardableResult func duration(_ duration: TimeInterval) -> Self {
        step.duration = duration
        return self
    }
    
    @available(iOS 4.0, *)
    @discardableResult func delay(_ delay: TimeInterval) -> Self {
        step.delay = delay
        return self
    }
    
    @available(iOS 7.0, *)
    @discardableResult func dampingRatio(_ dampingRatio: CGFloat) -> Self {
        step.dampingRatio = dampingRatio
        return self
    }
    
    @available(iOS 7.0, *)
    @discardableResult func velocity(_ velocity: CGFloat) -> Self {
        step.velocity = velocity
        return self
    }
    
    @available(iOS 4.0, *)
    @discardableResult func options(_ options: UIView.AnimationOptions) -> Self {
        step.options = options
        return self
    }
    
    @available(iOS 4.0, *)
    @discardableResult func animation(_ animation: @escaping () -> Void) -> Self {
        step.animation = animation
        return self
    }
    
    @available(iOS 4.0, *)
    @discardableResult func completion(_ completion: ((Bool) -> Void)? = nil) -> Self {
        step.completion = completion
        return self
    }
     
     func run() {
        DispatchQueue.main.async {
            if let dampingRatio = self.step.dampingRatio, let velocity = self.step.velocity {
                UIView.animate(withDuration: self.step.duration, delay: self.step.delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: self.step.options, animations: self.step.animation, completion: self.step.completion)
            } else {
                UIView.animate(withDuration: self.step.duration, delay: self.step.delay, options: self.step.options, animations: self.step.animation, completion: self.step.completion)
            }
        }
     }
}

public extension Animator.Transition {
    @available(iOS 4.0, *)
    @discardableResult func duration(_ duration: TimeInterval) -> Self {
        self.duration = duration
        return self
    }
    
    @available(iOS 4.0, *)
    @discardableResult func to(view: UIView) -> Self {
        self.toView = view
        return self
    }
    
    @available(iOS 4.0, *)
    @discardableResult func options(_ options: UIView.AnimationOptions) -> Self {
        self.options = options
        return self
    }
    
    @available(iOS 4.0, *)
    @discardableResult func animation(_ animation: @escaping () -> Void) -> Self {
        self.animation = animation
        return self
    }
    
    @available(iOS 4.0, *)
    @discardableResult func completion(_ completion: ((Bool) -> Void)? = nil) -> Self {
        self.completion = completion
        return self
    }
    
    func run() {
       DispatchQueue.main.async {
        if let view = self.toView {
            UIView.transition(from: self.fromView, to: view, duration: self.duration, options: self.options, completion: self.completion)
        } else if let animation = self.animation {
            UIView.transition(with: self.fromView, duration: self.duration, options: self.options, animations: animation, completion: self.completion)
        }
       }
    }
}

public extension Animator.Chain {
    
    @available(iOS 4.0, *)
    @discardableResult func duration(_ duration: TimeInterval) -> Self {
        if let step = steps.last {
            step.duration = duration
        }
        return self
    }
    
    @available(iOS 4.0, *)
    @discardableResult func delay(_ delay: TimeInterval) -> Self {
        if let step = steps.last {
            step.delay = delay
        }
        return self
    }
    
    @available(iOS 7.0, *)
    @discardableResult func dampingRatio(_ dampingRatio: CGFloat) -> Self {
        if let step = steps.last {
            step.dampingRatio = dampingRatio
        }
        return self
    }
    
    @available(iOS 7.0, *)
    @discardableResult func velocity(_ velocity: CGFloat) -> Self {
        if let step = steps.last {
            step.velocity = velocity
        }
        return self
    }
    
    @available(iOS 4.0, *)
    @discardableResult func options(_ options: UIView.AnimationOptions) -> Self {
        if let step = steps.last {
            step.options = options
        }
        return self
    }
    
    @available(iOS 4.0, *)
    @discardableResult func animation(_ animation: @escaping () -> Void) -> Self {
        if let step = steps.last {
            step.animation = animation
        }
        return self
    }

    @available(iOS 4.0, *)
    @discardableResult func completion(_ completion: ((Bool) -> Void)? = nil) -> Self {
        if let step = steps.last {
            step.completion = completion
        }
        return self
    }
    
    func run(_ completion:(() -> Void)? = nil) {
        
        guard let step = steps.first else {
            completion?()
            return
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: step.duration, delay: step.delay, options: step.options, animations: step.animation) { (finish) in
                if finish == true {
                    step.completion?(finish)
                    self.steps.removeFirst()
                    self.run(completion)
                }
            }
        }
    }
}

@available(iOS 7.0, *)
public extension Animator.Perform {

    @discardableResult func on(views: [UIView]) -> Self {
        self.views = views
        return self
    }
    
    @discardableResult func options(_ options: UIView.AnimationOptions) -> Self {
        self.options = options
        return self
    }
    
    @discardableResult func animations(_ animations: (() -> Void)?) -> Self {
        self.animations = animations
        return self
    }
    
    @discardableResult func completion(_ completion: ((Bool) -> Void)? = nil) -> Self {
        self.completion = completion
        return self
    }
}


@available(iOS 12.0, *)
public extension Animator.Modify {
    
    @discardableResult func repeatCount(_ count: CGFloat) -> Self {
        self.repeatCount = repeatCount
        return self
    }
    
    @discardableResult func autoreverses(_ autoreverses: Bool) -> Self {
        self.autoreverses = autoreverses
        return self
    }
    
    @discardableResult func animations(_ animations: (() -> Void)?) -> Self {
        self.animations = animations
        return self
    }

}

@available(iOS 7.0, *)
public extension Animator.Keyframes {
    
    @discardableResult func duration(_ duration: TimeInterval) -> Self {
        self.duration = duration
        return self
    }
    
    @discardableResult func delay(_ delay: TimeInterval) -> Self {
        self.delay = delay
        return self
    }
    
    @discardableResult func options(_ options: UIView.KeyframeAnimationOptions) -> Self {
        self.options = options
        return self
    }
    
    @discardableResult func completion(_ completion: ((Bool) -> Void)? = nil) -> Self {
        self.completion = completion
        return self
    }
    
    func animations(_ closure: (Animator.Keyframes) -> Void) -> Self {
        closure(self)
        return self
    }
    
    var step: Animator.Keyframes.Step {
        let step = Animator.Keyframes.Step()
        steps.append(step)
        return step
    }

    func run() {
        DispatchQueue.main.async {
            UIView.animateKeyframes(withDuration: self.duration, delay: self.delay, options: self.options, animations: {
                self.steps.forEach { (step) in
                    UIView.addKeyframe(withRelativeStartTime: step.startTime, relativeDuration: step.duration, animations: step.animations)
                }
            }, completion: self.completion)

        }
    }
}

@available(iOS 7.0, *)
public extension Animator.Keyframes.Step {

    @discardableResult func startTime(_ startTime: Double) -> Self {
        self.startTime = startTime
        return self
    }
    
    @discardableResult func duration(_ duration: Double) -> Self {
        self.duration = duration
        return self
    }
    
    @discardableResult func animations(_ animations: @escaping () -> Void) -> Self {
        self.animations = animations
        return self
    }
    
}

public extension Animator {
    
    var animation: CAAnimator<CAAnimation> {
        let animation = CAAnimation()
        return CAAnimator<CAAnimation>(animation)
    }
    
    @discardableResult func basic(_ keyPath: Animator.KeyPath) -> CAAnimator<CABasicAnimation> {
        let scale = CABasicAnimation(keyPath: keyPath.rawValue)
        return CAAnimator<CABasicAnimation>(scale)
    }
    
    @discardableResult func keyframe(_ keyPath: Animator.KeyPath) -> CAAnimator<CAKeyframeAnimation> {
        let scale = CAKeyframeAnimation(keyPath: keyPath.rawValue)
        return CAAnimator<CAKeyframeAnimation>(scale)
    }
    
    @discardableResult func transition(_ type: Animator.TransitionType) -> CAAnimator<CATransition> {
        let transition = CATransition()
        transition.type = type.transitionType
        return CAAnimator<CATransition>(transition)
    }
    
    @discardableResult func spring(_ keyPath: Animator.KeyPath) -> CAAnimator<CASpringAnimation> {
        let spring = CASpringAnimation(keyPath: keyPath.rawValue)
        return CAAnimator<CASpringAnimation>(spring)
    }
    
    @discardableResult func property(_ keyPath: Animator.KeyPath) -> CAAnimator<CAPropertyAnimation> {
        let property = CAPropertyAnimation(keyPath: keyPath.rawValue)
        return CAAnimator<CAPropertyAnimation>(property)
    }
    
    @discardableResult func group(_ clourse: (GroupMaker) -> Void) -> CAAnimator<CAAnimationGroup> {
        let maker = GroupMaker()
        clourse(maker)
        let group = CAAnimationGroup()
        group.animations = maker.animations
        return CAAnimator<CAAnimationGroup>(group)
    }
}

