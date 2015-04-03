//
//  SidePanelViewController.swift
//  Test
//
//  Created by Sutan on 3/18/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

protocol SidePanelViewControllerDelegate {
    func groupSelected(group: Group)
}

class GroupManagerClass {
    var _name: String = "Coach Stevo"
    var _image: String = "Stevo"
    
    var _groups = [
        Group(name:"Alpha", numberOfMembers:40),
        Group(name:"Bravo", numberOfMembers:32),
        Group(name:"Charlie", numberOfMembers:38),
        Group(name:"Delta", numberOfMembers:10)
    ]
    func get() -> [Group] { return(_groups); }
    
    func name() -> String { return(_name) }
    
    func image() -> UIImage? { return(UIImage(named: _image)) }
}

class Group {
    var _name:String!
    var _numberOfMembers:Int!
    
    init(name:String, numberOfMembers:Int) {
        _name = name
        _numberOfMembers = numberOfMembers
    }
    
    func name() -> String { return(_name) }
    func numberOfMembers() -> Int { return(_numberOfMembers) }
}

class SidePanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var delegate: SidePanelViewControllerDelegate?
    
    var groupManager : GroupManagerClass!
    var tableView : UITableView!
    
    let tintColor:UIColor = UIColorFromRGB(0xD4AF37)
    
    let kReusableSettingCellIdentifier : String = "settingCellIdentifier"
    let kReusableGroupCellIdentifier : String = "groupCellIdentifier"
    let kReusableEmptyCellIdentifier : String = "emptyCellIdentifier"
    
    override func loadView() {
        self.view = UIView()
        groupManager = GroupManagerClass()
        
        addTableView()
    }
    
    func addTableView() {
        
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.backgroundColor = UIColor.whiteColor()
        tableView = UITableView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.tintColor = tintColor
        tableView.delegate = self
        tableView.dataSource = self
        
        let habitSelectedBgColor:UIColor = UIColorFromRGB(0xFBF5E3)
        let selectedColorView = UIView()
        selectedColorView.backgroundColor = habitSelectedBgColor
        UITableViewCell.appearance().selectedBackgroundView = selectedColorView
        
        self.view.addSubview(tableView);
        self.tableView.registerClass(SettingsTableViewCell.self, forCellReuseIdentifier: kReusableSettingCellIdentifier)
        self.tableView.registerClass(GroupTableViewCell.self, forCellReuseIdentifier: kReusableGroupCellIdentifier)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kReusableEmptyCellIdentifier)
        
        layout(tableView) {tableView in
            tableView.left      == tableView.superview!.left
            tableView.right     == tableView.superview!.right
            tableView.top       == tableView.superview!.top
            tableView.bottom    == tableView.superview!.bottom
        }
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groupManager == nil ? 0 : groupManager.get().count > 0 ? 2 : 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return groupManager.get().count + 1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 41
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 186
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 10
            }
            else {
                return 70
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let margin:CGFloat = 20
            let width:CGFloat = 200
            let height:CGFloat = 41
            
            var headerFrame:CGRect = tableView.frame
            var sectionHeaderLabel:UILabel = UILabel(frame: CGRectMake(margin, 0, width, height))
            sectionHeaderLabel.text = "\(groupManager.name())'s Groups"
            sectionHeaderLabel.textColor = UIColorFromRGB(0xBEBEBE)
            sectionHeaderLabel.font = UIFont(name: "Lato-Light", size: 14)!
            
            var sectionHeaderTopLine:UIView = UIView(frame: CGRectMake(0, 0, width, 1))
            sectionHeaderTopLine.backgroundColor = UIColorFromRGB(0xD8D8D8)
            
            var sectionHeaderBottomLine:UIView = UIView(frame: CGRectMake(0, height - 1, width, 1))
            sectionHeaderBottomLine.backgroundColor = UIColorFromRGB(0xD8D8D8)
            
            var headerView:UIView = UIView(frame: CGRectMake(0, 0, headerFrame.size.width, headerFrame.size.height))
            headerView.addSubview(sectionHeaderLabel)
            headerView.addSubview((sectionHeaderTopLine))
            headerView.addSubview((sectionHeaderBottomLine))
            headerView.backgroundColor = UIColorFromRGB(0xF8F8F8)
            
            return headerView
        }
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell:SettingsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(kReusableSettingCellIdentifier, forIndexPath: indexPath) as SettingsTableViewCell
            cell.setSettingImage(groupManager.image())
            return cell
        }
        else {
            if indexPath.row == 0 {
                var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(kReusableEmptyCellIdentifier, forIndexPath: indexPath) as UITableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
            else {
                var cell:GroupTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(kReusableGroupCellIdentifier, forIndexPath: indexPath) as GroupTableViewCell
                cell.setGroup(groupManager.get()[indexPath.row - 1])
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row > 0 {
            delegate?.groupSelected(groupManager.get()[indexPath.row - 1])
        }
    }
}

class SettingsTableViewCell:UITableViewCell {
    
    var settingImageView: UIImageView!
    var settingButton: UIButton!
    
    var habit:Habit!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let habitSelectedBgColor:UIColor = UIColor.clearColor()
        let selectedColorView = UIView()
        selectedColorView.backgroundColor = habitSelectedBgColor
        self.selectedBackgroundView = selectedColorView
        
        addViews()
    }
    
    func addViews() {
        settingImageView = UIImageView()
        
        settingButton = UIButton()
        settingButton.setImage(UIImage(named: "gear"), forState: UIControlState.Normal)
        settingButton.setTitle("Settings", forState: UIControlState.Normal)
        settingButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        settingButton.titleEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 0)
        settingButton.setTitleColor(UIColorFromRGB(0xD4AF37), forState: UIControlState.Normal)
        settingButton.setTitleColor(UIColorFromRGB(0x7D6000), forState: UIControlState.Highlighted)
        
        self.contentView.addSubview(settingImageView)
        self.contentView.addSubview(settingButton)
    }
    
    func setSettingImage(image:UIImage?) {
        settingImageView.image = image
        setLayout()
    }
    
    func setLayout() {
        layout(settingImageView, settingButton) {settingImageView, settingButton in
            settingImageView.top        == settingImageView.superview!.top + 25
            settingImageView.width      == 100
            settingImageView.height     == 100
            settingImageView.left       == settingImageView.superview!.left + 50

            settingButton.top           == settingImageView.bottom + 14
            settingButton.width         == 100
            settingButton.height        == 40
            settingButton.centerX       == settingImageView.centerX
        }
    }
}

