//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/07/28.
//

import UIKit
/// Profile view controller
final class ProfileViewController: UIViewController {
    private var collectionView : UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configurationNavigationBar()
        
        //이 부분 잘 모르겠음
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.width/3, height: view.width/3)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView?.backgroundColor = .red
        
        //Cell
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        //Header
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        collectionView?.register(ProfileTabsCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: ProfileTabsCollectionReusableView.identifier)
        
        
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        
        view.addSubview(collectionView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // frame = CGRect ||  view.bounds
//        collectionView?.frame = CGRect(x: 0, y: view.height/3, width: view.width, height: view.height*2/3)
        collectionView?.frame = view.bounds
    }

    private func configurationNavigationBar(){
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingButton))
    }
    @objc private func didTapSettingButton(){
         let vc = SettingsViewController()
         vc.title = "Settings"
         navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.backgroundColor = .systemBlue
        return cell
    }
    
    //cell 이 눌렸을때 실행
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
