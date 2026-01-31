# Win-iOS Developer Documentation

This README is the **source of truth** for how we build screens, wire VIPER modules, and use shared UI components in this codebase.
If you ignore it, you will ship bugs and inconsistent UI.

---

## Table of Contents

- [Overview](#overview)
- [Requirements](#requirements)
- [Dependencies](#dependencies)
- [Architecture (VIPER)](#architecture-viper)
- [Coding Standards (Non-Negotiable)](#coding-standards-non-negotiable)
- [ViewController Template (Skeleton)](#viewcontroller-template-skeleton)
- [Reusable Components Cookbook](#reusable-components-cookbook)
  - [Networking (GET / POST / DELETE)](#networking-get--post--delete)
  - [Keychain + First Launch Reset](#keychain--first-launch-reset)
  - [Image Loader + Memory Cache](#image-loader--memory-cache)
  - [Loader Overlay (Loading / Empty / Error)](#loader-overlay-loading--empty--error)
  - [Toast](#toast)
  - [Alert](#alert)
  - [TextField (WinTextField)](#textfield-wintextfield)
  - [TextView (WinTextView)](#textview-wintextview)
  - [Input Limiter](#input-limiter)
  - [Terms & Conditions View](#terms--conditions-view)
  - [Buttons (WinButton)](#buttons-winbutton)
  - [Navigation Bar](#navigation-bar)
  - [Routing (ViewControllerType)](#routing-viewcontrollertype)
  - [Custom Tab Bar (FloatingBarView)](#custom-tab-bar-floatingbarview)
- [Testing Policy](#testing-policy)
- [Demo: NewPassword Module](#demo-newpassword-module)
- [Known Pitfalls / Tech Debt](#known-pitfalls--tech-debt)
- [Contribution Checklist](#contribution-checklist)
- [Project Structure (Full Tree)](#project-structure-full-tree)

---

## Overview

- **UIKit, programmatic UI** (no storyboards for screens).
- **VIPER** for modules.
- A **shared component library** under `AppUtilities/Helper/UIComponents`.
- **Non-negotiable layout rules**: constraints live inside **one** `NSLayoutConstraint.activate([])` block, and view config lives inside `setupView()`.

---

## Requirements

- Xcode: latest stable (match team’s standard).
- iOS Deployment Target: project setting (do not randomly bump).
- Swift: project setting (do not “upgrade” language mode alone).
- Run: `Win-iOS` scheme.

---

## Dependencies

- `Lottie` (via Swift Package Manager).

---

## Architecture (VIPER)

**File layout per module**
- `View/` (or `Views/`): `ViewController`
- `Presenter`
- `Interactor`
- `Router`
- `Entity` (models used by that module)
- `Protocols` (or `Protocol`) — view/presenter/interactor/router contracts
- `Tests/` — presenter tests are preferred

**Rules**
- ViewController is dumb UI: no API calls, no business logic.
- Presenter owns state + orchestration.
- Interactor owns business logic + network/storage calls.
- Router owns navigation and module creation.

---

## Coding Standards (Non-Negotiable)

### 1) UI properties must be computed-property style
Do this:

```swift
private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .label
    label.font = .winFont(.semiBold, size: .medium)
    label.numberOfLines = 0
    return label
}()
```

Don’t do scattered configuration in `viewDidLoad()`.

### 2) All view setup lives in `setupView()`
- Add subviews
- Set properties
- Set targets/delegates
- Build stack views

### 3) ALL constraints go in one place
Put every constraint inside a **single** `NSLayoutConstraint.activate([ ... ])` block.

Bad: constraints in `layoutSubviews`, constraints sprinkled across methods, constraints activated one-by-one.

### 4) Keep naming readable
Inside computed properties use `label`, `button`, `stackView`, `tableView`, `collectionView`, etc.  
Don’t name everything `view1`, `container2`, `wrapperFinal`.

### 5) No unnecessary wrapper views
If `UIStackView` can do it, use it. Don’t wrap views just to feel productive.

---

## ViewController Template (Skeleton)

Use this as a baseline for new screens.

```swift
final class ViewController: UIViewController {

    // MARK: - VIPER
    var presenter: PresenterProtocol?

    // MARK: - UI
    private let rootScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let primaryButton: WinButton = {
        let button = WinButton(background: .solid(.wcVelvet))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        return button
    }()

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter?.viewDidLoad()
    }

    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .wcBackground

        view.addSubview(rootScrollView)
        rootScrollView.addSubview(rootStackView)
        rootStackView.addArrangedSubview(primaryButton)

        primaryButton.addTarget(self, action: #selector(didTapPrimary), for: .touchUpInside)

        NSLayoutConstraint.activate([
            rootScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rootScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rootScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            rootStackView.topAnchor.constraint(equalTo: rootScrollView.topAnchor, constant: 16),
            rootStackView.leadingAnchor.constraint(equalTo: rootScrollView.leadingAnchor, constant: 16),
            rootStackView.trailingAnchor.constraint(equalTo: rootScrollView.trailingAnchor, constant: -16),
            rootStackView.bottomAnchor.constraint(equalTo: rootScrollView.bottomAnchor, constant: -16),
            rootStackView.widthAnchor.constraint(equalTo: rootScrollView.widthAnchor, constant: -32),

            primaryButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    // MARK: - Actions
    @objc private func didTapPrimary() {
        presenter?.didTapPrimary()
    }
}
```

---

## Reusable Components Cookbook

### Networking

**Non‑negotiable rules**
- Networking lives in **Interactor** (never in `UIViewController`, never in Presenter).
- Interactor returns **Entities / simple primitives** to Presenter via `output`.
- Always decode into `APIResponse<T>` (your server envelope), then read `status/message/error/data`.
- Keep UI thread work inside `await MainActor.run { ... }`.

Your `NetworkClient` exposes:
- `get/post/put/delete/patch` (async/await)
- a completion-based `request(...)` (legacy / bridging)

#### POST example (Interactor → output)

```swift
final class NewPasswordInteractor: NewPasswordInteractorProtocol {

    weak var output: NewPasswordInteractorOutput?

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func setPassword(request: ResetPasswordRequest) {
        Task { [weak self] in
            guard let self else { return }

            var req = APIRequest(path: APIConstants.updatePasswordURL)
            // You can omit this because `post(req)` forces POST anyway,
            // but keeping it is fine if it helps readability:
            req.method = .post
            req.body = request

            do {
                let response: APIResponse<EmptyData> = try await self.networkClient.post(req)

                await MainActor.run {
                    if response.status == 200 {
                        self.output?.setPasswordSucceeded()
                    } else {
                        self.output?.setPasswordFailed(
                            response.message ?? response.error ?? "পাসওয়ার্ড আপডেট ব্যর্থ হয়েছে"
                        )
                    }
                }
            } catch {
                await MainActor.run {
                    self.output?.setPasswordFailed("পাসওয়ার্ড আপডেট ব্যর্থ হয়েছে")
                }
            }
        }
    }
}
```

#### GET example (Interactor → output)

```swift
func fetchRedemptionLeaderboard() {
    Task { [weak self] in
        guard let self else { return }

        var request = APIRequest(path: APIConstants.redemptionLeaderboardURL)
        request.method = .get

        do {
            let response: APIResponse<RedemptionLeaderboard> = try await networkClient.get(request)

            await MainActor.run {
                if let data = response.data {
                    self.output?.redemptionLeaderboardFetched(data)
                } else {
                    self.output?.redemptionLeaderboardFailed(
                        response.message ?? response.error ?? "Leaderboard পাওয়া যায়নি"
                    )
                }
            }
        } catch {
            await MainActor.run {
                self.output?.redemptionLeaderboardFailed("নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
            }
        }
    }
}
```

#### DELETE / PUT / PATCH (same pattern)

```swift
func logout() {
    Task { [weak self] in
        guard let self else { return }

        var req = APIRequest(path: APIConstants.logoutURL)
        req.method = .delete

        do {
            let response: APIResponse<EmptyData> = try await networkClient.delete(req)

            await MainActor.run {
                if response.status == 200 {
                    self.output?.logoutSucceeded()
                } else {
                    self.output?.logoutFailed(response.message ?? response.error ?? "Logout failed")
                }
            }
        } catch {
            await MainActor.run {
                self.output?.logoutFailed("নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন")
            }
        }
    }
}
```

**Gotchas (fix when you have time)**
- `NetworkClient` loads token once at init. If token can change (refresh/login), read token **per request** (or inject a `TokenProvider`).
- GET cache is in-memory `NSCache` keyed by `METHOD:URL`. That’s fine, but don’t assume disk persistence.


---

### Keychain + First Launch Reset

- Use `KeychainManager.shared` for `msisdn`, `password`, `token`.
- Call once at app launch:

```swift
KeychainManager.shared.handleFirstLaunchResetIfNeeded()
```

---

### Image Loader + Memory Cache

Use:

```swift
imageView.setImage(from: urlString, placeholder: UIImage(named: "placeholder"))
```

Notes:
- Memory cache is `NSCache` (evicts automatically).
- This is not disk cache. Don’t pretend it is.

---

### Loader Overlay (Loading / Empty / Error)

Attach to any VC via:

```swift
showLoader(.loading)

showLoader(.empty(message: "No items found"), retry: { [weak self] in
    self?.presenter?.reload()
})

showLoader(.error(message: "Network error"), retry: { [weak self] in
    self?.presenter?.reload()
})

showLoader(.hidden)
```

Use cases:
- Loading screen while calling API
- Empty list states
- Error states with retry

---

### Toast

**Use toast for**
- Non-blocking feedback
- Success messages
- Lightweight errors that do not require user decision

Examples:

```swift
Toast.show("Saved successfully", style: .success)
Toast.show("Something went wrong", style: .error)
Toast.show("Copied", style: .info)
```

When NOT to use toast:
- Destructive confirmation (use Alert)
- User must choose OK/Cancel (use Alert)
- You need to guarantee they read it

---

### Alert

**Use alert for**
- Blocking decisions: OK / Cancel
- Destructive actions
- Critical errors that require user acknowledgement

**Success (OK)**

```swift
Alert.show(
    AlertConfig(
        title: "Success",
        message: "Your password was updated",
        icon: .lottie(.success, loop: .loop, speed: 1.0),
        buttons: .ok(title: "OK")
    ),
    onOK: { [weak self] in
        self?.navigationController?.popToRootViewController(animated: true)
    }
)
```

**Error (OK)**

```swift
Alert.show(
    AlertConfig(
        title: "Error",
        message: "Please try again later",
        icon: .lottie(.failed, loop: .playOnce, speed: 1.0),
        buttons: .ok(title: "OK")
    )
)
```

**Confirm (OK / Cancel)**

> If your current `Alert` API doesn’t have it yet, add a `.okCancel(...)` preset.  
> Stop copy-pasting custom alerts everywhere.

```swift
Alert.show(
    AlertConfig(
        title: "Sign out?",
        message: "You will need to login again.",
        icon: .lottie(.warning, loop: .playOnce, speed: 1.0),
        buttons: .okCancel(ok: "Sign out", cancel: "Cancel")
    ),
    onOK: {
        /* sign out */
    },
    onCancel: {
        /* no-op */
    }
)
```

---

### TextField (WinTextField)

Use `WinTextField` for consistent styling + icon support.

```swift
private let phoneTextField: WinTextField = {
    let textField = WinTextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.borderColor = .gray
    textField.leftImage = UIImage(systemName: "phone")
    textField.rightImage = UIImage(systemName: "eye.slash")
    textField.rightImageColor = .gray
    textField.placeholder = "Phone"
    textField.keyboardType = .numberPad
    return textField
}()
```

**Known issue (fix it):** current implementation adds constraints in `layoutSubviews()`.  
That will spam constraints and eventually break layout. Move those constraints to the VC `NSLayoutConstraint.activate([...])` block.

---

### TextView (WinTextView)

Use for multi-line input with placeholder.

```swift
private let notesTextView: WinTextView = {
    let textView = WinTextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.placeholder = "Write here..."
    return textView
}()
```

---

### Input Limiter

Limit user input length without re-implementing delegate logic.

```swift
private let limiter = InputLimiter(maxLength: 120)
textField.delegate = limiter
// or
textView.delegate = limiter
```

---

### Terms & Conditions View

`TermsAndConditionsView` is a tappable rich-text view.

Use cases:
- Signup screen T&C
- Privacy policy deep links
- Any inline links inside a paragraph

```swift
termsView.fullText = "By continuing you agree to Terms and Privacy Policy."
termsView.links = [
    ("Terms", "https://example.com/terms"),
    ("Privacy Policy", "https://example.com/privacy")
]
termsView.onLinkTap = { url in
    // open WebView router
}
```

---

### Buttons (WinButton)

Use `WinButton` for consistent corner radius + background styles.

```swift
let button = WinButton(background: .solid(.wcVelvet))
button.setTitle("Continue", for: .normal)
```

Gradient:

```swift
button.setGradientBackground(colors: [.wcVelvet, .wcGreen])
```

---

### Navigation Bar

Use:

```swift
setupNavigationBar(
    projectIcon: (UIImage(named: "logo")!, .alwaysTemplate),
    projectName: "WIN",
    rightButtons: [
        .init(image: UIImage(systemName: "bell"), accessibility: "Notifications"),
        .init(title: "Help", accessibility: "Help")
    ],
    isBackButton: true,
    delegate: self
)
```

Delegate receives:
- back tap
- project tap
- right button index taps

---

### Routing (ViewControllerType)

If you use a central router type (`ViewControllerType`) keep it single-purpose:
- map routes → module creation
- no business logic

If routing starts containing “decision logic”, you already messed up VIPER.

---

### Custom Tab Bar (FloatingBarView)

Use for:
- custom tab animations
- badge counts
- floating pill UI

Don’t let screens “reach into” tab bar internals. Communicate via delegate/protocol.

---

## Testing Policy

- Presenter unit tests are mandatory for non-trivial modules.
- Interactor tests where business rules exist.
- UI tests only for critical flows.

---

## Demo: NewPassword Module

`NewPasswordViewController` follows the required pattern:
- `setupView()` builds UI
- one `NSLayoutConstraint.activate([...])`
- presenter called from actions
- loader overlay + alert used for feedback

---

## Known Pitfalls / Tech Debt

- `WinTextField.layoutSubviews()` activates constraints → must be removed.
- `UIImageView.setImage(...)` does not cancel old requests; consider cancellation if reused in table/collection cells.
- Improve `NetworkClient` error mapping to user-friendly messages (you already have `UserFacingErrorMapper`).

---

## Contribution Checklist

Before you open a PR:
- [ ] New screen uses VC skeleton rules.
- [ ] Constraints only inside `NSLayoutConstraint.activate`.
- [ ] No networking in VC or Presenter.
- [ ] VIPER files + protocols are complete.
- [ ] Added presenter tests (if logic exists).
- [ ] Toast vs Alert used correctly (no alert spam).

---

## Project Structure (Full Tree)

```text
{Win-iOS/
├─ Win-iOS/
│  ├─ AppSettings/
│  │  ├─ Constants/
│  │  │  ├─ APIConstants.swift
│  │  │  └─ AppConstants.swift
│  │  ├─ AppDelegate.swift
│  │  ├─ KeychainManager.swift
│  │  ├─ NetworkClient.swift
│  │  └─ SceneDelegate.swift
│  ├─ AppModules/
│  │  ├─ Authentication/
│  │  │  ├─ NewPassword/
│  │  │  │  ├─ Tests/
│  │  │  │  │  └─ NewPasswordPresenterTests.swift
│  │  │  │  ├─ View/
│  │  │  │  │  └─ NewPasswordViewController.swift
│  │  │  │  ├─ NewPasswordInteractor.swift
│  │  │  │  ├─ NewPasswordPresenter.swift
│  │  │  │  ├─ NewPasswordProtocols.swift
│  │  │  │  └─ NewPasswordRouter.swift
│  │  │  ├─ OtpVerification/
│  │  │  │  ├─ Tests/
│  │  │  │  ├─ Views/
│  │  │  │  ├─ OtpVerificationEntity.swift
│  │  │  │  ├─ OtpVerificationInteractor.swift
│  │  │  │  ├─ OtpVerificationPresenter.swift
│  │  │  │  ├─ OtpVerificationProtocol.swift
│  │  │  │  └─ OtpVerificationRouter.swift
│  │  │  ├─ ResetPassword/
│  │  │  │  ├─ Tests/
│  │  │  │  ├─ View/
│  │  │  │  │  └─ PasswordResetViewController.swift
│  │  │  │  ├─ PasswordResetInteractor.swift
│  │  │  │  ├─ PasswordResetPresenter.swift
│  │  │  │  ├─ PasswordResetProtocols.swift
│  │  │  │  └─ PasswordResetRouter.swift
│  │  │  ├─ SignIn/
│  │  │  │  ├─ Mocks/
│  │  │  │  ├─ Views/
│  │  │  │  │  └─ SignInViewController.swift
│  │  │  │  ├─ SignInEntity.swift
│  │  │  │  ├─ SignInInteractor.swift
│  │  │  │  ├─ SignInPresenter.swift
│  │  │  │  ├─ SignInPresenterProtocol.swift
│  │  │  │  └─ SignInRouter.swift
│  │  │  └─ SignUp/
│  │  │     ├─ Mocks/
│  │  │     ├─ Views/
│  │  │     │  └─ SignUpViewController.swift
│  │  │     ├─ SignUpEntity.swift
│  │  │     ├─ SignUpInteractor.swift
│  │  │     ├─ SignUpPresenter.swift
│  │  │     ├─ SignUpPresenterProtocol.swift
│  │  │     └─ SignUpRouter.swift
│  │  ├─ Common/
│  │  │  ├─ Layout/
│  │  │  │  ├─ CollectionSectionLayout.swift
│  │  │  │  └─ WrappingFlowLayout.swift
│  │  │  └─ SubView/
│  │  │     ├─ Alert.swift
│  │  │     ├─ LottieAnimationView.swift
│  │  │     ├─ SectionHeaderView.swift
│  │  │     ├─ Toast.swift
│  │  │     └─ WebView.swift
│  │  ├─ Home/
│  │  │  └─ Home/
│  │  │     ├─ Views/
│  │  │     │  ├─ CarouselFlowLayout.swift
│  │  │     │  ├─ Home_FreePointTableViewCell.swift
│  │  │     │  ├─ Home_Lakhopoti...downTableViewCell.swift
│  │  │     │  ├─ Home_OnlineGamesTableViewCell.swift
│  │  │     │  ├─ Home_PointTransferTableViewCell.swift
│  │  │     │  ├─ Home_TicTacToeTableViewCell.swift
│  │  │     │  ├─ Home_WatchLiveTableViewCell.swift
│  │  │     │  ├─ HomeBannerTableViewCell.swift
│  │  │     │  ├─ HomeBillboardCollectionViewCell.swift
│  │  │     │  ├─ HomeBillboardsTableViewCell.swift
│  │  │     │  ├─ HomeFeaturesTableViewCell.swift
│  │  │     │  ├─ HomeLudoMasterTableViewCell.swift
│  │  │     │  ├─ HomePromoCardTableViewCell.swift
│  │  │     │  ├─ HomeQuizCategoryTableViewCell.swift
│  │  │     │  ├─ HomeTopThreeTableViewCell.swift
│  │  │     │  ├─ HomeViewController.swift
│  │  │     │  └─ OnlineGamesViewController.swift
│  │  │     ├─ HomeEntity.swift
│  │  │     ├─ HomeInteractor.swift
│  │  │     ├─ HomePresenter.swift
│  │  │     ├─ HomeProtocols.swift
│  │  │     └─ HomeRouter.swift
│  │  ├─ Store/
│  │  │  ├─ View/
│  │  │  │  ├─ OTPConfirmationViewController.swift
│  │  │  │  ├─ PaymentPlansCollectionViewCell.swift
│  │  │  │  ├─ PaymentWalletCollectionViewCell.swift
│  │  │  │  ├─ PaymentWebViewController.swift
│  │  │  │  └─ StoreViewController.swift
│  │  │  ├─ PaymentWallet.swift
│  │  │  ├─ StoreInteractor.swift
│  │  │  ├─ StorePresenter.swift
│  │  │  ├─ StoreProtocols.swift
│  │  │  └─ StoreRouter.swift
│  │  ├─ LaunchScreen/
│  │  │  └─ LaunchScreenVC.swift
│  │  ├─ Onboarding/
│  │  │  └─ OnboardingVC.swift
│  │  └─ Profile/
│  │     ├─ GiftPoint/
│  │     │  ├─ View/
│  │     │  │  ├─ GiftPointViewController.swift
│  │     │  │  ├─ PointAmountQuickPickBar.swift
│  │     │  │  ├─ ScoreBreakdownView.swift
│  │     │  │  └─ SelectableChipBar.swift
│  │     │  ├─ GiftPointInteractor.swift
│  │     │  ├─ GiftPointPresenter.swift
│  │     │  ├─ GiftPointProtocols.swift
│  │     │  ├─ GiftPointRouter.swift
│  │     │  ├─ PointTransferRequest.swift
│  │     │  └─ UserInfo.swift
│  │     ├─ HelpAndSupport/
│  │     │  ├─ Tests/
│  │     │  ├─ View/
│  │     │  │  └─ HelpAndSupportViewController.swift
│  │     │  ├─ HelpAndSupportEntity.swift
│  │     │  ├─ HelpAndSupportInteractor.swift
│  │     │  ├─ HelpAndSupportPresenter.swift
│  │     │  ├─ HelpAndSupportProtocols.swift
│  │     │  └─ HelpAndSupportRouter.swift
│  │     ├─ Invitation/
│  │     │  ├─ InvitationHistory/
│  │     │  │  ├─ Tests/
│  │     │  │  ├─ View/
│  │     │  │  │  ├─ InvitationHistoryTableViewCell.swift
│  │     │  │  │  └─ InvitationHistoryViewController.swift
│  │     │  │  ├─ InvitationHistoryEntity.swift
│  │     │  │  ├─ InvitationHistoryInteractor.swift
│  │     │  │  ├─ InvitationHistoryPresenter.swift
│  │     │  │  ├─ InvitationHistoryProtocols.swift
│  │     │  │  └─ InvitationHistoryRouter.swift
│  │     │  └─ InvitationHome/
│  │     │     ├─ Tests/
│  │     │     ├─ View/
│  │     │     │  └─ InvitationViewController.swift
│  │     │     ├─ InvitationInteractor.swift
│  │     │     ├─ InvitationPresenter.swift
│  │     │     ├─ InvitationProtocols.swift
│  │     │     ├─ InvitationResponse.swift
│  │     │     └─ InvitationRouter.swift
│  │     ├─ PrivacyPolicy/
│  │     │  └─ PrivacyPolicyViewController.swift
│  │     ├─ ProfileMain/
│  │     │  ├─ Tests/
│  │     │  ├─ Views/
│  │     │  │  ├─ CampaignWiseScoreCell.swift
│  │     │  │  ├─ LakhpotiCampaignCell.swift
│  │     │  │  ├─ PointsCell.swift
│  │     │  │  ├─ ProfileOptionCell.swift
│  │     │  │  ├─ ProfileSignOutCell.swift
│  │     │  │  ├─ ProfileSocialInfoCollectionViewCell.swift
│  │     │  │  ├─ ProfileUserInfoCell.swift
│  │     │  │  ├─ ProfileUserProgressCell.swift
│  │     │  │  └─ ProfileViewController.swift
│  │     │  ├─ ProfileEntity.swift
│  │     │  ├─ ProfileInteractor.swift
│  │     │  ├─ ProfileInterface.swift
│  │     │  ├─ ProfilePresenter.swift
│  │     │  ├─ ProfileRouter.swift
│  │     │  └─ ProfileViewProtocol.swift
│  │     ├─ RedeemScore/
│  │     │  ├─ Tests/
│  │     │  ├─ View/
│  │     │  │  └─ RedeemScoreViewController.swift
│  │     │  ├─ RedeemScoreEntity.swift
│  │     │  ├─ RedeemScoreInteractor.swift
│  │     │  ├─ RedeemScorePresenter.swift
│  │     │  ├─ RedeemScoreProtocols.swift
│  │     │  └─ RedeemScoreRouter.swift
│  │     ├─ RequestPoint/
│  │     │  ├─ View/
│  │     │  │  └─ RequestPointViewController.swift
│  │     │  ├─ RequestPointEntity.swift
│  │     │  ├─ RequestPointInteractor.swift
│  │     │  ├─ RequestPointPresenter.swift
│  │     │  ├─ RequestPointProtocols.swift
│  │     │  └─ RequestPointRouter.swift
│  │     ├─ RulesAndRegulations/
│  │     │  └─ RulesAndRegulationsViewController.swift
│  │     ├─ SubscriptionHistory/
│  │     │  ├─ Tests/
│  │     │  ├─ Views/
│  │     │  │  ├─ SubscriptionHistoryTableViewCell.swift
│  │     │  │  └─ SubscriptionHistoryViewController.swift
│  │     │  ├─ SubscriptionHistoryEntity.swift
│  │     │  ├─ SubscriptionHistoryInteractor.swift
│  │     │  ├─ SubscriptionHistoryPresenter.swift
│  │     │  ├─ SubscriptionHistoryProtocol.swift
│  │     │  └─ SubscriptionHistoryRouter.swift
│  │     ├─ TotalPoints/
│  │     │  ├─ Tests/
│  │     │  ├─ View/
│  │     │  │  ├─ TotalPointAndSco...ownTableViewCell.swift
│  │     │  │  ├─ TotalPointAndScoreTableViewCell.swift
│  │     │  │  └─ TotalPointViewController.swift
│  │     │  ├─ TotalPointEntity.swift
│  │     │  ├─ TotalPointInteractor.swift
│  │     │  ├─ TotalPointPresenter.swift
│  │     │  ├─ TotalPointProtocols.swift
│  │     │  └─ TotalPointRouter.swift
│  │     ├─ TotalScore/
│  │     │  ├─ Tests/
│  │     │  ├─ View/
│  │     │  │  └─ TotalScoreViewController.swift
│  │     │  ├─ TotalScoreEntity.swift
│  │     │  ├─ TotalScoreInteractor.swift
│  │     │  ├─ TotalScorePresenter.swift
│  │     │  ├─ TotalScoreProtocols.swift
│  │     │  └─ TotalScoreRouter.swift
│  │     └─ UpdateProfile/
│  │        ├─ Tests/
│  │        ├─ View/
│  │        │  ├─ AvatarPickerViewController.swift
│  │        │  ├─ AvaterCollectionViewCell.swift
│  │        │  └─ UpdateProfileViewController.swift
│  │        ├─ UpdateProfileEntity.swift
│  │        ├─ UpdateProfileInteractor.swift
│  │        ├─ UpdateProfilePresenter.swift
│  │        ├─ UpdateProfileProtocols.swift
│  │        ├─ UpdateProfileRouter.swift
│  │        └─ UserFacingErrorMapper.swift
│  ├─ Scoreboard/
│  │  ├─ Tests/
│  │  ├─ Views/
│  │  │  ├─ ScoreboardCampaignsTableViewCell.swift
│  │  │  ├─ ScoreboardLeader...rdListTableViewCell.swift
│  │  │  ├─ ScoreboardMyPositionTableViewCell.swift
│  │  │  ├─ ScoreboardRedem...nnersTableViewCell.swift
│  │  │  ├─ ScoreboardTopThreeTableViewCell.swift
│  │  │  └─ ScoreboardViewController.swift
│  │  ├─ ScoreboardEntity.swift
│  │  ├─ ScoreboardInteractor.swift
│  │  ├─ ScoreboardPresenter.swift
│  │  ├─ ScoreboardProtocols.swift
│  │  └─ ScoreboardRouter.swift
│  ├─ TabBar/
│  │  ├─ FloatingBarViewDelegate.swift
│  │  ├─ TabbarContollerDelegate.swift
│  │  └─ TabbarItems.swift
│  ├─ AppUtilities/
│  │  ├─ Extension/
│  │  │  ├─ BinaryInteger + Additions.swift
│  │  │  ├─ Collection + Additions.swift
│  │  │  ├─ Int + Additions.swift
│  │  │  ├─ NsObject + Extension.swift
│  │  │  ├─ String + Additions.swift
│  │  │  ├─ UIButton + Additions.swift
│  │  │  ├─ UIColor + Additions.swift
│  │  │  ├─ UIFont + Additions.swift
│  │  │  ├─ UIImage + Additions.swift
│  │  │  ├─ UILabel + Additions.swift
│  │  │  ├─ UINavigationController + Additions.swift
│  │  │  ├─ UIScrollView + Additions.swift
│  │  │  ├─ UIStackView + Additions.swift
│  │  │  ├─ UITextField + Additions.swift
│  │  │  ├─ UIView + Additions.swift
│  │  │  ├─ UIViewController + Extension.swift
│  │  │  └─ URLRequest + Extension.swift
│  │  └─ Helper/
│  │     ├─ Errors/
│  │     │  └─ WinServerError.swift
│  │     ├─ TestHelpers/
│  │     │  └─ NetworkClientFake.swift
│  │     └─ UIComponents/
│  │        ├─ Animations/
│  │        │  └─ AutoSwipingBadgeView.swift
│  │        ├─ ImageLoader/
│  │        │  ├─ ImageCacheManager.swift
│  │        │  └─ UIImageView + Additions.swift
│  │        ├─ Loader/
│  │        │  ├─ LoaderState.swift
│  │        │  ├─ LoaderView.swift
│  │        │  └─ UIViewController + Loader.swift
│  │        ├─ NavigationBar/
│  │        │  ├─ NavBarButton.swift
│  │        │  ├─ NavigationBarButtonConfig.swift
│  │        │  └─ UIViewcontroller + NavigationBar.swift
│  │        ├─ CheckboxButton.swift
│  │        ├─ Gradient.swift
│  │        ├─ WinButton.swift
│  │        ├─ WinButtonWithImage.swift
│  │        ├─ CopyTextAction.swift
│  │        ├─ DateFormatters.swift
│  │        ├─ GlobalKeyboardDismissHandler.swift
│  │        ├─ KeyboardAvoider.swift
│  │        ├─ KeyboardDismissHandler.swift
│  │        ├─ Log.swift
│  │        ├─ LottieFiles.swift
│  │        ├─ RateAppManager.swift
│  │        └─ ShareSheetAction.swift
│  ├─ AppAssets/
│  │  ├─ Animations/
│  │  │  ├─ battle_lottie
│  │  │  ├─ bookpen
│  │  │  ├─ camera
│  │  │  ├─ confeti
│  │  │  ├─ cry
│  │  │  ├─ facebook
│  │  │  ├─ failed
│  │  │  ├─ firework
│  │  │  ├─ Home
│  │  │  ├─ loader
│  │  │  ├─ moneybag
│  │  │  ├─ no_internet_connection
│  │  │  ├─ ranking_clean_dualcolor
│  │  │  ├─ success
│  │  │  ├─ telegram
│  │  │  └─ timer
│  │  ├─ Font/
│  │  │  ├─ NotoSansBengali-Bold
│  │  │  ├─ NotoSansBengali-Regular
│  │  │  └─ NotoSansBengali-SemiBold
│  │  ├─ Assets
│  │  └─ Colors
│  ├─ LaunchScreen
│  └─ Info
├─ Win-iOSTests/
├─ Win-iOSUITests/
└─ Package Dependencies/
   └─ Lottie 4.5.2}
```
