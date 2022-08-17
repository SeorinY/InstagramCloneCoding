//
//  PostViewController.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/07/28.
//

import UIKit

/*
 Section
 - HEADER model
 Section
 - Post Cell model
 Section
 - Action Buttons Cell model
 Section
 - n Number of general models for comments
 */

/// State of a renderd call
enum PostRenderType{
    case header(provider : User)
    case primaryContent(provider : UserPost)
    case actions(provider : String) // like, comment, share
    case comments(comments : [PostComment])
}

/// Model of renderd Post
struct PostRenderViewModel{
    let renderType : PostRenderType
}

class PostViewController: UIViewController {
    private let model: UserPost?
    
    private var renderModels = [PostRenderViewModel]()
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        //Register cells
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Init
    init(model : UserPost?){
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    
    private func configureModels(){
        guard let userPostModel = self.model else{
            return
        }
        // Header
        renderModels.append(PostRenderViewModel.init(renderType: .header(provider: userPostModel.owner)))
        // Post
        renderModels.append(PostRenderViewModel.init(renderType: .primaryContent(provider: userPostModel)))
        // Actions
        renderModels.append(PostRenderViewModel.init(renderType: .actions(provider: "")))
        //4 Commends
        var comments = [PostComment]()
        for x in 0..<4{
            comments.append(PostComment(identifier: "123_\(x)",
                                        username: "@hi",
                                        text: "Greate post!",
                                        createDate: Date(),
                                        likes: []))
        }
        renderModels.append(PostRenderViewModel.init(renderType: .comments(comments: comments)))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
}

extension PostViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType{
        case .actions(_): return 1
        case .comments(let comments): return comments.count > 4 ? 4 : comments.count
        case .primaryContent(_):return 1
        case .header(_):return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]
        switch model.renderType{
        case .actions(let actions):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionTableViewCell.identifier, for: indexPath) as! IGFeedPostActionTableViewCell
            return cell
        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
            return cell
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
            return cell
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        switch model.renderType{
        case .actions(_):
            return 60
        case .comments(_):
            return 50
        case .primaryContent(_):
            return tableView.width
        case .header(_):
            return 70
        }
    }
}
