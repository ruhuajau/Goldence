//
//  LogInViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/5.
//
import AuthenticationServices
import UIKit
import Firebase

class LogInViewController: UIViewController {

    private let signInButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 0, y: 0, width: 250, height: 50)
        signInButton.center = view.center
        signInButton.layer.cornerRadius = 8
    }
    @objc func didTapSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension LogInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed!")
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let firstName = credentials.fullName?.givenName ?? ""
            let lastName = credentials.fullName?.familyName ?? ""
            let email = credentials.email ?? ""
            let userIdentifier = credentials.user
            let authorizationCode = credentials.authorizationCode?.base64EncodedString() ?? ""
            let identityToken = credentials.identityToken?.base64EncodedString() ?? ""

            // Store user data in Firebase
            let userData: [String: Any] = [
                "Name": firstName,
                "userIdentifier": userIdentifier,
                "authorizationCode": authorizationCode,
                "identityToken": identityToken
            ]

            let usersCollection = Firestore.firestore().collection("users")
            usersCollection.document(userIdentifier).setData(userData) { error in
                if let error = error {
                    print("Error storing user data in Firestore: \(error.localizedDescription)")
                    return
                }

                // Transition to the WelcomeViewController
                if let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
                    welcomeVC.modalPresentationStyle = .fullScreen
                    self.present(welcomeVC, animated: true)
                }
            }
        default:
            break
        }
    }
}

extension LogInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}