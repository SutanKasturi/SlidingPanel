//
//  QuestionViewController.swift
//  Test
//
//  Created by Sutan on 2/27/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

protocol QuestionViewControllerProtocol {
    func onPrev()
    func onNext()
    func onCheck()
}

class QuestionViewController: UIViewController {
    
    var questionString : NSString!
    var isChecked : Bool!
    var currentDate : NSDate!
    var delegate : QuestionViewControllerProtocol!

    private var questionLabel : UILabel!
    private var containerView : UIView!
    private var checkButton : UIButton!
    private var prevButton : UIButton!
    private var nextButton : UIButton!
    
    override func loadView() {
        self.view = UIView()
        
        makeLayout()
        initQuestion()
    }
    
    func makeLayout() {
        
        // Make Question Label
        questionLabel = UILabel()
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(questionLabel);
        
        // Make ContainerView
        containerView = UIView()
        self.view.addSubview(containerView)
        
        // Make Check Button
        checkButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        checkButton.setImage(UIImage(named: "check"), forState: .Normal)
        checkButton.setImage(UIImage(named: "checked"), forState: .Selected)
        containerView.addSubview(checkButton)
        checkButton.addTarget(self, action: "onCheck", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Make Prev Button
        prevButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        prevButton.setImage(UIImage(named: "prev"), forState: .Normal)
        containerView.addSubview(prevButton)
        prevButton.addTarget(self, action: "onPrev", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Make Next Button
        nextButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        nextButton.setImage(UIImage(named: "next"), forState: .Normal)
        containerView.addSubview(nextButton)
        nextButton.addTarget(self, action: "onNext", forControlEvents: UIControlEvents.TouchUpInside)
        
        let checkButtonSize:CGFloat = self.view.frame.size.width * 0.47
        var metrics = ["margin":16.0, "buttonSize" : 24.0, "questionLabelHeight": 50.0, "checkButtonSize" : checkButtonSize, "buttonWidth": 15.0]
        
        constrain(containerView, questionLabel) { containerView, questionLabel in
            containerView.left      == containerView.superview!.left
            containerView.right     == containerView.superview!.right
            containerView.height    == metrics["checkButtonSize"]!
            containerView.center    == containerView.superview!.center
            
            questionLabel.left      == questionLabel.superview!.left + metrics["margin"]!
            questionLabel.right     == questionLabel.superview!.right - metrics["margin"]!
            questionLabel.bottom    == containerView.top - metrics["margin"]!
            questionLabel.height    == metrics["questionLabelHeight"]!
        }

        constrain(checkButton, prevButton, nextButton) { checkButton, prevButton, nextButton in
            checkButton.width       == metrics["checkButtonSize"]!
            checkButton.height      == metrics["checkButtonSize"]!
            checkButton.center      == checkButton.superview!.center
            
            prevButton.width        == metrics["buttonWidth"]!
            prevButton.height       == metrics["buttonSize"]!
            prevButton.centerY      == checkButton.centerY
            prevButton.right        == checkButton.left - metrics["margin"]!
            
            nextButton.width        == metrics["buttonWidth"]!
            nextButton.height       == metrics["buttonSize"]!
            nextButton.centerY      == checkButton.centerY
            nextButton.left         == checkButton.right + metrics["margin"]!
        }
        
        UIView.animateWithDuration(0.5, animations: self.view.layoutIfNeeded)
    }
    
    func initQuestion() {
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dif = calendar.components(.DayCalendarUnit, fromDate: currentDate, toDate:today, options: nil).day
        if ( dif == 0 ) {
            questionString = "Did you write down what you are today?"
        }
        else if ( dif == 1 ) {
            questionString = "Did you write down what you are yesterday?"
        }
        else {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM-dd-yyyy"
            let dateString = dateFormatter.stringFromDate(currentDate)
            questionString = "Did you write down what you are \(dateString)?"
        }
        questionLabel.text = questionString
        
        if ( dif <= 0 ) {
            nextButton.hidden = true
        }
        else {
            nextButton.hidden = false
        }
        
        if ( dif >= 6 ) {
            prevButton.hidden = true
        }
        else {
            prevButton.hidden = false
        }
        if ( isChecked == true ) {
            checkButton.selected = true
        }
        else {
            checkButton.selected = false
        }
    }
    
    func onCheck() {
        checkButton.selected = !checkButton.selected
        if ( delegate != nil )
        {
            delegate.onCheck()
        }
    }
    
    func onPrev() {
        if ( delegate != nil )
        {
            delegate.onPrev()
        }
    }
    
    func onNext() {
        if ( delegate != nil )
        {
            delegate.onNext()
        }
    }
}
