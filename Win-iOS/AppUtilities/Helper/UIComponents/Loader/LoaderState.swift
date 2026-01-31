//
//
//  LoaderState.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

enum LoaderState {
    case hidden
    case loading
    case empty(message: String)
    case error(message: String)
}
