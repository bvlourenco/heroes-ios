//
//  Transition.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 04/12/2023.
//

import UIKit

class Transition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return GlobalConstants.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        toView.frame = CGRect(x: 0,
                              y: containerView.frame.height,
                              width: containerView.frame.width,
                              height: containerView.frame.height)
        UIView.animate(withDuration: GlobalConstants.animationDuration,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
            toView.transform = CGAffineTransform(translationX: 0, y: -toView.frame.height)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}

extension UIViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return Transition()
        case .pop:
            return nil
        default:
            return nil
        }
    }
}
