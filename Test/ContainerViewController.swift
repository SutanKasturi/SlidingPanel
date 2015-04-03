//
//  ContainerViewController.swift
//  Test
//
//  Created by Sutan on 3/18/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

class ContainerViewController: UIViewController, CenterViewControllerDelegate, UIGestureRecognizerDelegate {
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var slideState: SlideOutState = .BothCollapsed
    
    var leftViewController: SidePanelViewController?
    var rightViewController: SidePanelViewController?
    
    let centerPanelExpandedOffset: CGFloat = UIScreen.mainScreen().bounds.size.width - 200
    
    var tapGestureRecognizer : UITapGestureRecognizer!
    
    func setCenterViewController(viewController:CenterViewController) {
        if centerViewController != nil {
            centerViewController.removeFromParentViewController()
            centerViewController.view.removeFromSuperview()
        }
        
        if centerNavigationController != nil {
            centerNavigationController.removeFromParentViewController()
            centerNavigationController.view.removeFromSuperview()
        }
                
        centerViewController = viewController
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMoveToParentViewController(self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleCenterTapGesture:")
    }
    
    func addCenterTapGesture() {
        if ( centerNavigationController != nil ) {
            centerNavigationController.view.addGestureRecognizer(tapGestureRecognizer);
            centerViewController.view.userInteractionEnabled = false
        }
    }
    
    func removeCenterTapGesture() {
        if ( centerNavigationController != nil ) {
            centerNavigationController.view.removeGestureRecognizer(tapGestureRecognizer)
            centerViewController.view.userInteractionEnabled = true
        }
    }
    
    // MARK: CenterViewController delegate methods
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func toggleRightPanel() {
        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .RightPanelExpanded:
            toggleRightPanel()
        case .LeftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = SidePanelViewController()
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addRightPanelViewController() {
        if (rightViewController == nil) {
            rightViewController = SidePanelViewController()
            
            addChildSidePanelController(rightViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        sidePanelController.delegate = centerViewController
        
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
            addCenterTapGesture()
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
                self.removeCenterTapGesture()
            }
        }
    }
    
    func animateRightPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .RightPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: -CGRectGetWidth(centerNavigationController.view.frame) + centerPanelExpandedOffset)
            addCenterTapGesture()
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .BothCollapsed
                
                self.rightViewController!.view.removeFromSuperview()
                self.rightViewController = nil;
                
                self.removeCenterTapGesture()
            }
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.3
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    // MARK: Gesture recognizer
    
    func handleCenterTapGesture(recognizer: UITapGestureRecognizer) {
        collapseSidePanels()
    }
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Began:
            if (currentState == .BothCollapsed) {
                
                if (gestureIsDraggingFromLeftToRight) {
                    if ( slideState != SlideOutState.RightPanelExpanded ) {
                        addLeftPanelViewController()
                    }
                } else {
                    if ( slideState != SlideOutState.LeftPanelExpanded ) {
                        addRightPanelViewController()
                    }
                }
                
                showShadowForCenterViewController(true)
            }
        case .Changed:
            if (slideState == SlideOutState.RightPanelExpanded &&
                (gestureIsDraggingFromLeftToRight && recognizer.view!.frame.origin.x >= 0))
                ||
               (slideState == SlideOutState.LeftPanelExpanded &&
                    (!gestureIsDraggingFromLeftToRight && recognizer.view!.frame.origin.x <= 0)){
                        
                recognizer.view!.center.x = view.center.x
                recognizer.setTranslation(CGPointZero, inView: view)
            } else if (slideState == SlideOutState.RightPanelExpanded &&
                (!gestureIsDraggingFromLeftToRight && recognizer.view!.frame.origin.x <= -centerPanelExpandedOffset))
                ||
                (slideState == SlideOutState.LeftPanelExpanded &&
                    (gestureIsDraggingFromLeftToRight && recognizer.view!.frame.origin.x >= centerPanelExpandedOffset)){
                        if leftViewController != nil  {
                            recognizer.view!.frame.origin.x = CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset
                            recognizer.setTranslation(CGPointZero, inView: view)
                        }
                        else if rightViewController != nil {
                            recognizer.view!.frame.origin.x = CGRectGetWidth(centerNavigationController.view.frame) + centerPanelExpandedOffset
                            recognizer.setTranslation(CGPointZero, inView: view)
                        }
            } else {
                recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
                recognizer.setTranslation(CGPointZero, inView: view)
            }
        case .Ended:
            if (leftViewController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > CGRectGetWidth(centerNavigationController.view.frame) / 2 + centerPanelExpandedOffset / 2
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            } else if (rightViewController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x < CGRectGetWidth(centerNavigationController.view.frame) / 2 - centerPanelExpandedOffset / 2
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
}
