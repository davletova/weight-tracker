
import Foundation
import UIKit

protocol WeightInputCollectionCellDelegate {
    var weight: String { get set }
    func hideDatePicker()
}

class WeightInputCollectionCell: UICollectionViewCell {
    var delegate: WeightInputCollectionCellDelegate?
    
    private lazy var weightInput: UITextField = {
        let input = UITextField(frame: CGRect(x: 0, y: 0, width: 288, height: 75))
        input.leftView = UIView(frame: CGRectMake(0, 0, 16, input.frame.height))
        input.leftViewMode = .always
        input.translatesAutoresizingMaskIntoConstraints = false
        input.font = .systemFont(ofSize: 34, weight: .bold)
        input.textColor = .appMainText
//        input.borderStyle = .line
//        input.layer.borderColor = UIColor.appLightGray.cgColor
//        input.layer.borderWidth = 1
        input.keyboardType = .decimalPad
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.appBlack40,
        ]
        let attributedString = NSAttributedString(string: "Введите вес", attributes: attributes)
        input.attributedPlaceholder = attributedString
        input.delegate = self
        contentView.addSubview(input)
        
        return input
    }()
    
    private lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .appBlack40
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        return label
    }()
    
    private lazy var lineView: UIView = {
        let uiView = UIView(frame: .zero)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = .appLightGray
        contentView.addSubview(uiView)
        
        return uiView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NSLayoutConstraint.activate([
            weightInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weightInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weightInput.topAnchor.constraint(equalTo: contentView.topAnchor),
            weightInput.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            unitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            unitLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            lineView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(weight: Double? = nil, unit: String) {
        if let weight = weight {
            weightInput.text = String(format: "%.1f", locale: .current, weight)
        }
        unitLabel.text = unit
    }
}

extension WeightInputCollectionCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 4
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.hideDatePicker()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: проверить введенное число /^[0-9]{1,3}([,.][0-9])*$/
        let currentText = textField.text ?? ""
        
        print("eeeeend")
        delegate?.weight = currentText
    }
}
