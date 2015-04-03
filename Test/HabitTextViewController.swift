//
//  HabitDetailViewController.swift
//  Test
//
//  Created by Sutan on 3/10/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

class HabitTextViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let kReusableHabitDetailCellIdentifier : String = "habitDetailCellIdentifier"
    let kHabitDetailTitle : String = "habit_detail_title"
    let kHabitDetailContent : String = "habit_detail_content"
    
    var habit : Habit!
    var closeButton : UIButton!
    var tableView : UITableView!
    var habitDetails : NSMutableArray!
    
    override func loadView() {
        self.view = UIView()
        
        makeLayout()
    }
    
    func setHabit(habit:Habit) {
        self.habit = habit
        habitDetails = NSMutableArray()
        
        habitDetails.addObject([kHabitDetailTitle: "Why?", kHabitDetailContent: habit.whyDescription()])
        habitDetails.addObject([kHabitDetailTitle: "How can I scale this habit?", kHabitDetailContent: habit.scaleDescription()])
        habitDetails.addObject([kHabitDetailTitle: "What can I piggyback off of?", kHabitDetailContent: habit.piggybackDescription()])
    }
    
    func makeLayout() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "onClose", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(closeButton)
        
        tableView = UITableView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        tableView.delegate = self
        tableView.dataSource = self
        
        let habitSelectedBgColor:UIColor = UIColorFromRGB(0xFBF5E3)
        let selectedColorView = UIView()
        selectedColorView.backgroundColor = habitSelectedBgColor
        UITableViewCell.appearance().selectedBackgroundView = selectedColorView
        
        self.view.addSubview(tableView);
        self.tableView.registerClass(HabitDetailTableViewCell.self, forCellReuseIdentifier: kReusableHabitDetailCellIdentifier)
        
        let closeButtonSize : CGFloat = 15.0
        let habitDetailMargin : CGFloat = 20.0
        let habitDetailPading : CGFloat = 5.0
        
        constrain(closeButton, tableView) { closeButton, tableView in
            closeButton.right   == closeButton.superview!.right - habitDetailMargin
            closeButton.top     == closeButton.superview!.top + UIApplication.sharedApplication().statusBarFrame.size.height + 12
            closeButton.width   == closeButtonSize
            closeButton.height  == closeButtonSize
            
            tableView.left      == tableView.superview!.left
            tableView.right     == tableView.superview!.right
            tableView.top       == closeButton.bottom + habitDetailPading
            tableView.bottom    == tableView.superview!.bottom
        }
        
        tableView.reloadData()
    }
    
    func onClose() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (habitDetails.count)
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HabitDetailTableViewCell.Static.heightForCell(habitDetails[indexPath.row] as NSDictionary)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:HabitDetailTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(kReusableHabitDetailCellIdentifier, forIndexPath: indexPath) as HabitDetailTableViewCell
        cell.setHabitDetail(habitDetails[indexPath.row] as NSDictionary)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

}

class HabitDetailTableViewCell : UITableViewCell {
    var habitDetailTitleLabel : UILabel!
    var habitDetailContentLabel : UILabel!
    var habitDetail : NSDictionary!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.clearColor()
        
        addViews()
    }
    
    func addViews() {
        habitDetailTitleLabel = UILabel()
        habitDetailTitleLabel.numberOfLines = 0
        habitDetailTitleLabel.textAlignment = NSTextAlignment.Left
        habitDetailTitleLabel.font = Static.habitDetailTitleLabelFont
        habitDetailTitleLabel.textColor = Static.habitDetailTitleColor
        habitDetailTitleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        self.contentView.addSubview(habitDetailTitleLabel)
        
        habitDetailContentLabel = UILabel()
        habitDetailContentLabel.numberOfLines = 0
        habitDetailContentLabel.textAlignment = NSTextAlignment.Left
        habitDetailContentLabel.font = Static.habitDetailContentLabelFont
        habitDetailContentLabel.textColor = UIColor.blackColor()
        habitDetailContentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.contentView.addSubview(habitDetailContentLabel)
    }
    
    func setHabitDetail(habitDetail: NSDictionary) {
        self.habitDetail = habitDetail
        habitDetailTitleLabel.text = habitDetail[Static.kHabitDetailTitle] as? String
        habitDetailContentLabel.text = habitDetail[Static.kHabitDetailContent] as? String
        
        setLayout()
    }
    
    func setLayout() {
        let width:CGFloat = UIScreen.mainScreen().bounds.size.width - 2 * Static.habitDetailHorizontalMargin
        let titleLabelHeight:CGFloat = StringUtils.Static.heightForText(habitDetailTitleLabel.text!, font: Static.habitDetailTitleLabelFont, width: width)
        let contentLabelHeight : CGFloat = StringUtils.Static.heightForText(habitDetailContentLabel.text!, font: Static.habitDetailContentLabelFont, width: width)
        
        constrain(habitDetailTitleLabel, habitDetailContentLabel) { habitDetailTitleLabel, habitDetailContentLabel in
            habitDetailTitleLabel.left          == habitDetailTitleLabel.superview!.left + Static.habitDetailHorizontalMargin
            habitDetailTitleLabel.width         == width
            habitDetailTitleLabel.height        == titleLabelHeight
            habitDetailTitleLabel.top           == habitDetailTitleLabel.superview!.top + 15
            
            habitDetailContentLabel.left        == habitDetailContentLabel.superview!.left + Static.habitDetailHorizontalMargin
            habitDetailContentLabel.top         == habitDetailTitleLabel.bottom + Static.habitDetailPading
            habitDetailContentLabel.height      == contentLabelHeight
            habitDetailContentLabel.width       == width
        }
    }
    
    struct Static {
        static let habitDetailHorizontalMargin : CGFloat = 15.0
        static let habitDetailMargin : CGFloat = 20.0
        static let habitDetailPading : CGFloat = 5.0
        static let habitDetailTitleLabelFont : UIFont = UIFont(name: "Lato-Bold", size: 17.0)!
        static let habitDetailContentLabelFont : UIFont = UIFont(name: "Lato-Light", size: 17.0)!
        static let habitDetailTitleColor : UIColor = UIColorFromRGB(0xD4AF37)
        
        static let kHabitDetailTitle : String = "habit_detail_title"
        static let kHabitDetailContent : String = "habit_detail_content"
        
        static func heightForCell(habitDetail: NSDictionary) -> CGFloat {
            let width:CGFloat = UIScreen.mainScreen().bounds.size.width - 2 * habitDetailHorizontalMargin
            let titleLabelHeight:CGFloat = StringUtils.Static.heightForText(habitDetail[kHabitDetailTitle] as String, font: habitDetailTitleLabelFont, width: width)
            let contentLabelHeight : CGFloat = StringUtils.Static.heightForText(habitDetail[kHabitDetailContent] as String, font: habitDetailContentLabelFont, width: width)
            
            return (titleLabelHeight + habitDetailPading + contentLabelHeight + habitDetailMargin)
        }
    }
}