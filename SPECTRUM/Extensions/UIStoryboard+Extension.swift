//
//  UIStoryboard+Extension.swift
//  Oriens
//
//  Created by Sandeep Malhotra on 11/09/18.
//  Copyright © 2018 Sandeep Malhotra. All rights reserved.
//

import Foundation
import UIKit

enum StoryName:String{
    case main = "Main"
}

extension UIStoryboard{
    
    convenience init(name:StoryName, bundle:Bundle? = nil) {
        self.init(name:name.rawValue, bundle: bundle)
    }
}
