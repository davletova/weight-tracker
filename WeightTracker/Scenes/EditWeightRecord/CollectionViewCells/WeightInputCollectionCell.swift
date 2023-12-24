import Foundation
import UIKit

protocol WeightInputCollectionCellDelegate {
    var weightInput: String { get set }
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
        input.textColor = UIColor.getAppColors(.appMainText)
        input.keyboardType = .decimalPad
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.getAppColors(.appBlack40),
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
        label.textColor = UIColor.getAppColors(.appBlack40)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        return label
    }()
    
    private lazy var lineView: UIView = {
        let uiView = UIView(frame: .zero)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.getAppColors(.appLightGray)
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
    
    func configure(weight: Decimal? = nil, unit: UnitMass) {
        if let weight {
            weightInput.text = weight.formatWeightWithoutUnit()
        }
        let formatter = MeasurementFormatter()
        formatter.locale = Locale.current
        unitLabel.text = formatter.string(from: unit)
        weightInput.becomeFirstResponder()
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
        let currentText = textField.text ?? ""
        
        delegate?.weightInput = currentText
    }
}
