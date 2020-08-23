//
//  PincodeView.swift
//  Jekheha
//
//  Created by Svyatoshenko "Megal" Misha on 22.08.2020.
//  Copyright © 2020 Svyatoshenko "Megal" Misha. All rights reserved.
//

import SwiftUI
import LocalAuthentication

enum AuthState {
	case pending
	case unauthorized
	case authorized
}

struct PincodeView: View {
	@State private var auth: AuthState = .pending

    var body: some View {
		switch auth {
		case .pending:
			return AnyView(
				NavigationView {
					VStack {
						Text("голос")
							.font(.largeTitle)
						Text("проверяется биометрия...")
							.font(.subheadline)
						Spacer()
					}
				}
				.onAppear(perform: authenticate)
			)

		case .unauthorized:
			return AnyView(
				NavigationView {
					VStack {
						Text("голос")
							.font(.largeTitle)
						Text("доступ запрещён")
							.font(.subheadline)
							.foregroundColor(Color.red)
						Spacer()
						Button("Попробовать снова", action: authenticate)
							.padding(.horizontal, 24.0)
							.frame(height: 48.0)
							.accentColor(.white)
							.background(Color.blue)
							.cornerRadius(4.0)
						Spacer()
					}
				}
				.onAppear(perform: authenticate)
			)

		case .authorized:
			return AnyView(SigninView())
		}
    }

	func authenticate() {
		let context = LAContext()
		var error: NSError?

		// check whether biometric authentication is possible
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			// it's possible, so go ahead and use it
			let reason = "Подтверждение при голосовании, c использованием биометрических данных"

			context.evaluatePolicy(
				.deviceOwnerAuthenticationWithBiometrics,
				localizedReason: reason
			) { success, authenticationError in
				// authentication has now completed
				DispatchQueue.main.async {
					if success {
						self.auth = .authorized
					} else {
						self.auth = .unauthorized
					}
				}
			}
		} else {
			// no biometrics
		}
	}


}

struct PincodeView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			PincodeView()
		}
    }
}
