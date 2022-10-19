//
//  FormTableViewCell.swift
//  Instagram
//
//  Created by Mac Book Pro on 2022/08/04.
//

import UIKit

protocol FormTableViewCellDelegate : AnyObject{
    func formTableViewCell(_ cell : FormTableViewCell, didUpdateField updatedModel : EditProfileFormModel)
}


//Cell 어떻게 생겼는지 정의해주고, Model을 받아서 설정해줌
class FormTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "FormTableViewCell"
    
    private var model : EditProfileFormModel?
    public weak var delegate : FormTableViewCellDelegate?
    
    
    private let formLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let field : UITextField =  {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()
    //Cell이 어떻게 생겼는지 초기화해 줌
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(field)
        
        field.delegate = self
        selectionStyle = .none      //선택되지 않는 Cell 임
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Assign frames
        formLabel.frame = CGRect(x: 5, y: 0, width: contentView.width/3, height: contentView.height)
        field.frame = CGRect(x: formLabel.right + 5, y: 0, width: contentView.width - 10 - formLabel.width, height: contentView.height)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(with model : EditProfileFormModel){
        self.model = model
        formLabel.text = model.label
        field.placeholder = model.placeholder
        field.text = model.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        formLabel.text = nil
        field.placeholder = nil
        field.text = nil
    }
    
    //MARK: - Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //model(struct)을 정의해주는데 value 만 있는 model 을 만들어줌 왜냐하면 print 할 때 어차피 value 값만 사용함
        model?.value = textField.text
        guard let model = model else{
            return true
        }
        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder()
        return true
    }
}
