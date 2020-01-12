//
//  ApiManager.swift
//  Fandex
//
//  Created by Sandeep Malhotra on 01/09/18.
//  Copyright © 2018 Sandeep Malhotra. All rights reserved.
//

import Foundation

protocol SpectrumProtocol {
    func companyResponseReceived(withResponse responseArray: [CompaniesAndMembersResponse]?, withError error: Error?)
}

class APIManager: NSObject {
    
    // MARK: - Shared Instance
    
    static let sharedInstance: APIManager = {
        let instance = APIManager()
        // setup code
        return instance
    }()
    
    var spectrumDelegate: SpectrumProtocol?
    
    // MARK: - Initialization Method
    
    override init() {
        super.init()
    }
    
    func conformToSpectrumProtocol(withDelegate delegateReceived: SpectrumProtocol?) {
        if let delegate = delegateReceived {
            self.spectrumDelegate = delegate
        }
    }
    
    func callGetClubDetailsAPI() {
        APIHelper.sharedInstance.makeGetApiCallWithMethod(withMethod: "", successHandler: { (data, error) in
            if let delegate = self.spectrumDelegate {
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return
                }
                do {
                    let companiesAndMembers = try! JSONDecoder().decode([CompaniesAndMembersResponse].self, from: dataResponse)
                    delegate.companyResponseReceived(withResponse: companiesAndMembers, withError: nil)
                } catch {
                    delegate.companyResponseReceived(withResponse: nil, withError: nil)
                    print("Error \(error.localizedDescription)")
                }
                
            } else {
                fatalError("Please Confirm to Protocol SpectrumProtocol")
            }
        }) { (errorMessage, error) in
            if let delegate = self.spectrumDelegate {
                delegate.companyResponseReceived(withResponse: nil, withError: error)
            } else {
                fatalError("Please Confirm to Protocol SpectrumProtocol")
            }
        }
    }
}
