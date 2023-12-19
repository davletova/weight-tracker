import Foundation
import UIKit

class EditWeightRecordViewController: UIViewController {
    private var date = Date()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить вес"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .appMainText
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .appMainText
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        return label
    }()
    
    private lazy var dateButton: UIButton = {
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 17, weight: .regular)
        container.foregroundColor = .black
        
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(formatDate(date: date), attributes: container)
        configuration.image = UIImage(named: "arrow.right")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8
        configuration.baseForegroundColor = .appPurple
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(baz), for: .touchUpInside)
        view.addSubview(button)
        
        return button
    }()
    
    private lazy var weightInput: UITextField = {
        let input = UITextField(frame: CGRect(x: 0, y: 0, width: 288, height: 75))
        input.leftView = UIView(frame: CGRectMake(0, 0, 16, input.frame.height))
        input.leftViewMode = .always
        input.translatesAutoresizingMaskIntoConstraints = false
        input.font = .systemFont(ofSize: 34, weight: .bold)
        input.textColor = .appMainText
        input.borderStyle = .line
        input.layer.borderColor = UIColor.appLightGray.cgColor
        input.layer.borderWidth = 1
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.appBlack40,
        ]
        let attributedString = NSAttributedString(string: "Введите вес", attributes: attributes)
        input.attributedPlaceholder = attributedString
        
        view.addSubview(input)
        
        return input
    }()
    
    private lazy var unit: UILabel = {
        let label = UILabel()
        label.text = "кг"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .appBlack40
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        var datePickerCalendar = Calendar(identifier: .gregorian)
        datePickerCalendar.firstWeekday = 2
        datePicker.calendar = datePickerCalendar
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.isHidden = true
        datePicker.addAction(
            UIAction { action in
                guard let datepicker = action.sender as? UIDatePicker else {
                    print("cant convert ")
                    return
                }
                self.date = datepicker.date
            },
            for: .valueChanged
        )
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        
        return datePicker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appGeneralBackground
        
        setupConstraint()
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            datePicker.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            weightInput.heightAnchor.constraint(equalToConstant: 72),
            weightInput.topAnchor.constraint(equalTo: datePicker.isHidden ? view.centerYAnchor : datePicker.bottomAnchor),
            weightInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weightInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            unit.centerYAnchor.constraint(equalTo: weightInput.centerYAnchor),
            unit.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            dateLabel.bottomAnchor.constraint(equalTo: datePicker.isHidden ? weightInput.topAnchor : datePicker.topAnchor, constant: -16),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            dateButton.heightAnchor.constraint(equalToConstant: 20),
            dateButton.bottomAnchor.constraint(equalTo: datePicker.isHidden ? weightInput.topAnchor : datePicker.topAnchor, constant: -16),
            dateButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func formatDate(date: Date) -> String {
        if date >= Calendar.current.startOfDay(for: Date()) {
            return "Сегодня"
        }
        return date.formatFullDate()
    }
    
    @objc func baz() {
        print("baaaaaaz")
        datePicker.isHidden = false
        self.view.layoutIfNeeded()
//        var datePicker = UIDatePicker()
//        var datePickerCalendar = Calendar(identifier: .gregorian)
//        datePickerCalendar.firstWeekday = 2
//        datePicker.calendar = datePickerCalendar
//        datePicker.addAction(
//            UIAction { action in
//                guard let datepicker = action.sender as? UIDatePicker else {
//                    print("cant convert ")
//                    return
//                }
//                self.date = datepicker.date
//            },
//            for: .valueChanged
//        )
        
    }
}
