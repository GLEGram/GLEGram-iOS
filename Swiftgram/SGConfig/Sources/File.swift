import Foundation
import BuildConfig

public struct SGConfig: Codable {
    /// Beta build flag. Set to `true` for beta (internal) builds, `false` for App Store (release) builds.
    public static let isBetaBuild: Bool = true

    public var apiUrl: String = "https://api.swiftgram.app"
    public var webappUrl: String = "https://my.swiftgram.app"
    public var botUsername: String = "SwiftgramBot"
    public var publicKey: String?
    public var iaps: [String] = []
    /// Base URL of supporters API (e.g. https://your-server.com). If set, app can check supporter status via encrypted API.
    public var supportersApiUrl: String? = "https://glegram.site/"
    /// AES-256 key for supporters API encryption (same as SUPPORTERS_AES_KEY on server). Optional; if nil, supporter check is disabled.
    public var supportersAesKey: String? = "V1wmSaHPBtfwGR7jHozwSkRVQrUVtvUMkb+u5EnmGuY="
    /// HMAC-SHA256 key for signing (same as SUPPORTERS_HMAC_KEY on server). Optional; if nil, derived from supportersAesKey.
    public var supportersHmacKey: String? = "QpU3hDanhmp67LDTzL2tjzDuG4qIsCIFn3LMYAyyRyI="
    /// SSL pinning: base64 SHA256 hashes of server certificate(s). Empty = no pinning. Let's Encrypt: update when cert renews (~90 days).
    public var supportersPinnedCertHashes: [String] = ["brDmHiqwkhgPrFDmkcD2IsDUdKLZlyGjGkn0SOGNKFI="]

    /// Demo login backend URL for App Store review (e.g. "https://your-server.com"). Empty = disabled.
    public var demoLoginBackendUrl: String? = "https://glegram.site"
    /// Phone number prefix that triggers demo login flow (e.g. "+10000")
    public var demoLoginPhonePrefix: String? = "+10000"
}

private func parseSGConfig(_ jsonString: String) -> SGConfig {
    let jsonData = Data(jsonString.utf8)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return (try? decoder.decode(SGConfig.self, from: jsonData)) ?? SGConfig()
}

private let baseAppBundleId = Bundle.main.bundleIdentifier!
private let buildConfig = BuildConfig(baseAppBundleId: baseAppBundleId)
public let SG_CONFIG: SGConfig = parseSGConfig(buildConfig.sgConfig)
public let SG_API_WEBAPP_URL_PARSED = URL(string: SG_CONFIG.webappUrl)!