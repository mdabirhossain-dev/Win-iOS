//
//
//  RateAppManager.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 28/12/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//



import UIKit
import StoreKit

enum RateAppManager {

    // ✅ Put your real App Store ID here (not bundle id)
    static let appID = "1481808365"

    // Tuning (don’t be annoying)
    private static let minDaysBetweenPrompts = 14
    private static let maxPromptsTotal = 3

    private static let lastPromptDateKey = "rate.lastPromptDate"
    private static let promptCountKey = "rate.promptCount"

    /// Call this on a meaningful action (e.g. user taps a “success” cell).
    static func requestReviewIfAppropriate(force: Bool = false) {
        if !force, !shouldPrompt() { return }

        guard let scene = activeWindowScene else {
            // No active scene -> fallback to App Store review page
            openWriteReviewPage()
            markPrompted()
            return
        }

        // Apple may still ignore it (rate limit). That's normal.
        SKStoreReviewController.requestReview(in: scene)
        markPrompted()
    }

    /// Use this when you want to ALWAYS take them to the review page (e.g. a “Rate us” menu item).
    static func openWriteReviewPage() {
        guard let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    // MARK: - Helpers

    private static func shouldPrompt() -> Bool {
        let defaults = UserDefaults.standard

        let count = defaults.integer(forKey: promptCountKey)
        if count >= maxPromptsTotal { return false }

        if let last = defaults.object(forKey: lastPromptDateKey) as? Date {
            let days = Calendar.current.dateComponents([.day], from: last, to: Date()).day ?? 0
            if days < minDaysBetweenPrompts { return false }
        }

        return true
    }

    private static func markPrompted() {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: lastPromptDateKey)
        defaults.set(defaults.integer(forKey: promptCountKey) + 1, forKey: promptCountKey)
    }

    private static var activeWindowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })
    }
}
