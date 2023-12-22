import Foundation
import UIKit

class WeightMonitorViewController: UIViewController {
    private let rowHeight: CGFloat = 46
    private let cellIdentifier = "cell"
    
    private var viewModel: WeightMonitorViewModel
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Монитор веса"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.getAppColors(.appMainText)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        return label
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.currentWeight.formatWeight()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = UIColor.getAppColors(.appMainText)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var diffLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.currentDiff.formatWeightDiff()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.getAppColors(.appBlack60)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var currentWeight: UIView = {
        let currentWeightView = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 130))
        currentWeightView.backgroundColor = UIColor.getAppColors(.appLightGray)
        currentWeightView.layer.cornerRadius = 12
        currentWeightView.translatesAutoresizingMaskIntoConstraints = false
        currentWeightView.clipsToBounds = true
        
        let title = UILabel()
        title.text = "Текущий вес"
        title.font = .systemFont(ofSize: 13, weight: .medium)
        title.textColor = UIColor.getAppColors(.appBlack40)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let switcher = UISwitch(frame: CGRect(x: 0, y: 0, width: 51, height: 31))
        switcher.onTintColor = UIColor.getAppColors(.appPurple)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        
        let metricSystem = UILabel()
        metricSystem.text = "Метрическая система"
        metricSystem.font = .systemFont(ofSize: 17, weight: .medium)
        metricSystem.textColor = UIColor.getAppColors(.appMainText)
        metricSystem.translatesAutoresizingMaskIntoConstraints = false
        
        let scaleImage = UIImageView(image: UIImage(named: "scales"))
        scaleImage.translatesAutoresizingMaskIntoConstraints = false
        
        currentWeightView.addSubview(title)
        currentWeightView.addSubview(weightLabel)
        currentWeightView.addSubview(diffLabel)
        currentWeightView.addSubview(switcher)
        currentWeightView.addSubview(metricSystem)
        currentWeightView.addSubview(scaleImage)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: currentWeightView.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: currentWeightView.leadingAnchor, constant: 16),
            
            weightLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            weightLabel.leadingAnchor.constraint(equalTo: currentWeightView.leadingAnchor, constant: 16),
            
            diffLabel.bottomAnchor.constraint(equalTo: weightLabel.bottomAnchor),
            diffLabel.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: 8),
            
            switcher.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 16),
            switcher.leadingAnchor.constraint(equalTo: currentWeightView.leadingAnchor, constant: 16),
            
            metricSystem.centerYAnchor.constraint(equalTo: switcher.centerYAnchor),
            metricSystem.leadingAnchor.constraint(equalTo: switcher.trailingAnchor, constant: 16),
            
            scaleImage.topAnchor.constraint(equalTo: currentWeightView.topAnchor),
            scaleImage.trailingAnchor.constraint(equalTo: currentWeightView.trailingAnchor),
            scaleImage.heightAnchor.constraint(equalToConstant: 67),
            scaleImage.widthAnchor.constraint(equalToConstant: 104),
        ])
        
        view.addSubview(currentWeightView)
        
        return currentWeightView
    }()
    
    private lazy var historyLabel: UILabel = {
        let label = UILabel()
        label.text = "История"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.getAppColors(.appMainText)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        return label
    }()
    
    private lazy var lineView: UIView = {
        let uiView = UIView(frame: .zero)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.getAppColors(.appGray20)
        view.addSubview(uiView)
        
        return uiView
    }()
    
    private lazy var columnHeaderView: UIView = {
        let columnHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 27))
        columnHeaderView.translatesAutoresizingMaskIntoConstraints = false
        columnHeaderView.clipsToBounds = true
        
        let weightLabel = UILabel()
        weightLabel.text = "Вес"
        weightLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        weightLabel.textColor = UIColor.getAppColors(.appBlack40)
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let diffLabel = UILabel()
        diffLabel.text = "Изменения"
        diffLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        diffLabel.textColor = UIColor.getAppColors(.appBlack40)
        diffLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        dateLabel.text = "Дата"
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        dateLabel.textColor = UIColor.getAppColors(.appBlack40)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        columnHeaderView.addSubview(weightLabel)
        columnHeaderView.addSubview(diffLabel)
        columnHeaderView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            weightLabel.leadingAnchor.constraint(equalTo: columnHeaderView.leadingAnchor, constant: 16),
            weightLabel.centerYAnchor.constraint(equalTo: columnHeaderView.centerYAnchor),
            
            diffLabel.centerYAnchor.constraint(equalTo: columnHeaderView.centerYAnchor),
            diffLabel.leadingAnchor.constraint(equalTo: columnHeaderView.leadingAnchor, constant: 2 * (columnHeaderView.bounds.width - WeightMonitortViewControllerCell.chevronSideLenght) / 5),
            
            dateLabel.centerYAnchor.constraint(equalTo: columnHeaderView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: columnHeaderView.leadingAnchor, constant: 4 * (columnHeaderView.bounds.width - WeightMonitortViewControllerCell.chevronSideLenght) / 5),
        ])
        
        view.addSubview(columnHeaderView)
        
        return columnHeaderView
    }()
    
    private lazy var weightsTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.rowHeight = rowHeight
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsSelection = false
        table.register(WeightMonitortViewControllerCell.self, forCellReuseIdentifier: cellIdentifier)
        // table.dataSource = self
        table.delegate = self
        view.addSubview(table)
        
        return table
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, WeightRecord> = {
        return UITableViewDiffableDataSource<Int, WeightRecord>(tableView: self.weightsTable) { (tableView, indexPath, weightModel) in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! WeightMonitortViewControllerCell
            print("UITableViewDiffableDataSource:", weightModel.hashValue)
            if indexPath.row < self.viewModel.records.count-1 {
                let prev = self.viewModel.records[indexPath.row + 1]
                let diff = weightModel.weightValue - prev.weightValue
                cell.configure(weight: weightModel, diff: diff)
            } else {
                cell.configure(weight: weightModel)
            }
            
            return cell
        }
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.tintColor = UIColor.getAppColors(.appPurple).withAlphaComponent(0.3)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapCreateRecordButton), for: .touchUpInside)
        view.addSubview(button)
        
        return button
    }()
    
    private lazy var alertPresenter = AlertPresenter(delegate: self)
    
    init(_ viewModel: WeightMonitorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.getAppColors(.appGeneralBackground)
        
        setupConstraint()
        
        viewModel.loadData()
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.records)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentWeight.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            currentWeight.heightAnchor.constraint(equalToConstant: 129),
            currentWeight.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            currentWeight.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            historyLabel.topAnchor.constraint(equalTo: currentWeight.bottomAnchor, constant: 16),
            historyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            columnHeaderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            columnHeaderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            columnHeaderView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 16),
            columnHeaderView.heightAnchor.constraint(equalToConstant: 18),
            
            lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            lineView.topAnchor.constraint(equalTo: columnHeaderView.bottomAnchor, constant: 8),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            weightsTable.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 8),
            weightsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weightsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            weightsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 80),
            addButton.widthAnchor.constraint(equalToConstant: 80),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func tapCreateRecordButton() {
        let editWeightRecordVM = EditWeightRecordViewModel(store: WeightsStore(), tableUpdater: viewModel)
        let editWeightRecordVC = EditWeightRecordViewController(viewModel: editWeightRecordVM)
        editWeightRecordVM.delegate = editWeightRecordVC
        editWeightRecordVC.modalPresentationStyle = .popover
        self.present(editWeightRecordVC, animated: true)
    }

}

