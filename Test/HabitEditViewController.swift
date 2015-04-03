//
//  HabitEditViewController.swift
//  Test
//
//  Created by Sutan on 3/13/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

class HabitEditViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {

    let kReusableHabitEditCellIdentifier : String = "habitEditCellIdentifier"
    let khabitEditTitle : String = "habit_detail_title"
    let khabitEditContent : String = "habit_detail_content"
    
    var habit : Habit!
    
    var scrollView : UIScrollView!
    var editContainerView : UIView!
    
    var habitTextView : UITextView!
    var habitWhyTextView : UITextView!
    var habitScaleTextView : UITextView!
    var habitPiggybackTextView : UITextView!
    
    var editContainerViewGroup : ConstraintGroup!
    var habitTextViewGroup : ConstraintGroup!
    var habitWhyTextViewGroup : ConstraintGroup!
    var habitScaleTextViewGroup : ConstraintGroup!
    var habitPiggybackTextViewGroup : ConstraintGroup!
    
    var maxTextViewHeight:CGFloat = 200
    var topHeight:CGFloat!
    var isShowedKeyboard:Bool = false;
    
    let habitHintString: String = "What is the habit?"
    let habitWhyHinString: String = "Why should your clients do this?"
    let habitScaleHintString: String = "How can they make this easier?"
    let habitPiggybackHintString: String = "What are they doing now that can trigger the habit?"
    
