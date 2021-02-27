//
//  CAKeyFrameAnimator.swift
//  AnimatorChainDemo
//
//  Created by 罗树新 on 2021/2/26.
//

import QuartzCore

extension CAAnimation: CAAnimatorCompatible {}

public extension CAAnimator where Base: CAMediaTiming {
    @discardableResult func beginTime(_ beginTime: CFTimeInterval) -> Self {
        make { $0.beginTime = beginTime }
    }
    
    @discardableResult func duration(_ duration: CFTimeInterval) -> Self {
        make { $0.duration = duration }
    }
    
    @discardableResult func speed(_ speed: Float) -> Self {
        make { $0.speed = speed }
    }
    
    @discardableResult func timeOffset(_ timeOffset: CFTimeInterval) -> Self {
        make { $0.timeOffset = timeOffset }
    }
    
    @discardableResult func repeatCount(_ repeatCount: Float) -> Self {
        make { $0.repeatCount = repeatCount }
    }
    
    @discardableResult func repeatDuration(_ repeatDuration: CFTimeInterval) -> Self {
        make { $0.repeatDuration = repeatDuration }
    }
    
    @discardableResult func autoreverses(_ autoreverses: Bool) -> Self {
        make { $0.autoreverses = autoreverses }
    }

    @discardableResult func fillMode(_ fillMode: CAMediaTimingFillMode) -> Self {
        make { $0.fillMode = fillMode }
    }
}

@available(iOS 2.0, *)
public extension CAAnimator where Base: CAAnimation {
    
    @discardableResult func timingFunction(_ timingFunction: CAMediaTimingFunction?) -> Self {
        make { $0.timingFunction = timingFunction }
    }

    @discardableResult func didStart(_ clourse: ((CAAnimation) -> Void)?) -> Self {
        
        var delegate = base.delegate
        if delegate == nil {
            delegate = CAAnimationDelegateTarget(base)
            base.delegate = delegate
        }
        base.didStart = clourse
        return self
    }
    
    @discardableResult func didStop(_ clourse: ((CAAnimation, Bool) -> Void)?) -> Self {
        
        var delegate = base.delegate
        if delegate == nil {
            delegate = CAAnimationDelegateTarget(base)
            base.delegate = delegate
        }
        base.didStop = clourse
        return self
    }
    
    @discardableResult func isRemovedOnCompletion(_ isRemovedOnCompletion: Bool) -> Self {
        make { $0.isRemovedOnCompletion = isRemovedOnCompletion }
    }
    
    @discardableResult func add(to layer: CALayer) -> Self {
        make { layer.add($0, forKey: key) }
    }
    
    @discardableResult func remove(form layer: CALayer) -> Self {
        make { _ in layer.removeAnimation(forKey: key) }
    }
}

@available(iOS 2.0, *)
public extension CAAnimator where Base: CAPropertyAnimation {
    @discardableResult func isAdditive(_ isAdditive: Bool) -> Self {
        make { $0.isAdditive = isAdditive }
    }
    
    @discardableResult func isCumulative(_ isCumulative: Bool) -> Self {
        make { $0.isCumulative = isCumulative }
    }
    
    @discardableResult func valueFunction(_ valueFunction: CAValueFunction?) -> Self {
        make { $0.valueFunction = valueFunction }
    }
}

@available(iOS 2.0, *)
public extension CAAnimator where Base: CABasicAnimation {
    
    @discardableResult func fromValue(_ fromValue: Any?) -> Self {
        make { $0.fromValue = fromValue }
    }
    
    @discardableResult func toValue(_ toValue: Any?) -> Self {
        make { $0.toValue = toValue }
    }
    
    @discardableResult func byValue(_ byValue: Any?) -> Self {
        make { $0.byValue = byValue }
    }

}

@available(iOS 2.0, *)
public extension CAAnimator where Base: CAKeyframeAnimation {
    
