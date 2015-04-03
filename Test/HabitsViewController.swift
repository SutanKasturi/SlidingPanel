//
//  HabitsViewController.swift
//  Test
//
//  Created by Sutan on 3/6/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

class HabitsViewController: CenterViewController, UITableViewDelegate, UITableViewDataSource {

    var habitManager: HabitManagerClass!
    var tableView : UITableView!
    
    let habitTintColor:UIColor = UIColorFromRGB(0xD4AF37)
    
    override func loadView() {
        self.view = UIView()
        
        habitManager = HabitManagerClass()
        
        addTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigationTitleFont : UIFont = UIFont(name: "Lato-Light", size: 17.0)!

        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont]
        self.navigationController?.navigationBar.tintColor = habitTintColor
        self.navigationItem.title = "Habits"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    func addTableView() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        tableView = UITableView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.tintColor = habitTintColor
        tableView.delegate = self
        tableView.dataSource = self
        
        let habitSelectedBgColor:UIColor = UIColorFromRGB(0xFBF5E3)
        let selectedColorView = UIView()
        selectedColorView.backgroundColor = habitSelectedBgColor
        UITableViewCell.appearance().selectedBackgroundView = selectedColorView
        
        self.view.addSubview(tableView);
        self.tableView.registerClass(CurrentHabitTableViewCell.self, forCellReuseIdentifier: "currentHabitCellIdentifier")
        self.tableView.registerClass(HabitTableViewCell.self, forCellReuseIdentifier: "habitCellIdentifier")

        constrain(tableView) {tableView in
            tableView.left      == tableView.superview!.left
            tableView.right     == tableView.superview!.right
            tableView.top       == tableView.superview!.top
            tableView.bottom    == tableView.superview!.bottom
        }
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if habitManager.get().count > 1 {
            return 2
        }
        return habitManager.get().count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if habitManager.get().count > 0 {
            if section == 0 {
                return 1;
            }
            else {
                return habitManager.get().count - 1
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else if section == 1 {
            return 40
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CurrentHabitTableViewCell.Static.heightForCell(habitManager.current())
        }
        else if indexPath.section == 1 {
            return HabitTableViewCell.Static.heightForCell(habitManager.get()[indexPath.row + 1])
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let habitSectionHeaderString:String = "Completed Habits"
            let habitSectionHeaderFont: UIFont = UIFont(name: "Lato-Light", size: 14)!

            let habitSectionHeaderBgColor = UIColorFromRGB(0xF8F8F8)
            let grayColor:UIColor = UIColorFromRGB(0xBEBEBE)
            
            let habitHorizontalMargin:CGFloat = 15
            let habitVerticalMargin:CGFloat = 10
            
            var headerFrame:CGRect = tableView.frame
            var sectionHeaderLabel:UILabel = UILabel(frame: CGRectMake(habitHorizontalMargin, habitVerticalMargin, 150, 20))
            sectionHeaderLabel.text = habitSectionHeaderString
            sectionHeaderLabel.textColor = grayColor
            sectionHeaderLabel.font = habitSectionHeaderFont
            
            var headerView:UIView = UIView(frame: CGRectMake(0, 0, headerFrame.size.width, headerFrame.size.height))
            headerView.addSubview(sectionHeaderLabel)
            headerView.backgroundColor = habitSectionHeaderBgColor
            
            return headerView
        }
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell:CurrentHabitTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("currentHabitCellIdentifier", forIndexPath: indexPath) as CurrentHabitTableViewCell
            cell.setHabit(habitManager.current())
            return cell
        }
        else {
            var cell:HabitTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("habitCellIdentifier", forIndexPath: indexPath) as HabitTableViewCell
            cell.setHabit(habitManager.get()[indexPath.row + 1])
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var habitPostsViewController : HabitPostsViewController = HabitPostsViewController()
        habitPostsViewController.setHabit(habitManager.get()[indexPath.section == 0 ? indexPath.row : indexPath.row + 1], isCurrent : indexPath.section == 0 ? true : false)
        self.navigationController?.pushViewController(habitPostsViewController, animated: true)
    }
}

class CurrentHabitTableViewCell:UITableViewCell {
    
