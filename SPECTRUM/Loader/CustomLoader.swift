//
//  CustomLoader.swift
//  Fandex
//
//  Created by Sandeep Malhotra on 02/09/18.
//  Copyright © 2018 Sandeep Malhotra. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialActivityIndicator

class CustomLoader: NSObject {

    let activityIndicator = MDCActivityIndicator()

    // MARK: - Shared Instance

    static let sharedInstance: CustomLoader = {
        let instance = CustomLoader()
        // setup code
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init() {
        super.init()
    }
    
    func addLoader(onView sourceView: UIView?) {
        if let view = sourceView {
            DispatchQueue.main.async {
                self.activityIndicator.sizeToFit()
                self.activityIndicator.progress = 0.5
                self.activityIndicator.cycleColors = [.blue, .red, .green, .yellow]
                view.addSubview(self.activityIndicator)
                view.bringSubviewToFront(self.activityIndicator)
                self.activityIndicator.center = view.center
                self.startAnimatingLoader()
            }
        }
    }
    
    func removeLoader() {
        self.stopAnimatingLoader()
    }
    
    func startAnimatingLoader() {
        // To make the activity indicator appear:
        self.activityIndicator.startAnimating()
    }
    
    func stopAnimatingLoader() {
        // To make the activity indicator disappear:
        self.activityIndicator.stopAnimating()
    }
    
    
}
