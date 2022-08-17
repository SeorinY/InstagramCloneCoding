//
//  IGFeedPostHeaderTableViewCell.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/08/04.
//
import SDWebImage
import UIKit

protocol IGFeedPostHeaderTableViewCellDelegate : AnyObject{
    func didTapMoreButton()
}

class IGFeedPostHeaderTableViewCell: UITableViewCell {
    static let identifier = "IGFeedPostHeaderTableViewCell"
    weak var delegate : IGFeedPostHeaderTableViewCellDelegate?
    
    private let profilePhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel : UILabel = {
        //layout 안의 항목들을 설정해줌
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let moreButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profilePhotoImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton(){
        delegate?.didTapMoreButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model : User){
        //layout 들의 안 내용물들을 설정해줌 -> 그렇기 떄문에 HomeViewController 에서 사용함
        //configure the cell
        usernameLabel.text = model.username
        profilePhotoImageView.image = UIImage(systemName: "person.circle")
//        profilePhotoImageView.sd_setImage(with: model.profilePhoto, completed: nil)     //데이터 베이스가 작동한다면 이 코드로 바꿔주기
        
    }
    
    override func layoutSubviews() {
        //layout의 frame 을 설정
        super.layoutSubviews()
        let size = contentView.height-4
        //아래처럼하면 동그란 이미지를 만들 수 있음
        profilePhotoImageView.frame = CGRect(x: 2, y: 2, width: size, height: size)
        profilePhotoImageView.layer.cornerRadius = size/2
        moreButton.frame = CGRect(x: contentView.width-size-2, y: 2, width: size, height: size)
        usernameLabel.frame = CGRect( x: profilePhotoImageView.right + 10,
                                      y: 2,
                                      width: contentView.width-(size*2)-15,
                                      height: contentView.height-4 )
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        profilePhotoImageView.image = nil
    }
}
