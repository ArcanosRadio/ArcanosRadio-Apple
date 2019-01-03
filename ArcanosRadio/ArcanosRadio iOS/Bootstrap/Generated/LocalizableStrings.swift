// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Arcanos Web Radio
  internal static let aboutArcanos = L10n.tr("Localizable", "ABOUT_ARCANOS")
  /// http://www.arcanosmc.com.br
  internal static let aboutArcanosDetails = L10n.tr("Localizable", "ABOUT_ARCANOS_DETAILS")
  /// http://www.arcanosmc.com.br
  internal static let aboutArcanosUrl = L10n.tr("Localizable", "ABOUT_ARCANOS_URL")
  /// © Copyright Arcanos MC\n2016 - All rights reserved
  internal static let aboutCopyright = L10n.tr("Localizable", "ABOUT_COPYRIGHT")
  /// UX conception and other mobile platforms
  internal static let aboutFilipeDetailsA = L10n.tr("Localizable", "ABOUT_FILIPE_DETAILS_A")
  /// https://github.com/fibelatti
  internal static let aboutFilipeDetailsB = L10n.tr("Localizable", "ABOUT_FILIPE_DETAILS_B")
  /// Filipe Belatti
  internal static let aboutFilipeName = L10n.tr("Localizable", "ABOUT_FILIPE_NAME")
  /// https://github.com/fibelatti
  internal static let aboutFilipeUrl = L10n.tr("Localizable", "ABOUT_FILIPE_URL")
  /// Member of the Arcanos Motoclube from São Paulo
  internal static let aboutJairDetailsA = L10n.tr("Localizable", "ABOUT_JAIR_DETAILS_A")
  /// Creator, producer and DJ at Arcanos Web Radio
  internal static let aboutJairDetailsB = L10n.tr("Localizable", "ABOUT_JAIR_DETAILS_B")
  /// Jair Gonçalves Barbosa
  internal static let aboutJairName = L10n.tr("Localizable", "ABOUT_JAIR_NAME")
  /// http://www.arcanosmc.com.br
  internal static let aboutJairUrl = L10n.tr("Localizable", "ABOUT_JAIR_URL")
  /// Links
  internal static let aboutLinksHeader = L10n.tr("Localizable", "ABOUT_LINKS_HEADER")
  /// iOS development, server API and website
  internal static let aboutLuizDetailsA = L10n.tr("Localizable", "ABOUT_LUIZ_DETAILS_A")
  /// https://github.com/luizmb
  internal static let aboutLuizDetailsB = L10n.tr("Localizable", "ABOUT_LUIZ_DETAILS_B")
  /// Luiz Rodrigo Martins Barbosa
  internal static let aboutLuizName = L10n.tr("Localizable", "ABOUT_LUIZ_NAME")
  /// https://github.com/luizmb
  internal static let aboutLuizUrl = L10n.tr("Localizable", "ABOUT_LUIZ_URL")
  /// Design
  internal static let aboutMariDetailsA = L10n.tr("Localizable", "ABOUT_MARI_DETAILS_A")
  /// http://marimartins.art.br
  internal static let aboutMariDetailsB = L10n.tr("Localizable", "ABOUT_MARI_DETAILS_B")
  /// Mariana Martins Barbosa
  internal static let aboutMariName = L10n.tr("Localizable", "ABOUT_MARI_NAME")
  /// http://marimartins.art.br
  internal static let aboutMariUrl = L10n.tr("Localizable", "ABOUT_MARI_URL")
  /// iOS app source code
  internal static let aboutSourceCodeIos = L10n.tr("Localizable", "ABOUT_SOURCE_CODE_IOS")
  /// https://github.com/luizmb/ArcanosRadio-iOS
  internal static let aboutSourceCodeIosDetails = L10n.tr("Localizable", "ABOUT_SOURCE_CODE_IOS_DETAILS")
  /// https://github.com/luizmb/ArcanosRadio-iOS
  internal static let aboutSourceCodeIosUrl = L10n.tr("Localizable", "ABOUT_SOURCE_CODE_IOS_URL")
  /// Server API source code
  internal static let aboutSourceCodeServerApi = L10n.tr("Localizable", "ABOUT_SOURCE_CODE_SERVER_API")
  /// https://github.com/luizmb/ArcanosRadio-Backend
  internal static let aboutSourceCodeServerDetails = L10n.tr("Localizable", "ABOUT_SOURCE_CODE_SERVER_DETAILS")
  /// https://github.com/luizmb/ArcanosRadio-Backend
  internal static let aboutSourceCodeServerUrl = L10n.tr("Localizable", "ABOUT_SOURCE_CODE_SERVER_URL")
  /// Team
  internal static let aboutTeamHeader = L10n.tr("Localizable", "ABOUT_TEAM_HEADER")
  /// Third-party licenses
  internal static let aboutThirdPartyHeader = L10n.tr("Localizable", "ABOUT_THIRD_PARTY_HEADER")
  /// About the app
  internal static let aboutTitleText = L10n.tr("Localizable", "ABOUT_TITLE_TEXT")
  /// Ok, enable reports again
  internal static let crashreportRequestAlwaysSend = L10n.tr("Localizable", "CRASHREPORT_REQUEST_ALWAYS_SEND")
  /// The app just crashed and you selected not sending crash reports. Crash reports don't carry any personal information and you don't have to be worried about sending them.
  internal static let crashreportRequestMessage = L10n.tr("Localizable", "CRASHREPORT_REQUEST_MESSAGE")
  /// No, don't send them
  internal static let crashreportRequestNeverSend = L10n.tr("Localizable", "CRASHREPORT_REQUEST_NEVER_SEND")
  /// Crash reports disabled
  internal static let crashreportRequestTitle = L10n.tr("Localizable", "CRASHREPORT_REQUEST_TITLE")
  /// The lyrics are not available for this song
  internal static let lyricsUnavailable = L10n.tr("Localizable", "LYRICS_UNAVAILABLE")
  /// About the app
  internal static let menuAbout = L10n.tr("Localizable", "MENU_ABOUT")
  /// Select an option
  internal static let menuSelectItemText = L10n.tr("Localizable", "MENU_SELECT_ITEM_TEXT")
  /// Settings
  internal static let menuSettings = L10n.tr("Localizable", "MENU_SETTINGS")
  /// Share
  internal static let menuShare = L10n.tr("Localizable", "MENU_SHARE")
  /// Connecting
  internal static let nowPlayingHourglass = L10n.tr("Localizable", "NOW_PLAYING_HOURGLASS")
  /// Pause
  internal static let nowPlayingPause = L10n.tr("Localizable", "NOW_PLAYING_PAUSE")
  /// Play
  internal static let nowPlayingPlay = L10n.tr("Localizable", "NOW_PLAYING_PLAY")
  /// I'm listening to %@ by %@ on Arcanos Web Rock! Get right now the app - %@ #ArcanosWebRock
  internal static func shareText(_ p1: String, _ p2: String, _ p3: String) -> String {
    return L10n.tr("Localizable", "SHARE_TEXT", p1, p2, p3)
  }
  /// Lyrics
  internal static let toolbarLyrics = L10n.tr("Localizable", "TOOLBAR_LYRICS")
  /// Twitter
  internal static let toolbarTwitter = L10n.tr("Localizable", "TOOLBAR_TWITTER")
  /// Website
  internal static let toolbarWebsite = L10n.tr("Localizable", "TOOLBAR_WEBSITE")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
