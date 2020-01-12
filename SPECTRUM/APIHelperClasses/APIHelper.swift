//
//  APIHelper.swift
//  ApiCalling
//
//  Created by Sandeep Malhotra on 04/12/17.
//  Copyright © 2017 Sandeep Malhotra. All rights reserved.
//

import UIKit

enum HttpMethod : String {
    case  GET
    case  POST
    case  DELETE
    case  PUT
}

class APIHelper: NSObject {
    
    // MARK: - Shared Instance
    
    static let sharedInstance: APIHelper = {
        let instance = APIHelper()
        // setup code
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init() {
        super.init()
    }
    
    func makeGetApiCallWithMethod(withMethod methodName: String, successHandler: @escaping (_ responseData: Data? ,_ error: Error?) -> Void, failureHandler: @escaping (_ strMessage: String,_ error: Error?) -> Void) {
        
        let urlString = Constants.BASEURL + methodName
        let stringEncode = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let myURL = NSURL(string: stringEncode!)!
        let request = NSMutableURLRequest(url: myURL as URL)
        request.httpMethod = HttpMethod.GET.rawValue
        
        request.setValue(Constants.ContentTypeJSON, forHTTPHeaderField: Constants.AcceptKey)
        request.setValue(Constants.ContentTypeJSON, forHTTPHeaderField: Constants.ContentType)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            // Your completion handler code here
            if let dataReceived = data {
                successHandler(dataReceived, nil)
            } else {
                failureHandler("Some error occured", error)
            }
        }
        task.resume()
    }
}