    @discardableResult func duration(_ duration: TimeInterval) -> Self {
        make { $0.duration = duration }
    }
    
    @discardableResult func values(_ values: [Any]?) -> Self {
        make { $0.values = values }
    }
    
    @discardableResult func path(_ path: CGPath?) -> Self {
        make { $0.path = path }

    }
    
    @discardableResult func keyTimes(_ keyTimes: [NSNumber]?) -> Self {
        make { $0.keyTimes = keyTimes }
    }
    
    @discardableResult func timingFunctions(_ timingFunctions: [CAMediaTimingFunction]?) -> Self {
        make { $0.timingFunctions = timingFunctions }
    }
    
    @discardableResult func calculationMode(_ calculationMode: CAAnimationCalculationMode) -> Self {
        make { $0.calculationMode = calculationMode }
    }

    @discardableResult func tensionValues(_ tensionValues: [NSNumber]?) -> Self {
        make { $0.tensionValues = tensionValues }
    }
    
    @discardableResult func continuityValues(_ continuityValues: [NSNumber]?) -> Self {
        make { $0.continuityValues = continuityValues }
    }
    
    @discardableResult func biasValues(_ biasValues: [NSNumber]?) -> Self {
        make { $0.biasValues = biasValues }
    }

    @discardableResult func rotationMode(_ rotationMode: CAAnimationRotationMode?) -> Self {
        make { $0.rotationMode = rotationMode }
    }
}

@available(iOS 9.0, *)
public extension CAAnimator where Base: CASpringAnimation {
    
    @discardableResult func mass(_ mass: CGFloat) -> Self {
        make { $0.mass = mass }
    }
    
    @discardableResult func stiffness(_ stiffness: CGFloat) -> Self {
        make { $0.stiffness = stiffness }
    }
    
    @discardableResult func damping(_ damping: CGFloat) -> Self {
        make { $0.damping = damping }
    }
    
    @discardableResult func initialVelocity(_ initialVelocity: CGFloat) -> Self {
        make { $0.initialVelocity = initialVelocity }
    }
}

@available(iOS 2.0, *)
public extension CAAnimator where Base: CATransition {
    
    @discardableResult func type(_ type: CATransitionType) -> Self {
        make { $0.type = type }
    }
    
    @discardableResult func subtype(_ subtype: CATransitionSubtype?) -> Self {
        make { $0.subtype = subtype }
    }
    
    @discardableResult func startProgress(_ startProgress: Float) -> Self {
        make { $0.startProgress = startProgress }
    }
    
    @discardableResult func endProgress(_ endProgress: Float) -> Self {
        make { $0.endProgress = endProgress }
    }
}

@available(iOS 2.0, *)
extension CAAnimator where Base: CAAnimationGroup {
    
    @discardableResult func animations(_ animations: [CAAnimation]?) -> Self {
        make { $0.animations = animations }
    }
}


private var didStartClourseKey: UInt8 = 0
private var didStopClourseKey: UInt8 = 0

fileprivate extension CAAnimation {
    var didStart: ((CAAnimation) -> Void)? {
        set {
            objc_setAssociatedObject(self, &didStartClourseKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &didStartClourseKey) as? ((CAAnimation) -> Void)
        }
    }
    
    var didStop: ((CAAnimation, Bool) -> Void)? {
        set {
            objc_setAssociatedObject(self, &didStopClourseKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &didStopClourseKey) as? ((CAAnimation, Bool) -> Void)
        }
    }
}

fileprivate class CAAnimationDelegateTarget: NSObject, CAAnimationDelegate {
    weak var animation: CAAnimation?
    
    init(_ animation: CAAnimation) {
        self.animation = animation
    }
    
    @available(iOS 2.0, *)
    func animationDidStart(_ anim: CAAnimation) {
        animation?.didStart?(anim)
    }
    
    @available(iOS 2.0, *)
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animation?.didStop?(anim, flag)
    }
}
