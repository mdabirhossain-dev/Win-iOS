//
//
//  URLRequest + Extension.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 19/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

extension URLRequest {
    var curlString: String {
        var components = ["curl"]
        
        // Method
        if let method = httpMethod {
            components.append("-X \(method)")
        }
        
        // Headers
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                components.append("-H \"\(key): \(value)\"")
            }
        }
        
        // Body
        if let bodyData = httpBody,
           let bodyString = String(data: bodyData, encoding: .utf8) {
            // Escape double quotes in the body
            let escapedBody = bodyString.replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-d \"\(escapedBody)\"")
        }
        
        // URL
        if let url = url {
            components.append("\"\(url.absoluteString)\"")
        }
        
        return components.joined(separator: " \\\n\t")
    }
}
