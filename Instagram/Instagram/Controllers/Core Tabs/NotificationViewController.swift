//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/07/28.
//

import UIKit

enum UserNotificationType{
    case like(post : UserPost)
    case follow(state: FollowState)
}

struct UserNotification{
    let type : UserNotificationType
    let text : String
    let user : User
}

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationFollowEventTableViewCell.self
                           , forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifier)
        tableView.register(NotificationLikeEventTableViewCell.self
                           , forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        return tableView
    }()
    
    //UIActivityIndicatorView => 로딩을 뜻하는 돌아가는 spinner UI 임
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private lazy var noNotificationsView = NoNotificationsView()
    
    private var models = [UserNotification]()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notification"
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
//        spinner.startAnimating()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
//        layoutNoNotificationsView()
    }
    
    private func fetchNotifications(){
        for x in 0...100{
            let post = UserPost(identifier: "",
                                postType: .photo,
                                thumbnailImage: URL(string: "https://www.google.com")!,
                                postURL: URL(string: "https://www.google.com")!,
                                caption: nil,
                                likeCount: [],
                                comments: [],
                                createDate: Date(),
                                taggedUsers: [])
            let model = UserNotification(type: x%2 == 0 ? .like(post:post) : .follow(state: .not_following),
                                         text: "Hello World",
                                         user: User(username: "seotin", bio: "", name:("" , ""),
                                                    profilePhoto: URL(string: "https://www.google.com")!,
                                                    birthDate: Date(), gender: .male,
                                                    counts: UserCount(followers: 1, following: 1, posts: 1),
                                                    joinDate: Date()))
            models.append(model)
        }
    }
    
    private func layoutNoNotificationsView(){
        tableView.isHidden = true
        view.addSubview(noNotificationsView)
        /*
        let size = view.width/2
        noNotificationsView.frame =  CGRect(x: (view.width-size)/2, y: (view.height-size)/2, width: size, height: size/2)
        */
        //위 주석을 계산하지 말고 아래처럼 x,y 좌표를 계산할 수 있음.
        view.addSubview(tableView)
        noNotificationsView.frame =  CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificationsView.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type{
        case .like(_):
            //like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier,
                                                     for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        case .follow:
            //follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier,
                                                     for: indexPath) as! NotificationFollowEventTableViewCell
//            cell.configure(with: model)
            cell.delegate = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
extension NotificationViewController : NotificationLikeEventTableViewCellDelegate{
    func didTapRelatedPostButton(model: UserNotification) {
        print("Tapped Post")
        //Open the post
    }
}
extension NotificationViewController : NotificationFollowEventTableViewCellDelegate{
    func didTapFollowUnfollowButton(model: UserNotification) {
        print("Tapped button")
        //perform the new post
    }
}
