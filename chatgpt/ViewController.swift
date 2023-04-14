//
//  ViewController.swift
//  chatgpt
//
//  Created by Tiago Henrique Piantavinha on 13/04/23.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Senha"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.keyboardType = .numbersAndPunctuation
        textField.delegate = self
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.isEnabled = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var emailTextFieldValid = false {
        didSet {
            updateLoginButtonAppearance()
        }
    }
    
    private var passwordTextFieldValid = false {
        didSet {
            updateLoginButtonAppearance()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        updateLoginButtonAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    @objc private func loginButtonTapped() {
        let alertController = UIAlertController(title: "Login", message: "Email: \(emailTextField.text ?? "")\nSenha: \(passwordTextField.text ?? "")", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateLoginButtonAppearance() {
        if emailTextFieldValid && passwordTextFieldValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .green
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .blue
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            
            if loginButton.isEnabled {
                loginButtonTapped()
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let maxLength = 150
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let isEmailValid = newString.length <= maxLength && isValidEmail(email: newString as String)
            emailTextFieldValid = isEmailValid
        } else if textField == passwordTextField {
            let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            if let newString = newString {
                let isNumeric = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: newString))
                let maxLength = newString.count <= 10
                passwordTextFieldValid = isNumeric && maxLength && !newString.isEmpty
            } else {
                passwordTextFieldValid = false
            }
        }
        loginButton.isEnabled = emailTextFieldValid && passwordTextFieldValid
        return true
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: password)
        return allowedCharacters.isSuperset(of: characterSet) && password.count <= 10
    }
}

