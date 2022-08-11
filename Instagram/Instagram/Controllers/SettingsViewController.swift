//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/07/28.
//

import UIKit
import SafariServices

struct SettingCellModel{
    let title : String
    let handler : (()-> Void)
}

//View Controller to show user settings
final class SettingsViewController: UIViewController {
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configureModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels(){
        data.append([
            SettingCellModel(title: "Edit Profile"){[weak self] in
                self?.didTapEditProfile()
            },
            SettingCellModel(title: "Invite Friends"){[weak self] in
                self?.didTapInviteFiends()
            },
            SettingCellModel(title: "Save Original Posts"){[weak self] in
                self?.didTapSaveOriginalPosts()
            }
        ])
        data.append([
            SettingCellModel(title: "Terms of Service"){[weak self] in
                self?.openURL(type: .terms)
            },
            SettingCellModel(title: "Privacy Policy"){[weak self] in
                self?.openURL(type: .privacy)
            },
            SettingCellModel(title: "Help / Feedback"){[weak self] in
                self?.openURL(type: .help)
            }
        ])
        data.append([
            SettingCellModel(title: "Log Out"){[weak self] in
                self?.didTapLogOut()
            }
        ])
    }
    private func didTapEditProfile(){
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated:  true)
    }
    
    private func didTapInviteFiends(){
        //Show share sheet to invite friends
    }
    private func didTapSaveOriginalPosts(){
        
    }
    enum SettingsURLType{
        case terms, privacy, help
    }
    private func openURL(type : SettingsURLType){
        let urlString : String
        switch type{
        case .terms: urlString = "https://help.instagram.com/581066165581870"
        case .privacy: urlString = "https://help.instagram.com/519522125107875/?helpref=hc_fnav"
        case .help: urlString = "https://help.instagram.com"
        }
        
        guard let url = URL(string: urlString) else{
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func didTapLogOut(){
        //정말 로그아웃 하시겠습니까?
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut(completion: {success in
                DispatchQueue.main.async {
                    if success{
                        //present log in
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true){
                            self.navigationController?.popViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }else{
                        // error occurred
                        fatalError("Could not log out user")
                    }
                }
            })
        }))
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
        /* ==
        let model = data[indexPath.section][indexPath.row]
        model.handler()
         */
    }
}
