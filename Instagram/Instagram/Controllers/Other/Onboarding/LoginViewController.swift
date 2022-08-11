//
//  LoginViewController.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/07/28.
//
import SafariServices
import UIKit

class LoginViewController: UIViewController {
    struct Constants{
        static let cornerRadius : CGFloat = 8.0
    }
    
    private let usernameEmailField : UITextField = {
        let field = UITextField()
        field.placeholder = "Username or Email..."
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
        field.isSecureTextEntry =  true
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
    
    private let loginButton : UIButton = {
        let button = UIButton()
        
        button.setTitle("Log In", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let termsButton : UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let privacyButton : UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let createAccountButton : UIButton = {
        let button = UIButton()
        button.setTitle("New User? Create an Account", for: .normal)
        //Dark, light 모드에 따라 달라짐
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    private let headerView : UIView = {
        let header = UIView()
        header.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named: "gradient"))
        header.addSubview(backgroundImageView)
        
        return header
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        
    
        
        //delegate 를 해줬으므로 Textfield 안의 리소스를 가져올 수 있음
        usernameEmailField.delegate = self
        passwordField.delegate = self
        
        addSubView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //assign frames
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height/3)
        usernameEmailField.frame = CGRect(x: 25, y: headerView.bottom + 40, width: view.width - 50, height: 52)
        passwordField.frame = CGRect(x: 25, y: usernameEmailField.bottom + 10, width: view.width - 50, height: 52)
        loginButton.frame = CGRect(x: 25, y: passwordField.bottom + 10, width: view.width - 50, height: 52)
        createAccountButton.frame = CGRect(x: 25, y: loginButton.bottom + 10, width: view.width - 50, height: 52)
        termsButton.frame = CGRect(x: 10, y: view.height - view.safeAreaInsets.bottom - 100, width: view.width - 20 , height: 50)
        privacyButton.frame = CGRect(x: 10, y: view.height - view.safeAreaInsets.bottom - 50, width: view.width - 20 , height: 50)
        configureHeaderView()
    }
    
    private func configureHeaderView(){
        guard headerView.subviews.count == 1 else{
            return
        }
        
        guard var backgroundView = headerView.subviews.first else{
            return
        }
        backgroundView.frame = headerView.bounds
        
        //Add instagram logo
        let imageView = UIImageView(image: UIImage(named: "logo_text"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: headerView.width/4, y: view.safeAreaInsets.top, width: headerView.width/2, height: headerView.height - view.safeAreaInsets.top)
        
        headerView.addSubview(imageView)
        
    }
    
    private func addSubView(){
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        view.addSubview(createAccountButton)
        view.addSubview(headerView)
    }
    
    @objc private func didTapLoginButton(){
        //값을 가져옴! -> usernameField.text 같이 할 수 있음
        passwordField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
        
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8 else{
            return
        }
        
        var username : String?
        var email : String?
        
        // login functionality
        if usernameEmail.contains("@"), usernameEmail.contains("."){
            //email로 로그인하는 것임
            email = usernameEmail
        }
        else{
            //username로 로그인하는 것임
            username = usernameEmail
        }
        
        AuthManager.shared.loginUser(username: username, email: email, password: password){ success in
            DispatchQueue.main.async {
                if success{
                    //user log in
                    self.dismiss(animated: true, completion:  nil)
                    //self -> LoginViewController 임!
                }else{
                    //error occured
                    let alert = UIAlertController(title: "Log In Error", message: "We were unable to log you in.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    @objc private func didTapCreateAccountButton(){
        let vc = RegistrationViewController()
        vc.title = "Create Acccount"
        
        //present 란 모달을 보여주는 것
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    @objc private func didTapTermsButton(){
        guard let url = URL(string: "https://www.instagram.com/about/legal/terms/before-january-19-2013/?hl=en") else{
            return
        }
        let vc = SFSafariViewController(url: url)
        //present 란 모달을 보여주는 것
        present(vc, animated: true)
    }
    @objc private func didTapPrivacyButton(){
        guard let url = URL(string: "https://help.instagram.com/519522125107875/?helpref=hc_fnav") else{
            return
        }
        let vc = SFSafariViewController(url: url)
        //present 란 모달을 보여주는 것
        present(vc, animated: true)
    }
}

extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField{
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField{
            
        }
        return true
    }
}