class GroupTableViewCell: UITableViewCell {
    
    var groupLabel: UILabel!
    var nameLabel: UILabel!
    var numbersOfMembersLabel: UILabel!
    
    var group: Group!
    
    let groupLabelFont : UIFont = UIFont(name: "Lato-Light", size: 30)!
    let nameLabelFont : UIFont = UIFont(name: "Lato-Light", size: 23)!
    let numbersOfMembersLabelFont : UIFont = UIFont(name: "Lato-Regular", size: 14)!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.clearColor()
        
        addViews()
    }
    
    func addViews() {
        groupLabel = UILabel()
        groupLabel.layer.backgroundColor = UIColorFromRGB(0xD4AF37).CGColor
        groupLabel.layer.masksToBounds = true
        groupLabel.font = groupLabelFont
        groupLabel.textAlignment = NSTextAlignment.Center
        groupLabel.textColor = UIColor.whiteColor()
        
        nameLabel = UILabel()
        nameLabel.font = nameLabelFont
        nameLabel.numberOfLines = 1
        nameLabel.textColor = UIColorFromRGB(0xD4AF37)
        
        numbersOfMembersLabel = UILabel()
        numbersOfMembersLabel.numberOfLines = 1
        numbersOfMembersLabel.font = numbersOfMembersLabelFont
        numbersOfMembersLabel.textColor = UIColorFromRGB(0xBEBEBE)
        
        self.contentView.addSubview(groupLabel)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(numbersOfMembersLabel)
    }
    
    func setGroup(group: Group) {
        self.group = group
        groupLabel.text = group.name()[0]
        nameLabel.text = group.name()
        numbersOfMembersLabel.text = "\(group.numberOfMembers()) members"
        setLayout()
    }
    
    func setLayout() {
        let margin:CGFloat = 20
        let padding:CGFloat = 14
        let verticalPadding: CGFloat = 10
        let groupLabelSize:CGFloat = 50
        
        let width:CGFloat = 200 - margin - groupLabelSize - padding
        let nameLabelHeight:CGFloat = 28
        let numbersOfMembersLabelHeight:CGFloat = 17
        
        groupLabel.layer.cornerRadius = groupLabelSize / 2
        
        layout(groupLabel, nameLabel, numbersOfMembersLabel) { groupLabel, nameLabel, numbersOfMembersLabel in
            groupLabel.left                 == groupLabel.superview!.left + margin
            groupLabel.top                  == groupLabel.superview!.top + verticalPadding
            groupLabel.width                == groupLabelSize
            groupLabel.height               == groupLabelSize
            
            nameLabel.left                  == groupLabel.right + padding
            nameLabel.top                   == groupLabel.top + 2
            nameLabel.width                 == width
            nameLabel.height                == nameLabelHeight
            
            numbersOfMembersLabel.left      == nameLabel.left
            numbersOfMembersLabel.top       == nameLabel.bottom
            numbersOfMembersLabel.width     == width
            numbersOfMembersLabel.height    == numbersOfMembersLabelHeight
        }
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}
