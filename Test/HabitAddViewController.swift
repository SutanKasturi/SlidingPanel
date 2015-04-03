//
//  HabitAddViewController.swift
//  Test
//
//  Created by Sutan on 3/13/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

class HabitAddViewController: CenterViewController, UITableViewDelegate, UITableViewDataSource {

    let kReusableHabitTypeCellIdentifier : String = "habitTypeCellIdentifier"
    
    var habitManager: HabitManagerClass!
    var tableView : UITableView!
    
    let habitTintColor:UIColor = UIColorFromRGB(0xD4AF37)
    
    override func loadView() {
        self.view = UIView()
        
        habitManager = HabitManagerClass()
        
        addTableView()
        
        let navigationTitleFont : UIFont = UIFont(name: "Lato-Light", size: 17.0)!
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont]
        self.navigationController?.navigationBar.tintColor = habitTintColor
        self.navigationItem.title = "Habits"
        
        let drawerButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        drawerButton.frame = CGRectMake(0, 0, 30, 30)
        drawerButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        drawerButton.setTitle("A", forState: UIControlState.Normal)
        drawerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        drawerButton.layer.backgroundColor = habitTintColor.CGColor
        drawerButton.layer.cornerRadius = 15
        drawerButton.layer.masksToBounds = true
        drawerButton.addTarget(self, action: "leftTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: drawerButton)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func addTableView() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        var navbarHeight = self.navigationController?.navigationBar.frame.size.height
        let topHeight : CGFloat = UIApplication.sharedApplication().statusBarFrame.height + navbarHeight!
        
        var addNewButton : UIButton = UIButton()
        addNewButton.setImage(UIImage(named: "plus"), forState: .Normal)
        addNewButton.contentEdgeInsets = UIEdgeInsetsMake(20, 15, 20, 15)
        addNewButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0)
        addNewButton.setTitle("Add new habit", forState: .Normal)
        addNewButton.setTitleColor(habitTintColor, forState: .Normal)
        addNewButton.setTitleColor(UIColorFromRGB(0xD8D8D8), forState: UIControlState.Highlighted)
        addNewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        addNewButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 17)
        addNewButton.setTranslatesAutoresizingMaskIntoConstraints(true)
        addNewButton.addTarget(self, action: "addNewHabit", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addNewButton)
        
        var bottomLineView : UIView = UIView()
        bottomLineView.setTranslatesAutoresizingMaskIntoConstraints(true)
        bottomLineView.backgroundColor = UIColorFromRGB(0xD8D8D8)
        self.view.addSubview(bottomLineView)
        
        tableView = UITableView()
        tableView.setTranslatesAutoresizingMaskIntoConstraints(true)
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
        self.tableView.registerClass(HabitTypeTableViewCell.self, forCellReuseIdentifier: kReusableHabitTypeCellIdentifier)
        
        constrain(addNewButton, bottomLineView, tableView) { addNewButton, bottomLineView, tableView in
            addNewButton.left       == addNewButton.superview!.left
            addNewButton.right      == addNewButton.superview!.right
            addNewButton.top        == addNewButton.superview!.top + topHeight
            addNewButton.height     == 60
            
            bottomLineView.left     == bottomLineView.superview!.left + 15
            bottomLineView.right    == bottomLineView.superview!.right - 15
            bottomLineView.top      == addNewButton.bottom
            bottomLineView.height   == 1
            
            tableView.left          == tableView.superview!.left
            tableView.right         == tableView.superview!.right
            tableView.top           == bottomLineView.bottom
            tableView.bottom        == tableView.superview!.bottom
        }
        
        tableView.reloadData()
    }
    
    func addNewHabit() {
        var habitEditViewController : HabitEditViewController = HabitEditViewController()
        self.navigationController?.pushViewController(habitEditViewController, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitManager.get().count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HabitTypeTableViewCell.Static.heightForCell(habitManager.get()[indexPath.row])
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:HabitTypeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(kReusableHabitTypeCellIdentifier, forIndexPath: indexPath) as HabitTypeTableViewCell
        cell.setHabit(habitManager.get()[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var habitDetailViewController : HabitDetailViewController = HabitDetailViewController()
        habitDetailViewController.setHabit(habitManager.get()[indexPath.row])
        self.navigationController?.pushViewController(habitDetailViewController, animated: true)
    }
}

class HabitTypeTableViewCell: UITableViewCell {
    
    var descriptionLabel:UILabel!
    
    var habit:Habit!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.separatorInset = UIEdgeInsetsMake(0, Static.habitLeftMargin, 0, Static.habitLeftMargin)
        self.preservesSuperviewLayoutMargins = false;
        self.layoutMargins = UIEdgeInsetsZero
        self.contentView.backgroundColor = UIColor.clearColor()
        
        let assesoryView: UIImageView = UIImageView(image: UIImage(named: "disclosure"))
        self.accessoryView = assesoryView
        
        addViews()
    }
    
    func addViews() {
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
        
        setLayout()
    }
    
    func setLayout() {
        let width:CGFloat = UIScreen.mainScreen().bounds.size.width - Static.habitLeftMargin - Static.habitRightMargin
        let descriptionLabelHeight:CGFloat = StringUtils.Static.heightForText(habit.description(), font: Static.habitDescriptionFont, width: width)
        
        constrain(descriptionLabel) { descriptionLabel in
            descriptionLabel.left       == descriptionLabel.superview!.left + Static.habitLeftMargin
            descriptionLabel.top        == descriptionLabel.superview!.top + Static.habitVerticalMargin
            descriptionLabel.height     == descriptionLabelHeight
            descriptionLabel.width      == width
        }
    }
    
    struct Static {
        static let habitLeftMargin:CGFloat = 15
        static let habitVerticalMargin:CGFloat = 20
        static let habitRightMargin:CGFloat = 52
        
        static let habitDescriptionFont: UIFont = UIFont(name: "Lato-Light", size: 15)!
        
        static func heightForCell(habit:Habit) -> CGFloat {
            let width:CGFloat = UIScreen.mainScreen().bounds.size.width - habitLeftMargin - habitRightMargin
            let descriptionLabelHeight:CGFloat = StringUtils.Static.heightForText(habit.description(), font: habitDescriptionFont, width: width)
            
            return (habitVerticalMargin + descriptionLabelHeight + habitVerticalMargin)
        }
    }
}