    var currentHabitLabel: UILabel!
    var descriptionLabel: UILabel!
    var progressView: CircleProgressView!
    var commentLabel: UILabel!
    
    var habit:Habit!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.separatorInset = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false;
        self.layoutMargins = UIEdgeInsetsZero
        
        addViews()
    }
    
    func addViews() {
        currentHabitLabel = UILabel()
        currentHabitLabel.numberOfLines = 0
        currentHabitLabel.text = Static.currentHabitString
        currentHabitLabel.textAlignment = NSTextAlignment.Center
        currentHabitLabel.font = Static.habitDescriptionFont
        currentHabitLabel.textColor = UIColorFromRGB(0xBEBEBE)
        currentHabitLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.contentView.addSubview(currentHabitLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = NSTextAlignment.Center
        descriptionLabel.font = Static.habitDescriptionFont
        descriptionLabel.textColor = UIColor.blackColor()
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.contentView.addSubview(descriptionLabel)
        
        progressView = CircleProgressView(frame: CGRectMake(0, 0, Static.currentHabitProgressSize, Static.currentHabitProgressSize))
        self.contentView.addSubview(progressView)
        
        commentLabel = UILabel()
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = NSTextAlignment.Center
        commentLabel.font = Static.habitDescriptionFont
        commentLabel.textColor = UIColor.blackColor()
        commentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.contentView.addSubview(commentLabel)
    }
    
    func setHabit(habit: Habit) {
        self.habit = habit
        descriptionLabel.text = self.habit.description()
        progressView.progress = Double(self.habit.compliance())
        commentLabel.text = NSString(format: Static.habitCommentString, habit.numberOfDaysCompliant(), habit.numberOfDays())
        setLayout()
    }
    
    func setLayout() {
        let width:CGFloat = UIScreen.mainScreen().bounds.size.width - 2 * Static.habitHorizontalMargin
        let currentHabitLabelHeight:CGFloat = StringUtils.Static.heightForText(currentHabitLabel.text!, font: Static.habitDescriptionFont, width: width)
        let descriptionLabelHeight:CGFloat = StringUtils.Static.heightForText(descriptionLabel.text!, font: Static.habitDescriptionFont, width: width)
        constrain(currentHabitLabel, descriptionLabel, progressView) {currentHabitLabel, descriptionLabel, progressView in
            currentHabitLabel.left      == currentHabitLabel.superview!.left + Static.habitHorizontalMargin
            currentHabitLabel.top       == currentHabitLabel.superview!.top + Static.currentHabitTopMargin
            currentHabitLabel.height    == currentHabitLabelHeight
            currentHabitLabel.width     == width
            
            descriptionLabel.left       == descriptionLabel.superview!.left + Static.habitHorizontalMargin
            descriptionLabel.top        == currentHabitLabel.bottom
            descriptionLabel.width      == width
            
            progressView.top            == descriptionLabel.bottom + Static.currentHabitMargin
            progressView.centerX        == descriptionLabel.centerX
            progressView.width          == Static.currentHabitProgressSize
            progressView.height         == Static.currentHabitProgressSize
        }
        
        constrain(progressView, commentLabel){ progressView, commentLabel in
            commentLabel.left           == commentLabel.superview!.left + Static.habitHorizontalMargin
            commentLabel.top            == progressView.bottom + Static.currentHabitMargin
            commentLabel.bottom         == commentLabel.superview!.bottom - Static.currentHabitBottomMargin
            commentLabel.width          == width
        }
    }
    
    struct Static {
        
        static let currentHabitBottomMargin: CGFloat = 17
        static let currentHabitProgressSize: CGFloat = 200.0
        static let currentHabitTopMargin: CGFloat = 35
        static let currentHabitMargin: CGFloat = 25
        static let habitHorizontalMargin:CGFloat = 15
        
        static let habitDescriptionFont: UIFont = UIFont(name: "Lato-Light", size: 15)!
        
        static let currentHabitString:String = "Current Habit:"
        static let habitCommentString:String = "Nice! You have logged\n%d out of %d days so far this habit!"
        
        static func heightForCell(habit:Habit) -> CGFloat {
            let width:CGFloat = UIScreen.mainScreen().bounds.size.width - 2 * habitHorizontalMargin
            let currentHabitLabelHeight:CGFloat = StringUtils.Static.heightForText(currentHabitString, font: habitDescriptionFont, width: width)
            let descriptionLabelHeight:CGFloat = StringUtils.Static.heightForText(habit.description(), font: habitDescriptionFont, width: width)
            let commentLabelHeight:CGFloat = StringUtils.Static.heightForText(habitCommentString, font: habitDescriptionFont, width: width)
            
            return (currentHabitTopMargin + currentHabitLabelHeight + descriptionLabelHeight + currentHabitMargin + currentHabitProgressSize + currentHabitMargin + commentLabelHeight + currentHabitBottomMargin)
        }
    }
}

class HabitTableViewCell: UITableViewCell {
    
