//
//  ViewController.swift
//  Test
//
//  Created by Sutan on 2/27/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuestionViewControllerProtocol {
    
    var questionContainerView : UIView!
    private var closeButton : UIButton!
    private var questionView : QuestionViewController!
    private var bottomView : UIView!
    private var image1 : UIImageView!
    private var image2 : UIImageView!
    private var lineView : UIView!
    
    private var questionArray : NSMutableArray!
    private var currentQuestionNumber : Int!
    
    override func loadView() {
        self.view = UIView()
        
        // Do any additional setup after loading the view, typically from a nib.
        questionArray = NSMutableArray()
        currentQuestionNumber = 0;
        for i in 0...6 {
            questionArray.addObject(false)
        }
        
        makeLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if ( questionView == nil ) {
            questionView = QuestionViewController()
            questionView.isChecked = questionArray[currentQuestionNumber] as Bool
            questionView.currentDate = getNewDate()
            questionView.delegate = self
            self.addChildViewController(questionView)
            questionContainerView.addSubview(questionView.view)
            let rect:CGRect = questionContainerView.bounds
            questionView.view.frame = rect
        }
    }
    
    func makeLayout() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Make Close Button
        closeButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        closeButton.setImage(UIImage(named: "close"), forState: .Normal)
        self.view.addSubview(closeButton)
        closeButton.addTarget(self, action: "onClose", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Make Question ContainerView
        questionContainerView = UIView()
        questionContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(questionContainerView)
        
        // Make BottomView
        bottomView = UIView()
        self.view.addSubview(bottomView)
        
        image1 = UIImageView()
        image1.image = UIImage(named: "oval")
        bottomView.addSubview(image1)
        
        image2 = UIImageView()
        image2.image = UIImage(named: "group")
        bottomView.addSubview(image2)
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.grayColor()
        bottomView.addSubview(lineView)
        
        var metrics = ["statusBarHeight": UIApplication.sharedApplication().statusBarFrame.size.height, "padding":8.0, "margin":16.0, "buttonSize" : 24.0]
        constrain(closeButton, bottomView) { closeButton, bottomView in
            closeButton.width   == metrics["buttonSize"]!
            closeButton.height  == metrics["buttonSize"]!
            closeButton.top     == metrics["statusBarHeight"]! + closeButton.superview!.top + metrics["margin"]!
            closeButton.right   == closeButton.superview!.right - metrics["margin"]!
            
            bottomView.bottom   == bottomView.superview!.bottom - metrics["margin"]!
            bottomView.left     == bottomView.superview!.left
            bottomView.right    == bottomView.superview!.right
            bottomView.height   == metrics["buttonSize"]!
            bottomView.centerX  == bottomView.superview!.centerX
        }
        
        constrain(image1, image2, lineView) { image1, image2, lineView in
            lineView.width      == 1.0
            lineView.top        == lineView.superview!.top
            lineView.bottom     == lineView.superview!.bottom
            lineView.centerX    == lineView.superview!.centerX
            
            image1.width        == metrics["buttonSize"]!
            image1.height       == metrics["buttonSize"]!
            image1.right        == lineView.left - metrics["padding"]!
            image1.centerY      == image1.superview!.centerY
            
            image2.width        == metrics["buttonSize"]!
            image2.height       == metrics["buttonSize"]!
            image2.left        == lineView.right + metrics["padding"]!
            image2.centerY      == image2.superview!.centerY
        }
        
        constrain(closeButton, bottomView, questionContainerView) { closeButton, bottomView, questionContainerView in
            questionContainerView.top       == closeButton.bottom
            questionContainerView.bottom    == bottomView.top
            questionContainerView.left      == questionContainerView.superview!.left
            questionContainerView.right     == questionContainerView.superview!.right
        }
    }
    
    func onClose() {
        
    }
    
    func onNext() {
        currentQuestionNumber = currentQuestionNumber - 1

        var rect:CGRect = questionContainerView.bounds
        var nextQuestionView:QuestionViewController = addNewQuestionView(true)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.questionView.view.frame = CGRectMake(-rect.size.width, 0, rect.size.width, rect.size.height)
            nextQuestionView.view.frame = rect;
        }) { (Bool) -> Void in
            self.setNewQuestionView(nextQuestionView)
        }
    }
    
    func onPrev() {
        currentQuestionNumber = currentQuestionNumber + 1
        var rect:CGRect = questionContainerView.bounds
        var prevQuestionView:QuestionViewController = addNewQuestionView(false)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.questionView.view.frame = CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height)
            prevQuestionView.view.frame = rect;
        }) { (Bool) -> Void in
            self.setNewQuestionView(prevQuestionView)
        }
    }
    
    func onCheck() {
        questionArray[currentQuestionNumber] = !(questionArray[currentQuestionNumber] as Bool)
    }
    
    func setNewQuestionView(newView:QuestionViewController) {
        questionView.view.removeFromSuperview()
        questionView.removeFromParentViewController()
        questionView = newView
        questionView.delegate = self
    }
    
    func getNewDate()->NSDate {
        var date = NSDate()
        var interval = -60*60*24*currentQuestionNumber
        var newDate = date.dateByAddingTimeInterval(NSTimeInterval(interval))
        return newDate
    }
    
    func addNewQuestionView(isNext:Bool)->QuestionViewController {
        var rect:CGRect = questionContainerView.bounds
        var newRect:CGRect = rect
        if ( isNext == true ) {
            newRect.origin.x = rect.size.width
        }
        else {
            newRect.origin.x = -rect.size.width
        }
        
        var newQuestionView:QuestionViewController = QuestionViewController()
        newQuestionView.isChecked = questionArray[currentQuestionNumber] as Bool
        
        newQuestionView.currentDate = self.getNewDate()
        
        newQuestionView.view.frame = newRect
        self.addChildViewController(newQuestionView)
        questionContainerView.addSubview(newQuestionView.view)
        
        return newQuestionView
    }
}

