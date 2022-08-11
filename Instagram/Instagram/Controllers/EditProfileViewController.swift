//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/07/28.
//

import UIKit
struct EditProfileFormModel{
    let label : String
    let placeholder : String
    var value : String?
}

final class EditProfileViewController: UIViewController, UITableViewDataSource{
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        return tableView
    }()
    private var models = [[EditProfileFormModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = createTableHeaderView()
        view.addSubview(tableView)
        tableView.dataSource = self
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    }
    private func configureModels(){
        // name, username, website, bio
        let section1Labels = ["Name", "UserName", "Bio"]
        var section1 = [EditProfileFormModel]()
        for label in section1Labels{
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
            section1.append(model)
        }
        models.append(section1)
        
        //email, phone, gender
        let section2Labels = ["Email", "Phone", "Gender"]
        var section2 = [EditProfileFormModel]()
        for label in section2Labels{
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
            section2.append(model)
        }
        models.append(section2)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - TableView
    private func createTableHeaderView () -> UIView{
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/4).integral)
        let size = header.height / 1.5
        let profilePhotoButton = UIButton(frame: CGRect(x: (view.width - size)/2, y: (header.height - size)/2, width: size, height: size))
        header.addSubview(profilePhotoButton)
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.cornerRadius = size/2.0
        profilePhotoButton.tintColor = .label
        
        profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
        profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        return header
    }
    @objc private func didTapProfilePhotoButton(){
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        
        cell.configure(with: model)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "Private Information"
    }
    
    
    // MARK: - Action
    @objc private func didTapSave(){
        //Save info to database
        
        //창 내려줌
        dismiss(animated: true, completion: nil)
    }
    @objc private func didTapCancel(){
        self.dismiss(animated: true)
    }
    
    @objc private func didTapChangeProfilePicture(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Change profule picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {_ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: {_ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        present(actionSheet, animated: true)
        
    }
}

//cell이 이 View Controller 를 delegate 로 가져가는 이유는 아래 함수의 정의를 받기 위함이다.
//cell 의 delegate 가  다른 viewController 를 참조하고 있었다면 shouldreturn 했을때 실행되는 delegate.함수가 달랐음!
extension EditProfileViewController : FormTableViewCellDelegate{
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
        print(updatedModel.value ?? "nil")
    }
}
