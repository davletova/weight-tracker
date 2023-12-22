import Foundation
import UIKit

protocol DatePickerCollectionCellDelegate {
    func setDate(date: Date)
}

class DatePickerCollectionCell: UICollectionViewCell {
    var delegate: DatePickerCollectionCellDelegate?
    
    private lazy var datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())
        datePicker.maximumDate = endOfDay
        datePicker.datePickerMode = .date
        datePicker.addAction(
            UIAction { action in
                guard let datepicker = action.sender as? UIDatePicker else {
                    print("cant convert ")
                    return
                }
                self.delegate?.setDate(date: self.datePicker.date)
            },
            for: .valueChanged
        )
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(datePicker)
        
        return datePicker
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
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            lineView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(date: Date) {
        datePicker.date = date
    }
}
