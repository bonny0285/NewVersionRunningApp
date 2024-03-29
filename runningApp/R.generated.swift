//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.segue` struct is generated, and contains static references to 4 view controllers.
  struct segue {
    /// This struct is generated for `CreateUserVC`, and contains static references to 1 segues.
    struct createUserVC {
      /// Segue identifier `ShowMain`.
      static let showMain: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, CreateUserVC, MainViewController> = Rswift.StoryboardSegueIdentifier(identifier: "ShowMain")

      #if os(iOS) || os(tvOS)
      /// Optionally returns a typed version of segue `ShowMain`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showMain(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, CreateUserVC, MainViewController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.createUserVC.showMain, segue: segue)
      }
      #endif

      fileprivate init() {}
    }

    /// This struct is generated for `LoginViewController`, and contains static references to 2 segues.
    struct loginViewController {
      /// Segue identifier `ShowCreateUser`.
      static let showCreateUser: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, LoginViewController, CreateUserVC> = Rswift.StoryboardSegueIdentifier(identifier: "ShowCreateUser")
      /// Segue identifier `ShowMain`.
      static let showMain: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, LoginViewController, MainViewController> = Rswift.StoryboardSegueIdentifier(identifier: "ShowMain")

      #if os(iOS) || os(tvOS)
      /// Optionally returns a typed version of segue `ShowCreateUser`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showCreateUser(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, LoginViewController, CreateUserVC>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.loginViewController.showCreateUser, segue: segue)
      }
      #endif

      #if os(iOS) || os(tvOS)
      /// Optionally returns a typed version of segue `ShowMain`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showMain(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, LoginViewController, MainViewController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.loginViewController.showMain, segue: segue)
      }
      #endif

      fileprivate init() {}
    }

    /// This struct is generated for `MainViewController`, and contains static references to 1 segues.
    struct mainViewController {
      /// Segue identifier `ShowRecords`.
      static let showRecords: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, MainViewController, RegistroVC> = Rswift.StoryboardSegueIdentifier(identifier: "ShowRecords")

      #if os(iOS) || os(tvOS)
      /// Optionally returns a typed version of segue `ShowRecords`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showRecords(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, MainViewController, RegistroVC>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.mainViewController.showRecords, segue: segue)
      }
      #endif

      fileprivate init() {}
    }

    /// This struct is generated for `RegistroVC`, and contains static references to 1 segues.
    struct registroVC {
      /// Segue identifier `ShowComment`.
      static let showComment: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, RegistroVC, CommentsVC> = Rswift.StoryboardSegueIdentifier(identifier: "ShowComment")

      #if os(iOS) || os(tvOS)
      /// Optionally returns a typed version of segue `ShowComment`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showComment(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, RegistroVC, CommentsVC>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.registroVC.showComment, segue: segue)
      }
      #endif

      fileprivate init() {}
    }

    fileprivate init() {}
  }
  #endif

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.file` struct is generated, and contains static references to 1 files.
  struct file {
    /// Resource file `GoogleService-Info.plist`.
    static let googleServiceInfoPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "GoogleService-Info", pathExtension: "plist")

    /// `bundle.url(forResource: "GoogleService-Info", withExtension: "plist")`
    static func googleServiceInfoPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.googleServiceInfoPlist
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 14 images.
  struct image {
    /// Image `Icon-1024 copia`.
    static let icon1024Copia = Rswift.ImageResource(bundle: R.hostingBundle, name: "Icon-1024 copia")
    /// Image `centerNavButton`.
    static let centerNavButton = Rswift.ImageResource(bundle: R.hostingBundle, name: "centerNavButton")
    /// Image `closeButton`.
    static let closeButton = Rswift.ImageResource(bundle: R.hostingBundle, name: "closeButton")
    /// Image `commentIcon`.
    static let commentIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "commentIcon")
    /// Image `filterIcon`.
    static let filterIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "filterIcon")
    /// Image `pauseButton`.
    static let pauseButton = Rswift.ImageResource(bundle: R.hostingBundle, name: "pauseButton")
    /// Image `resumeButton`.
    static let resumeButton = Rswift.ImageResource(bundle: R.hostingBundle, name: "resumeButton")
    /// Image `runner`.
    static let runner = Rswift.ImageResource(bundle: R.hostingBundle, name: "runner")
    /// Image `starIconFilled`.
    static let starIconFilled = Rswift.ImageResource(bundle: R.hostingBundle, name: "starIconFilled")
    /// Image `startRunningButton`.
    static let startRunningButton = Rswift.ImageResource(bundle: R.hostingBundle, name: "startRunningButton")
    /// Image `tabbar-myLogIconGray`.
    static let tabbarMyLogIconGray = Rswift.ImageResource(bundle: R.hostingBundle, name: "tabbar-myLogIconGray")
    /// Image `tabbar-myLogIcon`.
    static let tabbarMyLogIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "tabbar-myLogIcon")
    /// Image `tabbar-runIconGray`.
    static let tabbarRunIconGray = Rswift.ImageResource(bundle: R.hostingBundle, name: "tabbar-runIconGray")
    /// Image `tabbar-runIcon`.
    static let tabbarRunIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "tabbar-runIcon")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "Icon-1024 copia", bundle: ..., traitCollection: ...)`
    static func icon1024Copia(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon1024Copia, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "centerNavButton", bundle: ..., traitCollection: ...)`
    static func centerNavButton(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.centerNavButton, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "closeButton", bundle: ..., traitCollection: ...)`
    static func closeButton(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.closeButton, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "commentIcon", bundle: ..., traitCollection: ...)`
    static func commentIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.commentIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "filterIcon", bundle: ..., traitCollection: ...)`
    static func filterIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.filterIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "pauseButton", bundle: ..., traitCollection: ...)`
    static func pauseButton(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.pauseButton, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "resumeButton", bundle: ..., traitCollection: ...)`
    static func resumeButton(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.resumeButton, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "runner", bundle: ..., traitCollection: ...)`
    static func runner(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.runner, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "starIconFilled", bundle: ..., traitCollection: ...)`
    static func starIconFilled(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.starIconFilled, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "startRunningButton", bundle: ..., traitCollection: ...)`
    static func startRunningButton(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.startRunningButton, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tabbar-myLogIcon", bundle: ..., traitCollection: ...)`
    static func tabbarMyLogIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tabbarMyLogIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tabbar-myLogIconGray", bundle: ..., traitCollection: ...)`
    static func tabbarMyLogIconGray(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tabbarMyLogIconGray, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tabbar-runIcon", bundle: ..., traitCollection: ...)`
    static func tabbarRunIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tabbarRunIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tabbar-runIconGray", bundle: ..., traitCollection: ...)`
    static func tabbarRunIconGray(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tabbarRunIconGray, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.nib` struct is generated, and contains static references to 2 nibs.
  struct nib {
    /// Nib `MainConsole`.
    static let mainConsole = _R.nib._MainConsole()
    /// Nib `RunningSavedCell`.
    static let runningSavedCell = _R.nib._RunningSavedCell()

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "MainConsole", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.mainConsole) instead")
    static func mainConsole(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.mainConsole)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "RunningSavedCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.runningSavedCell) instead")
    static func runningSavedCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.runningSavedCell)
    }
    #endif

    static func mainConsole(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.mainConsole.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }

    static func runningSavedCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> RunningSavedCell? {
      return R.nib.runningSavedCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? RunningSavedCell
    }

    fileprivate init() {}
  }

  /// This `R.reuseIdentifier` struct is generated, and contains static references to 2 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `RunningSavedCell`.
    static let runningSavedCell: Rswift.ReuseIdentifier<RunningSavedCell> = Rswift.ReuseIdentifier(identifier: "RunningSavedCell")
    /// Reuse identifier `commentsCell`.
    static let commentsCell: Rswift.ReuseIdentifier<CommentsCell> = Rswift.ReuseIdentifier(identifier: "commentsCell")

    fileprivate init() {}
  }

  /// This `R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    /// This `R.string.localizable` struct is generated, and contains static references to 13 localization keys.
    struct localizable {
      /// en translation: Are you want terminate your session?
      ///
      /// Locales: en, it
      static let alert_terminate_session_title = Rswift.StringResource(key: "alert_terminate_session_title", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Cancel
      ///
      /// Locales: en, it
      static let cancel_button = Rswift.StringResource(key: "cancel_button", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Create
      ///
      /// Locales: en, it
      static let create_button = Rswift.StringResource(key: "create_button", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Create an account
      ///
      /// Locales: en, it
      static let create_account = Rswift.StringResource(key: "create_account", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Don't have an account?
      ///
      /// Locales: en, it
      static let dont_you_have_an_account = Rswift.StringResource(key: "dont_you_have_an_account", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Don't have an account?
      ///
      /// Locales: en, it
      static let login_view_controller_hint = Rswift.StringResource(key: "login_view_controller_hint", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: End Run
      ///
      /// Locales: en, it
      static let end_running = Rswift.StringResource(key: "end_running", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Login
      ///
      /// Locales: en, it
      static let login = Rswift.StringResource(key: "login", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Logout
      ///
      /// Locales: en, it
      static let logout = Rswift.StringResource(key: "logout", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: New Run
      ///
      /// Locales: en, it
      static let new_run = Rswift.StringResource(key: "new_run", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: OK
      ///
      /// Locales: en, it
      static let ok_button = Rswift.StringResource(key: "ok_button", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Press 'Cancel' for stay or 'OK' for leave.
      ///
      /// Locales: en, it
      static let alert_terminate_session_message = Rswift.StringResource(key: "alert_terminate_session_message", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Start running
      ///
      /// Locales: en, it
      static let start_running = Rswift.StringResource(key: "start_running", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)

      /// en translation: Are you want terminate your session?
      ///
      /// Locales: en, it
      static func alert_terminate_session_title(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("alert_terminate_session_title", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "alert_terminate_session_title"
        }

        return NSLocalizedString("alert_terminate_session_title", bundle: bundle, comment: "")
      }

      /// en translation: Cancel
      ///
      /// Locales: en, it
      static func cancel_button(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("cancel_button", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "cancel_button"
        }

        return NSLocalizedString("cancel_button", bundle: bundle, comment: "")
      }

      /// en translation: Create
      ///
      /// Locales: en, it
      static func create_button(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("create_button", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "create_button"
        }

        return NSLocalizedString("create_button", bundle: bundle, comment: "")
      }

      /// en translation: Create an account
      ///
      /// Locales: en, it
      static func create_account(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("create_account", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "create_account"
        }

        return NSLocalizedString("create_account", bundle: bundle, comment: "")
      }

      /// en translation: Don't have an account?
      ///
      /// Locales: en, it
      static func dont_you_have_an_account(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("dont_you_have_an_account", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "dont_you_have_an_account"
        }

        return NSLocalizedString("dont_you_have_an_account", bundle: bundle, comment: "")
      }

      /// en translation: Don't have an account?
      ///
      /// Locales: en, it
      static func login_view_controller_hint(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("login_view_controller_hint", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "login_view_controller_hint"
        }

        return NSLocalizedString("login_view_controller_hint", bundle: bundle, comment: "")
      }

      /// en translation: End Run
      ///
      /// Locales: en, it
      static func end_running(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("end_running", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "end_running"
        }

        return NSLocalizedString("end_running", bundle: bundle, comment: "")
      }

      /// en translation: Login
      ///
      /// Locales: en, it
      static func login(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("login", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "login"
        }

        return NSLocalizedString("login", bundle: bundle, comment: "")
      }

      /// en translation: Logout
      ///
      /// Locales: en, it
      static func logout(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("logout", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "logout"
        }

        return NSLocalizedString("logout", bundle: bundle, comment: "")
      }

      /// en translation: New Run
      ///
      /// Locales: en, it
      static func new_run(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("new_run", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "new_run"
        }

        return NSLocalizedString("new_run", bundle: bundle, comment: "")
      }

      /// en translation: OK
      ///
      /// Locales: en, it
      static func ok_button(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("ok_button", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "ok_button"
        }

        return NSLocalizedString("ok_button", bundle: bundle, comment: "")
      }

      /// en translation: Press 'Cancel' for stay or 'OK' for leave.
      ///
      /// Locales: en, it
      static func alert_terminate_session_message(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("alert_terminate_session_message", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "alert_terminate_session_message"
        }

        return NSLocalizedString("alert_terminate_session_message", bundle: bundle, comment: "")
      }

      /// en translation: Start running
      ///
      /// Locales: en, it
      static func start_running(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("start_running", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "start_running"
        }

        return NSLocalizedString("start_running", bundle: bundle, comment: "")
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try nib.validate()
    #endif
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _MainConsole.validate()
      try _RunningSavedCell.validate()
    }

    struct _MainConsole: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "MainConsole"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }

      static func validate() throws {
        if UIKit.UIImage(named: "pauseButton", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'pauseButton' is used in nib 'MainConsole', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }

    struct _RunningSavedCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType, Rswift.Validatable {
      typealias ReusableType = RunningSavedCell

      let bundle = R.hostingBundle
      let identifier = "RunningSavedCell"
      let name = "RunningSavedCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> RunningSavedCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? RunningSavedCell
      }

      static func validate() throws {
        if UIKit.UIImage(named: "commentIcon", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'commentIcon' is used in nib 'RunningSavedCell', but couldn't be loaded.") }
        if UIKit.UIImage(named: "starIconFilled", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'starIconFilled' is used in nib 'RunningSavedCell', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }
  #endif

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try main.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if UIKit.UIImage(named: "Icon-1024 copia", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'Icon-1024 copia' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = MainNavigationController

      let bundle = R.hostingBundle
      let commentsVC = StoryboardViewControllerResource<CommentsVC>(identifier: "CommentsVC")
      let createUserVC = StoryboardViewControllerResource<CreateUserVC>(identifier: "CreateUserVC")
      let loginViewController = StoryboardViewControllerResource<LoginViewController>(identifier: "LoginViewController")
      let mainViewController = StoryboardViewControllerResource<MainViewController>(identifier: "MainViewController")
      let name = "Main"
      let registroVC = StoryboardViewControllerResource<RegistroVC>(identifier: "RegistroVC")

      func commentsVC(_: Void = ()) -> CommentsVC? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: commentsVC)
      }

      func createUserVC(_: Void = ()) -> CreateUserVC? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: createUserVC)
      }

      func loginViewController(_: Void = ()) -> LoginViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: loginViewController)
      }

      func mainViewController(_: Void = ()) -> MainViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: mainViewController)
      }

      func registroVC(_: Void = ()) -> RegistroVC? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: registroVC)
      }

      static func validate() throws {
        if UIKit.UIImage(named: "tabbar-myLogIconGray", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'tabbar-myLogIconGray' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "tabbar-runIconGray", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'tabbar-runIconGray' is used in storyboard 'Main', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
        if _R.storyboard.main().commentsVC() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'commentsVC' could not be loaded from storyboard 'Main' as 'CommentsVC'.") }
        if _R.storyboard.main().createUserVC() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'createUserVC' could not be loaded from storyboard 'Main' as 'CreateUserVC'.") }
        if _R.storyboard.main().loginViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'loginViewController' could not be loaded from storyboard 'Main' as 'LoginViewController'.") }
        if _R.storyboard.main().mainViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'mainViewController' could not be loaded from storyboard 'Main' as 'MainViewController'.") }
        if _R.storyboard.main().registroVC() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'registroVC' could not be loaded from storyboard 'Main' as 'RegistroVC'.") }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
