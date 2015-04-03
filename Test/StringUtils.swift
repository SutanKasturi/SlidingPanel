//
//  StringUtils.swift
//  Test
//
//  Created by Sutan on 3/6/15.
//  Copyright (c) 2015 Sutan. All rights reserved.
//

import UIKit

class StringUtils: NSObject {
    struct Static {
        static func heightForText(text:String, font:UIFont, width:CGFloat) -> CGFloat{
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.font = font
            label.text = text
            
            label.sizeToFit()
            return label.frame.height
        }
        
        static func sizeForText(text:String, font:UIFont) -> CGSize{
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.max, CGFloat.max))
            label.font = font
            label.text = text
            
            label.sizeToFit()
            return label.frame.size
        }
    }
}