    override func loadView() {
        self.view = UIView()
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        
        let buttonBack: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonBack.frame = CGRectMake(-8, 0, 80, 40)
        buttonBack.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8)
        buttonBack.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0)
        buttonBack.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        buttonBack.titleLabel?.font = UIFont(name: "Lato-Light", size: 17)
        buttonBack.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        buttonBack.setTitle("Habits", forState: UIControlState.Normal)
        buttonBack.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonBack.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem : UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        
        let saveButton: UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Bordered, target: self, action: "rightNavButtonClick:")
        self.navigationItem.setRightBarButtonItem(saveButton, animated: false)
        
        makeLayout()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardToggle:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardToggle:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillShowNotification)
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillHideNotification)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateLayout(nil)
    }
    
    func leftNavButtonClick(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rightNavButtonClick(sender:UIButton) {
        if self.habit == nil {
            
        }
        else {
            self.habit._description = habitTextView.text
            self.habit._whyDescription = habitWhyTextView.text
            self.habit._scaleDescription = habitScaleTextView.text
            self.habit._piggybackDescription = habitPiggybackTextView.text
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setHabit(habit:Habit) {
        self.habit = habit
    }
    
    func makeLayout() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        var navbarHeight = self.navigationController?.navigationBar.frame.size.height
        topHeight = UIApplication.sharedApplication().statusBarFrame.height + navbarHeight!
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        editContainerView = UIView()
        editContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.addSubview(editContainerView)
    
        let habitString = self.habit != nil ? self.habit.description() : habitHintString
        let habit = addViews(editContainerView, topView: nil, title: "Habit", hintString: habitString)
        habitTextView = habit.textView
        habitTextViewGroup = habit.group
        
        let habitWhyString = self.habit != nil ? self.habit.whyDescription() : habitWhyHinString
        let habitWhy = addViews(editContainerView, topView: habitTextView, title: "Why?", hintString: habitWhyString)
        habitWhyTextView = habitWhy.textView
        habitWhyTextViewGroup = habitWhy.group
        
        let habitScaleString = self.habit != nil ? self.habit.scaleDescription() : habitScaleHintString
        let habitScale = addViews(editContainerView, topView: habitWhyTextView, title: "How can I scale this habit?", hintString: habitScaleString)
        habitScaleTextView = habitScale.textView
        habitScaleTextViewGroup = habitScale.group
        
        let habitPiggybackString = self.habit != nil ? self.habit.piggybackDescription() : habitPiggybackHintString
        let habitPiggyback = addViews(editContainerView, topView: habitScaleTextView, title: "What can I piggyback off of?", hintString: habitPiggybackString)
        habitPiggybackTextView = habitPiggyback.textView
        habitPiggybackTextViewGroup = habitPiggyback.group
        
        constrain(scrollView, editContainerView) { scrollView, editContainerView in
            scrollView.top      == scrollView.superview!.top
            scrollView.left     == scrollView.superview!.left
            scrollView.right    == scrollView.superview!.right
            scrollView.bottom   == scrollView.superview!.bottom
            
            editContainerView.left     == editContainerView.superview!.left
            editContainerView.width    == UIScreen.mainScreen().bounds.size.width
        }
        
        editContainerViewGroup = constrain(editContainerView) { editContainerView in
            editContainerView.top      == editContainerView.superview!.top
            editContainerView.height   == UIScreen.mainScreen().bounds.size.height - self.topHeight
        }
    
        scrollView.contentSize = editContainerView.bounds.size
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if isShowedKeyboard {
            self.view.endEditing(true)
        }
    }
    
    func keyboardToggle(notification:NSNotification) {
        let info:AnyObject = notification.userInfo!
        let keyboardheight = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().height
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as Double
        
        maxTextViewHeight = UIScreen.mainScreen().bounds.size.height - keyboardheight - 30
        
        var height:CGFloat!
        var botConst: CGFloat!
        
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var window : UIWindow = appDelegate.window!
        
        switch notification.name {
        case UIKeyboardWillShowNotification:
            isShowedKeyboard = true
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.navigationController?.navigationBarHidden = true
                window.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - keyboardheight)
                self.scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, self.editContainerView.bounds.size.height + UIScreen.mainScreen().bounds.size.height)
            })
        case UIKeyboardWillHideNotification:
            isShowedKeyboard = false
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.navigationController?.navigationBarHidden = false
                window.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
                self.scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, self.editContainerView.bounds.size.height)
            })
        default:
            return
        }
    }

    func isEmptyTextView(textView:UITextView) -> Bool {
        var isEmpty = false
        if textView == habitTextView && textView.text == habitHintString {
            isEmpty = true
        }
        else if textView == habitWhyTextView && textView.text == habitWhyHinString {
            isEmpty = true
        }
        else if textView == habitScaleTextView && textView.text == habitScaleHintString {
            isEmpty = true
        }
        else if textView == habitPiggybackTextView && textView.text == habitPiggybackHintString {
            isEmpty = true
        }
        return(isEmpty)
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if isEmptyTextView(textView) {
            textView.text = ""
        }
        textView.textColor = UIColor.blackColor()

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, self.editContainerView.bounds.size.height + UIScreen.mainScreen().bounds.size.height)
            if self.isShowedKeyboard {
                self.scrollView.contentOffset = CGPoint(x: 0, y: textView.frame.origin.y - 30)
            }
            else {
                self.scrollView.contentOffset = CGPoint(x: 0, y: textView.frame.origin.y - 30 - self.topHeight)
            }
        })
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            if textView == habitTextView {
                textView.text = habitHintString
            }
            else if textView == habitWhyTextView {
                textView.text = habitWhyHinString
            }
            else if textView == habitScaleTextView {
                textView.text = habitScaleHintString
            }
            else if textView == habitPiggybackTextView {
                textView.text = habitPiggybackHintString
            }
            textView.textColor = UIColorFromRGB(0xBEBEBE)
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        let frameHeight:CGFloat = textView.frame.size.height
        let contentHeight:CGFloat = max(textView.contentSize.height, 20)
        if frameHeight != contentHeight && contentHeight < maxTextViewHeight {
            var group : ConstraintGroup!
            if textView == habitTextView {
                group = habitTextViewGroup
            }
            else if textView == habitWhyTextView {
                group = habitWhyTextViewGroup
            }
            else if textView == habitScaleTextView {
                group = habitScaleTextViewGroup
            }
            else if textView == habitPiggybackTextView {
                group = habitPiggybackTextViewGroup
            }
            constrain(textView, replace:group) { textView in
                textView.left     == textView.left
                textView.height   == contentHeight
            }
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.editContainerView.layoutIfNeeded()
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    textView.contentOffset = CGPoint(x: 0, y: 0)
                })
                
                self.updateLayout(textView)
            }
        }
    }
    
    func updateLayout(textView:UITextView?) {
        let height : CGFloat = habitPiggybackTextView.frame.origin.y + habitPiggybackTextView.frame.size.height + 15
        constrain(editContainerView, replace:editContainerViewGroup) { editContainerView in
            editContainerView.top       == editContainerView.superview!.top
            editContainerView.height    == height
        }
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                if self.isShowedKeyboard {
                    self.scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, self.editContainerView.bounds.size.height + UIScreen.mainScreen().bounds.size.height)
                }
                else {
                    self.scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, self.editContainerView.bounds.size.height)
                }
                if textView != nil {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: textView!.frame.origin.y - 30)
                }
            })
        }
    }

    let habitEditHorizontalMargin : CGFloat = 15.0
    let habitEditMargin : CGFloat = 20.0
    let habitEditPading : CGFloat = 5.0
    let habitEditTitleFont : UIFont = UIFont(name: "Lato-Bold", size: 17.0)!
    let habitEditContentFont : UIFont = UIFont(name: "Lato-Light", size: 17.0)!
    let habitEditTitleColor : UIColor = UIColorFromRGB(0xD4AF37)
    
    func addViews(view:UIView, topView:UIView?, title:String, hintString:String) -> (textView:UITextView, group:ConstraintGroup) {
        var habitEditTitleLabel = UILabel()
        habitEditTitleLabel.numberOfLines = 0
        habitEditTitleLabel.textAlignment = NSTextAlignment.Left
        habitEditTitleLabel.font = habitEditTitleFont
        habitEditTitleLabel.textColor = habitEditTitleColor
        habitEditTitleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        habitEditTitleLabel.text = title
        
        view.addSubview(habitEditTitleLabel)
        
        var habitEditContentTextView = UITextView()
        habitEditContentTextView.textAlignment = NSTextAlignment.Left
        habitEditContentTextView.font = habitEditContentFont
        habitEditContentTextView.editable = true
        habitEditContentTextView.text = hintString
        
        var isEmpty = false
        if hintString == habitHintString {
            isEmpty = true
        }
        else if hintString == habitWhyHinString {
            isEmpty = true
        }
        else if hintString == habitScaleHintString {
            isEmpty = true
        }
        else if hintString == habitPiggybackHintString {
            isEmpty = true
        }

        if isEmpty {
            habitEditContentTextView.textColor = UIColorFromRGB(0xBEBEBE)
        }
        else {
            habitEditContentTextView.textColor = UIColor.blackColor()
        }
        
        habitEditContentTextView.delegate = self
        
        view.addSubview(habitEditContentTextView)
        
        let width:CGFloat = UIScreen.mainScreen().bounds.size.width - 2 * habitEditHorizontalMargin
        let titleLabelHeight:CGFloat = StringUtils.Static.heightForText(habitEditTitleLabel.text!, font: habitEditTitleFont, width: width)
        let contentHeight:CGFloat = max(StringUtils.Static.heightForText(hintString, font: habitEditContentFont, width: width - habitEditContentTextView.textContainerInset.left - habitEditContentTextView.textContainerInset.right) + habitEditContentTextView.textContainerInset.top + habitEditContentTextView.textContainerInset.bottom, 20)
        
        if topView != nil {
            constrain(topView!, habitEditTitleLabel, habitEditContentTextView) { topView, habitEditTitleLabel, habitEditContentTextView in
                habitEditTitleLabel.left          == habitEditTitleLabel.superview!.left + self.habitEditHorizontalMargin
                habitEditTitleLabel.right         == habitEditTitleLabel.superview!.right - self.habitEditHorizontalMargin
                habitEditTitleLabel.height        == titleLabelHeight
                habitEditTitleLabel.top           == topView.bottom + 15
                
                habitEditContentTextView.left        == habitEditContentTextView.superview!.left + self.habitEditHorizontalMargin
                habitEditContentTextView.right       == habitEditContentTextView.superview!.right - self.habitEditHorizontalMargin
                habitEditContentTextView.top         == habitEditTitleLabel.bottom + self.habitEditPading
            }
        }
        else {
            constrain(habitEditTitleLabel, habitEditContentTextView) { habitEditTitleLabel, habitEditContentTextView in
                habitEditTitleLabel.left          == habitEditTitleLabel.superview!.left + self.habitEditHorizontalMargin
                habitEditTitleLabel.right         == habitEditTitleLabel.superview!.right - self.habitEditHorizontalMargin
                habitEditTitleLabel.height        == titleLabelHeight
                habitEditTitleLabel.top           == habitEditTitleLabel.superview!.top + 15
                
                habitEditContentTextView.left        == habitEditContentTextView.superview!.left + self.habitEditHorizontalMargin
                habitEditContentTextView.right       == habitEditContentTextView.superview!.right - self.habitEditHorizontalMargin
                habitEditContentTextView.top         == habitEditTitleLabel.bottom + self.habitEditPading
            }
        }
        
        var group = constrain(habitEditContentTextView) { habitEditContentTextView in
            habitEditContentTextView.left       == habitEditContentTextView.superview!.left + self.habitEditHorizontalMargin
            habitEditContentTextView.height     == contentHeight
        }
        
        return (habitEditContentTextView, group)
    }
}
