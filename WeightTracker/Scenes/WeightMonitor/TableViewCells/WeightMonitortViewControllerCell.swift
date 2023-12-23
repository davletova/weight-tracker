import Foundation
import UIKit

class WeightMonitortViewControllerCell: UITableViewCell {
    static let chevronSideLenght: CGFloat = 20
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.getAppColors(.appMainText)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var diffLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.getAppColors(.appBlack60)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.getAppColors(.appBlack40)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var chevron: UIImageView = {
        let image = UIImageView(image: UIImage(named: "arrow.right")!.withRenderingMode(.alwaysTemplate))
        image.tintColor = UIColor.getAppColors(.appMainText)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    func configure(weight: WeightRecord, screenWidth: CGFloat, diff: Decimal? = nil) {
        weightLabel.text = weight.weightValue.formatWeight()
        dateLabel.text = formatDate(date: weight.date)
        diffLabel.text = diff?.formatWeightDiff() ?? ""
        
        contentView.addSubview(weightLabel)
        contentView.addSubview(diffLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            weightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // Для столбцов вес:изменения:дата поделили экран в соотношении 40% : 40% : 20%
            diffLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3 * (screenWidth - WeightMonitortViewControllerCell.chevronSideLenght) / 8),
            diffLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3 * (screenWidth - WeightMonitortViewControllerCell.chevronSideLenght)  / 4),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevron.heightAnchor.constraint(equalToConstant: WeightMonitortViewControllerCell.chevronSideLenght),
            chevron.widthAnchor.constraint(equalToConstant: WeightMonitortViewControllerCell.chevronSideLenght),
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func formatDate(date: Date) -> String {
        if date < Date().startOfYear() {
            return date.formatShortFullDate()
        }
        return date.formatDayMonth()
    }
}
