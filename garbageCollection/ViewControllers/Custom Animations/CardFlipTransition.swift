//
//  CardFlipTransition.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-07-03.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import UIKit

protocol CardFlipSourceAnimatable: NSObjectProtocol {
    var view: UIView! { get }
    func originFrame() -> CGRect
    func originView() -> UIView
}

protocol CardFlipDestinationAnimatable: NSObjectProtocol {
    var view: UIView! { get }
    func destinationFrame() -> CGRect
    func destinationView() -> UIView
}

class CardFlipTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isForward: Bool
    
    let duration: TimeInterval = 0.4
    
    private static var sourceViewSnapShot: UIView?
    
    init(isForward: Bool) {
        self.isForward = isForward
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    private func animateForward(with context: UIViewControllerContextTransitioning) {
        let container = context.containerView
        
        let navBar = (context.viewController(forKey: .from) as? UITabBarController)?.selectedViewController
        let topMost = (navBar as? UINavigationController)?.topViewController
        
        guard let fromVC = topMost as? CardFlipSourceAnimatable else { fatalError() }
        guard let toVC = context.viewController(forKey: .to) as? CardFlipDestinationAnimatable else { fatalError() }
        
        let originView = fromVC.originView().snapshotView(afterScreenUpdates: true)!
        
        CardFlipTransition.sourceViewSnapShot = originView
        
        toVC.view.clipsToBounds = true
        toVC.view.frame = fromVC.originFrame()
        toVC.view.layoutIfNeeded()
        
        originView.frame = fromVC.originFrame()
        
        container.addSubview(toVC.view)
        container.addSubview(originView)
        
        originView.layer.zPosition = 400
        originView.layer.cornerRadius = 0
        fromVC.originView().isHidden = true

        toVC.destinationView().layer.transform = CATransform3DMakeRotation(CGFloat(-Double.pi/2), 0.0, 1.0, 0.0)
        
        let resizingAnimation = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: {
            toVC.view.frame = container.bounds
            toVC.view.layoutIfNeeded()
            originView.frame = toVC.destinationFrame()
        })
        
        // Rotate origin view
        let rotateOriginView = UIViewPropertyAnimator(duration: duration/3, curve: .linear) {
            originView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi/2), 0.0, 1.0, 0.0)
        }
        
        // Rotate destination view
        let rotateDestinationView = UIViewPropertyAnimator(duration: 2*duration/3, curve: .linear) {
            toVC.destinationView().layer.transform = CATransform3DMakeRotation(CGFloat(0), 0.0, 1.0, 0.0)
        }
        
        rotateOriginView.addCompletion { _ in
            originView.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
            rotateDestinationView.startAnimation()
        }
        
        resizingAnimation.startAnimation()
        rotateOriginView.startAnimation()
    }
    
    private func animateBackwards(with context: UIViewControllerContextTransitioning) {
        let container = context.containerView
        
        let navBar = (context.viewController(forKey: .to) as? UITabBarController)?.selectedViewController
        let topMost = (navBar as? UINavigationController)?.topViewController
        
        guard let toVC = topMost as? CardFlipSourceAnimatable else { fatalError() }
        guard let fromVC = context.viewController(forKey: .from) as? CardFlipDestinationAnimatable else { fatalError() }
        
        let destinationView = CardFlipTransition.sourceViewSnapShot!
        
        let originView = fromVC.destinationView()

        toVC.view.frame = container.bounds
        toVC.view.setNeedsLayout()
        toVC.view.layoutIfNeeded()
        fromVC.view.clipsToBounds = true
        
        container.addSubview(destinationView)
        destinationView.frame = originView.frame
        destinationView.layer.zPosition = 400
        destinationView.layer.transform = CATransform3DMakeRotation(CGFloat(-Double.pi/2), 0.0, 1.0, 0.0)
        
        let frameAnimation = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: {
            fromVC.view.frame = toVC.originFrame()
            fromVC.view.layoutIfNeeded()
            fromVC.view.backgroundColor = .clear
            destinationView.frame = toVC.originFrame()
        })
        
        // Rotate origin view
        let rotateSourceViewAnimation = UIViewPropertyAnimator(duration: duration/3, curve: .linear) {
            originView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi/2), 0.0, 1.0, 0.0)
            originView.layer.cornerRadius = 8
        }
        
        // Rotate destination view
        let rotateDestinationViewAnimation = UIViewPropertyAnimator(duration: 2*duration/3, curve: .linear) {
            destinationView.layer.transform = CATransform3DMakeRotation(CGFloat(0), 0.0, 1.0, 0.0)
        }
        
        frameAnimation.addCompletion { _ in
            fromVC.view.removeFromSuperview()
            toVC.originView().isHidden = false
            CardFlipTransition.sourceViewSnapShot = nil
            context.completeTransition(!context.transitionWasCancelled)
        }
        
        rotateSourceViewAnimation.addCompletion { _ in
            originView.removeFromSuperview()
            rotateDestinationViewAnimation.startAnimation()
        }
        
        rotateSourceViewAnimation.startAnimation()
        frameAnimation.startAnimation()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isForward {
            animateForward(with: transitionContext)
        } else {
            animateBackwards(with: transitionContext)
        }
        
    }

}
