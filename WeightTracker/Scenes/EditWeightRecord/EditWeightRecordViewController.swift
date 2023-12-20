import Foundation
import UIKit

private let headerCellIdentifier = "headerCell"
private let datePickerCellIdentifier = "datePickerCell"
private let weightCellIdentifier = "weightCell"

enum CollectionSectionType: Int {
    case header = 0
    case datePicker = 1
    case weight = 2
}

class EditWeightRecordViewController: UIViewController {
    var viewModel: EditWeightRecordViewModel
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить вес"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .appMainText
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateHeaderCollectionCell.self, forCellWithReuseIdentifier: headerCellIdentifier)
        collectionView.register(DatePickerCollectionCell.self, forCellWithReuseIdentifier: datePickerCellIdentifier)
        collectionView.register(WeightInputCollectionCell.self, forCellWithReuseIdentifier: weightCellIdentifier)
        
        view.addSubview(collectionView)
        
        return collectionView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.textColor = .appMainText
        button.backgroundColor = .appPurple
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(addRecord), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        return button
    }()
    
    private lazy var validationError: UILabel = {
        let label = UILabel()
        label.text = "Неверный формат данных"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .red
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        return label
    }()
    
    init(viewModel: EditWeightRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appPopoverBackground
        
        setupConstraint()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
           
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: view.bounds.height / 5),
            collectionView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16),
            
            validationError.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -8),
            validationError.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
//            collectionView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
//            collectionView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
//            collectionView.heightAnchor.constraint(lessThanOrEqualToConstant: 350),
        ])
    }
    
    func formatDate(date: Date) -> String {
        if date >= Calendar.current.startOfDay(for: Date()) {
            return "Сегодня"
        }
        return date.formatFullDate()
    }
    
    @objc func addRecord() {
        print("dasdsa")
        viewModel.addRecord()
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

extension EditWeightRecordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.isDatePickerOpen ? 3 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard var sectionType = CollectionSectionType(rawValue: indexPath.row) else {
            assertionFailure("invalid section")
            return UICollectionViewCell()
        }
        
        if !viewModel.isDatePickerOpen && indexPath.row == 1 {
            sectionType = .weight
        }
        
        switch sectionType {
        case .header:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! DateHeaderCollectionCell
            cell.configure(date: formatDate(date: viewModel.date))
            cell.delegate = viewModel
            return cell
        case .datePicker:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: datePickerCellIdentifier, for: indexPath) as! DatePickerCollectionCell
            cell.delegate = viewModel
            return cell
        case .weight:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weightCellIdentifier, for: indexPath) as! WeightInputCollectionCell
            cell.configure(unit: "кг")
            cell.delegate = viewModel
            return cell
        }
    }
}

extension EditWeightRecordViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard var sectionType = CollectionSectionType(rawValue: indexPath.row) else {
            assertionFailure("invalid section")
            return .zero
        }
        
        if !viewModel.isDatePickerOpen && indexPath.row == 1 {
            sectionType = .weight
        }
        
        switch sectionType {
        case .header:
            return CGSize(width: view.bounds.width, height: 54)
        case .datePicker:
            return CGSize(width: view.bounds.width, height: 216)
        case .weight:
            return CGSize(width: view.bounds.width, height: 72)
        }
    }
}

extension EditWeightRecordViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == CollectionSectionType.header.rawValue {
            viewModel.hideDatePicker()
        }
    }
}

extension EditWeightRecordViewController: EditWeightRecordViewViewModelDelegate {
    func showValidationError() {
        validationError.isHidden = false
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func reloadRow(indexPathes: [IndexPath]) {
        collectionView.reloadItems(at: indexPathes)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

