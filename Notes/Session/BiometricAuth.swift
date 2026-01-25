//
//  BiometricAuth.swift
//  Notes
//
//  Created by Erman Maris on 1/25/26.
//

import LocalAuthentication

final class BiometricAuth {
    enum AuthError: Error {
        case unavailable
        case failed
    }

    func authenticate(reason: String) async throws -> Bool {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // e.g. no Face ID enrolled, no passcode set, biometry locked out, etc.
            throw (error ?? AuthError.unavailable as NSError)
        }

        // Optional: you can check which type is available
        // context.biometryType == .faceID / .touchID
        // .deviceOwnerAuthentication instead of biometrics-only. This allows Face ID/Touch ID or device passcode.
        return try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: reason) { success, evalError in
                if let evalError {
                    continuation.resume(throwing: evalError)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
}
