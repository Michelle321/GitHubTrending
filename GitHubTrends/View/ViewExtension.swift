//
//  ViewExtension.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-06.
//  Copyright © 2019 Michelle. All rights reserved.
//

import UIKit

@IBDesignable extension UIView {

    @IBInspectable var borderColor: UIColor? {
        set{
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor{
                return UIColor(cgColor: color)
            }else{
                return nil
            }
        }
    }

    @IBInspectable var borderWidth : CGFloat{
        set{
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
}

