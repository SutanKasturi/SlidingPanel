//
//  HabitDetailViewController.swift
//  Test
//
//  Created by Sutan on 3/13/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

class HabitDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let kReusableHabitDetailCellIdentifier : String = "habitDetailCellIdentifier"
    let kHabitDetailTitle : String = "habit_detail_title"
    let kHabitDetailContent : String = "habit_detail_content"
    
    var habit : Habit!
    var tableView : UITableView!
    var habitDetails : NSMutableArray!
    
    override func loadView() {
        self.view = UIView()
        
        makeLayout()
        
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
        
        let editButton: UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Bordered, target: self, action: "rightNavButtonClick")
        self.navigationItem.setRightBarButtonItem(editButton, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func leftNavButtonClick(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rightNavButtonClick() {
        var habitEditViewController : HabitEditViewController = HabitEditViewController()
        habitEditViewController.setHabit(self.habit)
        self.navigationController?.pushViewController(habitEditViewController, animated: true)
    }
    
    func setHabit(habit:Habit) {
        self.habit = habit
        habitDetails = NSMutableArray()
        
        habitDetails.addObject([kHabitDetailTitle: "Habit", kHabitDetailContent: habit.description()])
        habitDetails.addObject([kHabitDetailTitle: "Why?", kHabitDetailContent: habit.whyDescription()])
        habitDetails.addObject([kHabitDetailTitle: "How can I scale this habit?", kHabitDetailContent: habit.scaleDescription()])
        habitDetails.addObject([kHabitDetailTitle: "What can I piggyback off of?", kHabitDetailContent: habit.piggybackDescription()])
    }
    
    func makeLayout() {
        self.view.backgroundColor = UIColor.whiteColor()
        
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
        
        constrain(tableView) { tableView in
            tableView.left      == tableView.superview!.left
            tableView.right     == tableView.superview!.right
            tableView.top       == tableView.superview!.top
            tableView.bottom    == tableView.superview!.bottom
        }
        
        tableView.reloadData()
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