    var progressView:CircleProgressView!
    var descriptionLabel:UILabel!
    
    var habit:Habit!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.separatorInset = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false;
        self.layoutMargins = UIEdgeInsetsZero
        self.contentView.backgroundColor = UIColor.clearColor()
        
        let assesoryView: UIImageView = UIImageView(image: UIImage(named: "disclosure"))
        self.accessoryView = assesoryView
        
        addViews()
    }
    
    func addViews() {
        progressView = CircleProgressView(frame: CGRectMake(0, 0, Static.habitProgressSize, Static.habitProgressSize))
        self.contentView.addSubview(progressView)
        
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = NSTextAlignment.Left
        descriptionLabel.font = Static.habitDescriptionFont
        descriptionLabel.textColor = UIColor.blackColor()
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.contentView.addSubview(descriptionLabel)
    }
    
    func setHabit(habit: Habit) {
        self.habit = habit
        descriptionLabel.text = self.habit.description()
        progressView.progress = Double(self.habit.compliance())
        
        setLayout()
    }
    
    func setLayout() {
        let width:CGFloat = UIScreen.mainScreen().bounds.size.width - 2 * Static.habitHorizontalMargin - Static.habitProgressSize - Static.habitRightMargin
        let descriptionLabelHeight:CGFloat = StringUtils.Static.heightForText(habit.description(), font: Static.habitDescriptionFont, width: width)
        let height = max(Static.habitProgressSize, descriptionLabelHeight)
        
        constrain(progressView, descriptionLabel) { progressView, descriptionLabel in
            progressView.left           == progressView.superview!.left + Static.habitHorizontalMargin
            progressView.width          == Static.habitProgressSize
            progressView.height         == Static.habitProgressSize
            progressView.top            == progressView.superview!.top + (Static.habitVerticalMargin + (height - Static.habitProgressSize) / 2)
            
            descriptionLabel.left       == progressView.right + Static.habitHorizontalMargin
            descriptionLabel.top        == descriptionLabel.superview!.top + Static.habitVerticalMargin
            descriptionLabel.height     == height
            descriptionLabel.width      == width
        }
    }
    
    struct Static {
        static let habitProgressSize:CGFloat = 50
        static let habitHorizontalMargin:CGFloat = 15
        static let habitVerticalMargin:CGFloat = 10
        static let habitRightMargin:CGFloat = 28
        
        static let habitDescriptionFont: UIFont = UIFont(name: "Lato-Light", size: 15)!
        
        static func heightForCell(habit:Habit) -> CGFloat {
            let width:CGFloat = UIScreen.mainScreen().bounds.size.width - 2 * habitHorizontalMargin - habitProgressSize - habitRightMargin
            let descriptionLabelHeight:CGFloat = StringUtils.Static.heightForText(habit.description(), font: habitDescriptionFont, width: width)
            
            let height = max(habitProgressSize, descriptionLabelHeight)
            
            return (habitVerticalMargin + height + habitVerticalMargin)
        }
    }
}
