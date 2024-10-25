import Foundation
import CommonCrypto

@objc public class SSLChecker: NSObject {
    @objc public func verify(serverUrl: String, allowedFingerprints: NSArray) -> Bool {
        
        print("serverUrl: \(serverUrl)")
        
        guard let url = URL(string: serverUrl) else {
            return false // Invalid URL
        }
        
        // Configure URL session with custom delegate
        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.urlCache = nil
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        
        let fingerprintStringArray: [String] = allowedFingerprints.compactMap { $0 as? String }
        
        
        let delegate = SSLCertificateDelegate(allowedFingerprints: fingerprintStringArray,
                                              checkInCertChain: false)
        let session = URLSession(configuration: sessionConfig,
                                 delegate: delegate,
                                 delegateQueue: nil)
        
        // Use a semaphore to wait for the task to complete
        let semaphore = DispatchSemaphore(value: 0)
        var isSecure = false
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                if let err = error as? URLError, err.code == .cancelled {
                    // Connection was cancelled by our delegate after cert verification
                    if delegate.isSecure {
                        print("CONNECTION_SECURE")
                        isSecure = true
                    } else {
                        print("CONNECTION_NOT_SECURE")
                    }
                } else {
                    print("CONNECTION_FAILED: \(error.localizedDescription)")
                }
            } else {
                if delegate.isSecure {
                    print("CONNECTION_SECURE")
                    isSecure = true
                } else {
                    print("CONNECTION_NOT_SECURE")
                }
            }
            
            // Signal the semaphore to indicate the task has completed
            semaphore.signal()
        }
        
        
        // Start the task
        task.resume()
        
        // Wait for the semaphore to be signaled
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        // Return the isSecure flag
        return isSecure
    }
}

class SSLCertificateDelegate: NSObject, URLSessionDelegate {
    private let allowedFingerprints: [String]
    private let checkInCertChain: Bool
    private(set) var isSecure = false
    
    init(allowedFingerprints: [String], checkInCertChain: Bool) {
        self.allowedFingerprints = allowedFingerprints
        self.checkInCertChain = checkInCertChain
        super.init()
    }
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let certCount = checkInCertChain ? SecTrustGetCertificateCount(serverTrust) : 1
        
        // Iterate over the certificates in the chain and check their fingerprints
        for i in 0..<certCount {
            guard let cert = SecTrustGetCertificateAtIndex(serverTrust, i) else { continue }
            
            let fingerprint = getFingerprint(cert: cert)
            if isFingerprintTrusted(fingerprint) {
                isSecure = true
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
        }
        
        isSecure = false
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
    
    private func getFingerprint(cert: SecCertificate) -> String {
        let certData = SecCertificateCopyData(cert) as Data
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = certData.withUnsafeBytes { buffer in
            CC_SHA256(buffer.baseAddress, CC_LONG(certData.count), &digest)
        }
        
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    private func isFingerprintTrusted(_ fingerprint: String) -> Bool {
        let normalizedAllowedFingerprints = allowedFingerprints.map { $0.replacingOccurrences(of: " ", with: "").lowercased() }
        let containsFingerprint = normalizedAllowedFingerprints.contains { $0.caseInsensitiveCompare(fingerprint) == .orderedSame }
        return containsFingerprint
    }
}
