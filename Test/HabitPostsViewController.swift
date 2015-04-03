//
//  HabitPostsViewController.swift
//  Test
//
//  Created by Sutan on 3/11/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

class HabitPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let kReusableHabitDetailNewCellIdentifier : String = "habitDetailNewCellIdentifier"
    let kReusableHabitPostCellIdentifier : String = "habitPostCellIdentifier"
    
    let habitTintColor:UIColor = UIColorFromRGB(0xD4AF37)

    var habit: Habit!
    var tableView : UITableView!
    var posts:NSMutableArray!
    var isCurrent:Bool!
    
    override func loadView() {
        self.view = UIView()
        
        addTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isCurrent == true {
            self.navigationItem.title = "Current Habit"
        }
        else {
            self.navigationItem.title = "Completed Habit"
        }
    }
    
    func setHabit(habit:Habit, isCurrent:Bool) {
        self.isCurrent = isCurrent
        self.habit = habit
        posts = NSMutableArray(array: [0x000000, 0x0000ff, 0x00ff00, 0xff0000, 0x00ffff, 0xff00ff, 0xffff00, 0xffffff, 0x888888, 0x888800, 0x880088, 0x008888, 0x880000, 0x008800, 0x000088])
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
        self.tableView.registerClass(HabitDetailNewTableViewCell.self, forCellReuseIdentifier: kReusableHabitDetailNewCellIdentifier)
        self.tableView.registerClass(HabitPostTableViewCell.self, forCellReuseIdentifier: kReusableHabitPostCellIdentifier)
        
        layout(tableView) {tableView in
            tableView.left      == tableView.superview!.left
            tableView.right     == tableView.superview!.right
            tableView.top       == tableView.superview!.top
            tableView.bottom    == tableView.superview!.bottom
        }
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if habit == nil {
            return 0
        }
        else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if habit == nil {
            return 0
        }
        else {
            if section == 0 {
                return 1
            }
            else {
                return posts.count
            }
        }
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
            return HabitDetailNewTableViewCell.Static.heightForCell(habit)
        }
        else if indexPath.section == 1 {
            return HabitPostTableViewCell.Static.heightForCell(posts[indexPath.row])
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let habitSectionHeaderString:String = "Post from this habit:"
            
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
            var cell:HabitDetailNewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(kReusableHabitDetailNewCellIdentifier, forIndexPath: indexPath) as HabitDetailNewTableViewCell
            cell.setHabit(habit)
            return cell
        }
        else {
            var cell:HabitPostTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(kReusableHabitPostCellIdentifier, forIndexPath: indexPath) as HabitPostTableViewCell
            cell.setPost(posts[indexPath.row])
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            var habitTextViewController : HabitTextViewController = HabitTextViewController()
            habitTextViewController.setHabit(habit)
            self.presentViewController(habitTextViewController, animated: true, completion: nil)
        }
    }
}

class HabitDetailNewTableViewCell: UITableViewCell {
    
    var progressView:CircleProgressView!
    var descriptionLabel:UILabel!
    var commentLabel:UILabel!
    
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
        
        commentLabel = UILabel()
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = NSTextAlignment.Left
        commentLabel.font = Static.habitCommentFont
        commentLabel.textColor = UIColorFromRGB(0xBEBEBE)
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
        let width:CGFloat = UIScreen.mainScreen().bounds.size.width - 2 * Static.habitHorizontalMargin - Static.habitProgressSize - Static.habitRightMargin
        let descriptionLabelHeight:CGFloat = StringUtils.Static.heightForText(habit.description(), font: Static.habitDescriptionFont, width: width)
        let commentLabelHeight:CGFloat = StringUtils.Static.heightForText(commentLabel.text!, font: Static.habitCommentFont, width: width)
        let height = max(Static.habitProgressSize, descriptionLabelHeight + commentLabelHeight)
        let top = Static.habitProgressSize == height ? Static.currentHabitMargin + (Static.habitProgressSize - descriptionLabelHeight - commentLabelHeight) / 2 : Static.currentHabitMargin
        
        constrain(progressView, descriptionLabel, commentLabel) { progressView, descriptionLabel, commentLabel in
            progressView.left           == progressView.superview!.left + Static.habitHorizontalMargin
            progressView.width          == Static.habitProgressSize
            progressView.height         == Static.habitProgressSize
            progressView.top            == progressView.superview!.top + (Static.currentHabitMargin + (height - Static.habitProgressSize) / 2)
            
            descriptionLabel.left       == progressView.right + Static.habitHorizontalMargin
            descriptionLabel.top        == descriptionLabel.superview!.top + top
            descriptionLabel.height     == descriptionLabelHeight
            descriptionLabel.width      == width
            
            commentLabel.left           == descriptionLabel.left
            commentLabel.right          == descriptionLabel.right
            commentLabel.top            == descriptionLabel.bottom
            commentLabel.height         == commentLabelHeight
        }
    }
    
    struct Static {
        static let habitProgressSize:CGFloat = 50
        static let habitRightMargin:CGFloat = 28
        static let habitHorizontalMargin:CGFloat = 15
        static let currentHabitMargin: CGFloat = 25
        
        static let habitCommentString:String = "You have logged %d out of %d days so far this habit!"
        static let habitDescriptionFont: UIFont = UIFont(name: "Lato-Light", size: 15)!
        static let habitCommentFont: UIFont = UIFont(name: "Lato-Light", size: 14)!
        
        static func heightForCell(habit:Habit) -> CGFloat {
            let width:CGFloat = UIScreen.mainScreen().bounds.size.width - 2 * habitHorizontalMargin - habitProgressSize - habitRightMargin
            let descriptionLabelHeight:CGFloat = StringUtils.Static.heightForText(habit.description(), font: habitDescriptionFont, width: width)
            let commentLabelHeight:CGFloat = StringUtils.Static.heightForText(NSString(format: habitCommentString, habit.numberOfDaysCompliant(), habit.numberOfDays()), font: habitCommentFont, width: width)
            let height = max(habitProgressSize, descriptionLabelHeight + commentLabelHeight)
            
            return (currentHabitMargin + height + currentHabitMargin)
        }
    }
}

class HabitPostTableViewCell: UITableViewCell {
    
    var post : AnyObject!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.separatorInset = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false;
        self.layoutMargins = UIEdgeInsetsZero
        self.contentView.backgroundColor = UIColor.clearColor()
        
        addViews()
    }
    
    func addViews() {
        
    }
    
    func setPost(post: AnyObject) {
        self.post = post
        self.contentView.backgroundColor = UIColorFromRGB(post as UInt)
        setLayout()
    }
    
    func setLayout() {
    }
    
    struct Static {
        static func heightForCell(post: AnyObject) -> CGFloat {
            return 120
        }
    }
}