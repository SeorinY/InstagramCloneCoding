//
//  RegistrationViewController.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/07/28.
//

import UIKit

class RegistrationViewController: UIViewController {
    struct Constants{
        static let cornerRadius : CGFloat = 8.0
    }
    
    private let usernameField : UITextField = {
        let field = UITextField()
        field.placeholder = "Username..."
        field.returnKeyType = .next
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        
        //View 경계값 밖에 있는 요소들은 잘려서 보이게 됨   -> false 로 해주면 경계를 무시하고 밖의 요소도 보임
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let emailField : UITextField = {
        let field = UITextField()
        field.placeholder = "Email Address..."
        field.returnKeyType = .next
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        
        //View 경계값 밖에 있는 요소들은 잘려서 보이게 됨   -> false 로 해주면 경계를 무시하고 밖의 요소도 보임
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let passwordField : UITextField = {
        let field = UITextField()
//        field.isSecureTextEntry =  true
        field.placeholder = "Password..."
        field.returnKeyType = .continue
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let registerButton : UIButton = {
        let button = UIButton()
        
        button.setTitle("Sign Up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        usernameField.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 100, width: view.width - 40, height: 52)
        emailField.frame = CGRect(x: 20, y: usernameField.bottom+10, width: view.width - 40, height: 52)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width - 40, height: 52)
        registerButton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width - 40, height: 52)
    }
    
    //이거 해줌과 동시에 viewDidLoad 에 addTarget 해주기
    @objc private func didTapRegister(){
        //값을 가져옴! -> usernameField.text 같이 할 수 있음
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let username = usernameField.text, !username.isEmpty,
              let email = emailField.text, !email.isEmpty, let password = passwordField.text, !password.isEmpty, password.count >= 8 else{
                  return
        }
        AuthManager.shared.registerNewUser(username: username, email: email, password: password){registered in
            DispatchQueue.main.async {
                if registered{
                    //good to go
                }else{
                    // failed
                }
            }
        }
    }
}



extension RegistrationViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameField == textField{
            emailField.becomeFirstResponder()
        }
        else if emailField == textField{
            passwordField.becomeFirstResponder()
        }
        else{
            didTapRegister()
        }
        
        return true
    }
}
