//
//  String+JSONConvert.swift
//  APIHelper
//
//  Created by Sandeep Malhotra on 13/09/17.
//  Copyright © 2017 Sandeep Malhotra. All rights reserved.
//

import Foundation

extension String {
    
    func convertToDictionary() -> Any? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func validateEmail(_ candidate: String) -> Bool {
        
        // NOTE: validating email addresses with regex is usually not the best idea.
        // This implementation is for demonstration purposes only and is not recommended for production use.
        // Regex source and more information here: http://emailregex.com
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
}

extension Data {
    func convertToJSONArray() -> Any? {
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    self, options: [])
                return jsonResponse
            } catch {
                print(error.localizedDescription)
            }
        return nil
    }

}
