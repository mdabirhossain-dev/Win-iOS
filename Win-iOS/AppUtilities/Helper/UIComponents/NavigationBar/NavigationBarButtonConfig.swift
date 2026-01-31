//
//
//  NavigationBarButtonConfig.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 9/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

public struct NavigationBarButtonConfig {
    public var title: String? = nil
    public var image: UIImage? = nil
    public var renderingMode: UIImage.RenderingMode? = nil
    public var accessibility: String? = nil
    
    public init(
        title: String? = nil,
        image: UIImage? = nil,
        renderingMode: UIImage.RenderingMode = .alwaysTemplate,
        accessibility: String? = nil
    ) {
        self.title = title
        self.image = image
        self.renderingMode = renderingMode
        self.accessibility = accessibility
    }
}

