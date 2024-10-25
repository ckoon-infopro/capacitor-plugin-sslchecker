import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(SSLCheckerPlugin)
public class SSLCheckerPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "SSLCheckerPlugin"
    public let jsName = "SSLChecker"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "verify", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = SSLChecker()

    @objc func verify(_ call: CAPPluginCall) {
        let serverUrl = call.getString("url") ?? ""
        let fingerprints = (call.getArray("fingerprints", String.self) ?? []) as NSArray

        
        call.resolve([
            "value": implementation.verify(serverUrl: serverUrl, allowedFingerprints: fingerprints)
        ])
    }
}
