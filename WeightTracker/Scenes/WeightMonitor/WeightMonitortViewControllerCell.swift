//
//  WeightMonitortViewControllerCell.swift
//  WeightTracker
//
//  Created by Алия Давлетова on 18.12.2023.
//

import Foundation
import UIKit

class WeightMonitortViewControllerCell: UITableViewCell {
    static let chevronSideLenght: CGFloat = 20
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .appMainText
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var diffLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .appBlack60
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .appBlack40
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var chevron: UIImageView = {
        let image = UIImageView(image: UIImage(named: "arrow.right"))
//        image.tintColor = .appMainText
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    func configure(weight: Weight, lastWeight: Double?) {
        weightLabel.text = String(format: "%.1f", locale: .current, weight.value) + " кг"
        dateLabel.text = weight.date.formatDayMonth()
        
        if let lastWeight = lastWeight {
            diffLabel.text = String(format: "%.1f", locale: .current, weight.value - lastWeight) + " кг"
        }
        
        contentView.addSubview(weightLabel)
        contentView.addSubview(diffLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(chevron)

        NSLayoutConstraint.activate([
            weightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            // Для столбцов вес:изменения:дата поделили экран в соотношении 40% : 40% : 20%
            diffLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  2 * contentView.bounds.width / 5),
            diffLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4 * contentView.bounds.width / 5),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevron.heightAnchor.constraint(equalToConstant: WeightMonitortViewControllerCell.chevronSideLenght),
            chevron.widthAnchor.constraint(equalToConstant: WeightMonitortViewControllerCell.chevronSideLenght),
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
