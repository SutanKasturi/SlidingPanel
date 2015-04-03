//
//  AlertViewController.swift
//  Test
//
//  Created by Sutan on 3/2/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var notificationManager : NotificationManagerClass!
    var tableView : UITableView!
    
    override func loadView() {
        self.view = UIView()
        
        notificationManager = NotificationManagerClass()
        
        addTableView()
        addCircleProgressView()
    }

    func addCircleProgressView() {
        var circleProgressView: CircleProgressView = CircleProgressView(frame: CGRectMake(100, 10, 50, 50))
        circleProgressView.progress = Double(0.5)
        circleProgressView.backgroundColor = UIColor.redColor();
        self.view.addSubview(circleProgressView)
        var circleProgressView3: CircleProgressView = CircleProgressView(frame: CGRectMake(200, 10, 50, 50))
        circleProgressView3.progress = Double(0.01)
        self.view.addSubview(circleProgressView3)
        
        var circleProgressView1: CircleProgressView = CircleProgressView(frame: CGRectMake(100, 100, 150, 150))
        circleProgressView1.progress = Double(1.30)
        self.view.addSubview(circleProgressView1)
        
        var circleProgressView2: CircleProgressView = CircleProgressView(frame: CGRectMake(100, 300, 200, 200))
        circleProgressView2.progress = Double(1)
        self.view.addSubview(circleProgressView2)
    }
    
    func addTableView() {
        self.view.backgroundColor = UIColor.whiteColor()
        tableView = UITableView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView);
        self.tableView.registerClass(AlertTableViewCell.self, forCellReuseIdentifier: "cell")
        
        constrain(tableView) {tableView in
            tableView.left      == tableView.superview!.left
            tableView.right     == tableView.superview!.right
            tableView.top       == tableView.superview!.top + UIApplication.sharedApplication().statusBarFrame.size.height
            tableView.bottom    == tableView.superview!.bottom
        }
        
        UIView.animateWithDuration(0.5, animations: self.view.layoutIfNeeded)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationManager.numberOfNotifications()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (AlertTableViewCell.Static.heightForCell(notificationManager.notification(indexPath.row)))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:AlertTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as AlertTableViewCell
        cell.setNotification(notificationManager.notification(indexPath.row))
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false;
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

class AlertTableViewCell: UITableViewCell {
    
    var cellImageView: UIImageView!
    var cellLabel: UILabel!
    var nameLabel: UILabel!
    
    var notification : Notification!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
    }
    
    func addViews() {
        cellImageView = UIImageView()
        cellImageView.backgroundColor       = UIColor.grayColor()
        cellImageView.layer.masksToBounds   = true
        cellImageView.layer.cornerRadius    = Static.imageSize / 2
        
        nameLabel = UILabel()
        nameLabel.font = Static.nameFont
        
        cellLabel = UILabel()
        cellLabel.font = Static.descriptionFont
        cellLabel.numberOfLines = 0
        cellLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        self.contentView.addSubview(cellImageView);
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(cellLabel)
    }
    
    func setNotification(notification: Notification) {
        self.notification = notification
        setLayout()
    }
    
    func setLayout() {
        let name: String = notification.user().displayName()
        let action: String = notification.action()
        let body: String = notification.body()
        
        cellImageView.image = notification.user().image()
        nameLabel.text = name
        
        constrain(cellImageView) { cellImageView in
            cellImageView.left      == cellImageView.superview!.left + Static.margin
            cellImageView.top       == cellImageView.superview!.top + Static.margin
            cellImageView.width     == Static.imageSize
            cellImageView.height    == Static.imageSize
        }
        
        let heightForImage = Static.margin + Static.imageSize + Static.margin
        let sizeForName = StringUtils.Static.sizeForText(name, font: Static.nameFont)
        
        if ( action.isEmpty ) {
            cellLabel.text = body
            
            let width = UIScreen.mainScreen().bounds.size.width - Static.margin - Static.imageSize - Static.margin - Static.margin
            let height = StringUtils.Static.heightForText(body, font: Static.nameFont, width: width)
            
            constrain(cellImageView, nameLabel, cellLabel) { cellImageView, nameLabel, cellLabel in
                nameLabel.left      == cellImageView.right + Static.margin
                nameLabel.top       == cellImageView.top
                nameLabel.right     == nameLabel.superview!.right - Static.margin
                nameLabel.height    == sizeForName.height
                
                cellLabel.left      == nameLabel.left
                cellLabel.top       == nameLabel.bottom + Static.padding
                cellLabel.height    == height
                cellLabel.width     == width
            }
        }
        else {
            cellLabel.text = action
            let width = UIScreen.mainScreen().bounds.size.width - Static.margin - Static.imageSize - Static.margin - sizeForName.width - Static.padding - Static.margin
            let height = StringUtils.Static.heightForText(action, font: Static.descriptionFont, width: width)
            constrain(cellImageView, nameLabel, cellLabel) { cellImageView, nameLabel, cellLabel in
                nameLabel.left      == cellImageView.right + Static.margin
                nameLabel.width     == sizeForName.width
                nameLabel.height    == sizeForName.height
                nameLabel.centerY   == cellImageView.centerY
                
                cellLabel.left      == nameLabel.right + Static.padding
                cellLabel.top       == nameLabel.top
                cellLabel.height    == height
                cellLabel.width     == width
            }
        }
    }
    
    struct Static {
        static let nameFont: UIFont = UIFont(name: "Lato-Regular", size: 15.0)!
        static let descriptionFont: UIFont = UIFont(name: "Lato-Light", size: 15)!
        static let imageSize: CGFloat = 40.0
        static let margin: CGFloat = 12.0
        static let padding: CGFloat = 4.0
        
        static func heightForCell(notification:Notification) -> CGFloat {
            let name: String = notification.user().displayName()
            let action: String = notification.action()
            let body: String = notification.body()
            
            let heightForImage = margin + imageSize + margin
            let sizeForName = StringUtils.Static.sizeForText(name, font: nameFont)
            
            if ( action.isEmpty ) {
                let width = UIScreen.mainScreen().bounds.size.width - margin - imageSize - margin - margin
                let height = margin + sizeForName.height + padding + StringUtils.Static.heightForText(body, font: descriptionFont, width: width) + margin
                return max(heightForImage, height)
            }
            else {
                let width = UIScreen.mainScreen().bounds.size.width - margin - imageSize - margin - sizeForName.width - padding - margin
                let height = margin + sizeForName.height + padding + StringUtils.Static.heightForText(action, font: descriptionFont, width: width) + margin
                return max(heightForImage, height)
            }
        }
    }
}
