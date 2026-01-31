//
//
//  BinaryInteger + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 8/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

extension BinaryInteger {
    /// Converts the integer to String and removes a leading "88"/"৮৮" if present.
    /// Returns a String so leading zeros are preserved.
    func dropLeading88() -> String {
        return String(self).dropLeading88()
    }
}
