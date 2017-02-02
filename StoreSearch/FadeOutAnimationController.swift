//
//  FadeOutAnimationController.swift
//  StoreSearch
//
//  Created by DANIEL DE VERE on 2/2/17.
//  Copyright (c) 2017 DANIEL DE VERE. All rights reserved.
//

import UIKit

class FadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
            let duration = transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration, animations: {
                fromView.alpha = 0
                }, completion: {
                    finished in
                    transitionContext.completeTransition(finished)
            })
        }
    }
}
