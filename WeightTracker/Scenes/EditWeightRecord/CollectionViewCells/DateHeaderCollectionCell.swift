
import Foundation
import UIKit

protocol DateHeaderCollectionCellDelegate {
    func showDatePicker()
}

class DateHeaderCollectionCell: UICollectionViewCell {
    var delegate: DateHeaderCollectionCellDelegate?
    
    private lazy var dateHeader: UILabel = {
        let label = UILabel()
        label.text = "Дата"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .appMainText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        
        return label
    }()
    
    private lazy var arrowButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "arrow.right")!.withTintColor(.appMainText, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .appPurple
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
            dateHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateHeader.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            arrowButton.heightAnchor.constraint(equalToConstant: 20),
            arrowButton.widthAnchor.constraint(equalToConstant: 20),
            arrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: arrowButton.leadingAnchor, constant: -8),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            lineView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(date: String) {
        dateLabel.text = date
    }
    
    @objc func showDatePicker() {
        delegate?.showDatePicker()
    }
}

