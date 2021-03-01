import XCTest
@testable import Animator

final class AnimatorTests: XCTestCase {
    func testExample() {
        
        /// 创建 UIView.animate
        ///
        ///     UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveEaseInOut) {
        ///         self.redView.frame = CGRect(x: 10, y: 80, width: 80, height: 80)
        ///     } completion: { (finish) in
        ///         print("finish")
        ///     }

        let changeFrameAnimate = Animator()
            .delay(0.5)
            .duration(0.25)
            .options(.curveEaseInOut)
            .animation {
                self.redView.frame = CGRect(x: 10, y: 80, width: 80, height: 80)
            }.completion { (finish) in
                print("finish")
            }
        changeFrameAnimate.run()
        
        /// 创建 UIView.animate 的嵌套
        ///
        ///     UIView.animate(withDuration: 0.25) {
        ///         self.redView.alpha = 0
        ///     } completion: { (finish) in
        ///         UIView.animate(withDuration: 0.25, delay: 0.5, options: []) {
        ///             self.redView.alpha = 1
        ///         } completion: { (finish) in
        ///             print("finish")
        ///         }
        ///     }
        ///
        let alphaAnimate = Animator()
            .chain
            .step
            .duration(0.25)
            .animation {
                self.redView.alpha = 0
            }
            .step
            .delay(0.5)
            .duration(0.25)
            .animation {
                self.redView.alpha = 1
            }
        
        alphaAnimate.run()
        
        /// 创建 CABasicAnimation.scale
        ///
        ///     let scale = CABasicAnimation(keyPath: "transform.scale")
        ///     scale.fromValue = 1
        ///     scale.toValue = 3.5
        ///     scale.autoreverses = true
        ///     scale.fillMode = .forwards
        ///     scale.repeatCount = 3
        ///     scale.duration = 0.8
        ///     self.redView.layer.add(scale, forKey: "scale")
        ///
        let redScale = Animator()
            .basic(.scale)
            .fromValue(1)
            .toValue(3.5)
            .autoreverses(true)
            .fillMode(.forwards)
            .repeatCount(3)
            .duration(0.8)
        redScale.add(to: self.redView.layer)
        redScale.remove(form: self.redView.layer)
        
        /// 创建 CAAnimationGroup
        ///
        ///     let scale = CABasicAnimation(keyPath: "transform.scale")
        ///     scale.fromValue = 1
        ///     scale.toValue = 2
        ///
        ///     let position = CABasicAnimation(keyPath: "position")
        ///     position.fromValue = CGPoint(x: 10, y: 80)
        ///     position.toValue = CGPoint(x: 40, y: 120)
        ///
        ///     let rotationZ = CABasicAnimation(keyPath: "transform.rotation.z")
        ///     rotationZ.fromValue = 0
        ///     rotationZ.toValue = 6.0 * .pi
        ///
        ///     let group = CAAnimationGroup()
        ///     group.duration = 2
        ///     group.autoreverses = true
        ///     group.repeatCount = 3
        ///
        ///     group.animations = [scale, position, rotationZ]
        ///
        ///     self.redView.layer.add(group, forKey: "group")
        ///
        let group = Animator()
            .group { (maker) in
                maker.basic(.scale).fromValue(1).toValue(2)
                maker.basic(.position).fromValue(CGPoint(x: 10, y: 80)).toValue(CGPoint(x: 40, y: 120))
                maker.basic(.rotationZ).fromValue(0).toValue(6.0*Float.pi)
            }
            .duration(2)
            .autoreverses(true)
            .repeatCount(3)
             
        group.add(to: self.redView.layer)
        group.remove(form: self.redView.layer)
        
        /// UIView.transition
        ///
        ///     UIView.transition(from: redView, to: redView, duration: 0.5, options: .curveEaseInOut) { (finish) in
        ///         print(finish)
        ///     }
        ///
        Animator()
            .transition(from: redView)
            .to(view: redView)
            .duration(0.5)
            .options(.curveEaseInOut)
            .completion { (finish) in
                print(finish)
            }.run()

        /// UIView.animateKeyframe
        ///
        ///     UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) {
        ///         UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3.0) {
        ///             print("step1")
        ///         }
        ///        UIView.addKeyframe(withRelativeStartTime: 1/3.0, relativeDuration: 2/3.0) {
        ///             print("step2")
        ///         }
        ///     } completion: { (finish) in
        ///         print("keyframe animation completion")
        ///     }
        ///
        let keyframeAnimation = Animator().keyframe.duration(0.5).animations { (keyframe) in
            keyframe.step.duration(1/3.0).animations { print("Step1") }
            keyframe.step.startTime(1/3.0).duration(2/3.0).animations { print("Step2") }
        }.completion { (finish) in
            print("keyframe animation completion")
        }
        keyframeAnimation.run()
    }
    
    lazy var redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    static var allTests = [
        ("testExample", testExample),
    ]
}
