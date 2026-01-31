//
//
//  ShareSheetAction.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 29/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

//// MARK: - Reusable Share Action
//struct ShareSheetAction {
//    let itemsProvider: () -> [Any]
//    var excludedActivityTypes: [UIActivity.ActivityType]? = nil
//    var onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil
//
//    func perform(from presenter: UIViewController, sourceView: UIView?) {
//        let items = itemsProvider()
//        guard !items.isEmpty else { return }
//
//        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
//        vc.excludedActivityTypes = excludedActivityTypes
//        vc.completionWithItemsHandler = onComplete
//
//        // iPad: must anchor popover, otherwise it can crash.
//        if let popover = vc.popoverPresentationController {
//            popover.sourceView = sourceView ?? presenter.view
//            popover.sourceRect = (sourceView ?? presenter.view).bounds
//        }
//
//        presenter.present(vc, animated: true)
//    }
//}
