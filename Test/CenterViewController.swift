//
//  CenterViewController.swift
//  Test
//
//  Created by Sutan on 3/18/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController, SidePanelViewControllerDelegate {

    var delegate: CenterViewControllerDelegate?
    
    func groupSelected(group:Group) {
        delegate?.collapseSidePanels!()
        var alertController = UIAlertController(title: "Selected Group", message: group.name(), preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.parentViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Button actions
    
    func leftTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    func rightTapped(sender: AnyObject) {
        delegate?.toggleRightPanel?()
    }

}