extension WeightMonitorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row >= viewModel.records.count {
            assertionFailure("should never happen")
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self else {
                assertionFailure("self is empty")
                return
            }

            self.viewModel.deleteRecord(at: indexPath.row)
            completion(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completion in
            guard let self else {
                assertionFailure("self is empty")
                return
            }
            
            let editWeightRecordVM = EditWeightRecordViewModel(store: WeightsStore(), tableUpdater: self.viewModel)
            let editWeightRecordVC = EditWeightRecordViewController(viewModel: editWeightRecordVM)
            editWeightRecordVM.delegate = editWeightRecordVC
            editWeightRecordVM.updateWeight = self.viewModel.records[indexPath.row]
            editWeightRecordVM.date = self.viewModel.records[indexPath.row].date
            editWeightRecordVM.updateWeightIndex = indexPath.row
            editWeightRecordVC.modalPresentationStyle = .popover
            self.present(editWeightRecordVC, animated: true)
            completion(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}

extension WeightMonitorViewController: WeightMonitorViewModelDelegate {  
    func reloadData() {
        weightLabel.text = viewModel.currentWeight.formatWeight()
        diffLabel.text = viewModel.currentDiff.formatWeightDiff()
        
        weightsTable.reloadData()
    }
    
    func showAlert(alert: AlertModel) {
        alertPresenter.show(result: alert)
    }
    
    func deleteRow(indexPath: IndexPath, deleteRecord: WeightRecord) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([deleteRecord])
        if indexPath.row > 0 {
            snapshot.reconfigureItems([viewModel.records[indexPath.row - 1]])
        }
        
        self.dataSource.apply(snapshot, animatingDifferences: false)
        
        if indexPath.row < 2 {
            weightLabel.text = viewModel.currentWeight.formatWeight()
            diffLabel.text = viewModel.currentDiff.formatWeightDiff()
        }
    }
    
    func addRow(index: Int) {
        let newRecord = viewModel.records[index]
        var snapshot = dataSource.snapshot()
        
        if index == viewModel.records.count - 1 {
            snapshot.appendItems([newRecord])
        } else {
            snapshot.insertItems([newRecord], beforeItem: viewModel.records[index + 1])
        }
        
        if index > 0 {
            snapshot.reconfigureItems([viewModel.records[index - 1]])
        }

        dataSource.apply(snapshot, animatingDifferences: false)
        
        if index < 2 {
            weightLabel.text = viewModel.currentWeight.formatWeight()
            diffLabel.text = viewModel.currentDiff.formatWeightDiff()
        }
    }
    
    func reconfigureRow(record: WeightRecord, index: Int) {
        var reconfigureRecords = [record]
        if index > 0 {
            reconfigureRecords.append(viewModel.records[index - 1])
        }
        
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([record])
        dataSource.apply(snapshot, animatingDifferences: true, completion: {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        })
        
        if index < 2 {
            weightLabel.text = viewModel.currentWeight.formatWeight()
            diffLabel.text = viewModel.currentDiff.formatWeightDiff()
        }
    }
}
