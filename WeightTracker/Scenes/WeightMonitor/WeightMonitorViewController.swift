//
//  WeightMonitorViewController.swift
//  WeightTracker
//
//  Created by Алия Давлетова on 17.12.2023.
//

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
        label.textColor = .appMainText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        return label
    }()
    
    private lazy var currentWeight: UIView = {
        let currentWeightView = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 130))
        currentWeightView.backgroundColor = .appLightGray
        currentWeightView.layer.cornerRadius = 12
        currentWeightView.translatesAutoresizingMaskIntoConstraints = false
        currentWeightView.clipsToBounds = true
        
        let title = UILabel()
        title.text = "Текущий вес"
        title.font = .systemFont(ofSize: 13, weight: .medium)
        title.textColor = .appBlack40
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let weight = UILabel()
        weight.text = "58.5 кг"
        weight.font = .systemFont(ofSize: 22, weight: .medium)
        weight.textColor = .appMainText
        weight.translatesAutoresizingMaskIntoConstraints = false
        
        let diff = UILabel()
        diff.text = "-0,5 кг"
        diff.font = .systemFont(ofSize: 17, weight: .medium)
        diff.textColor = .appBlack60
        diff.translatesAutoresizingMaskIntoConstraints = false
        
        let switcher = UISwitch(frame: CGRect(x: 0, y: 0, width: 51, height: 31))
        switcher.onTintColor = .appPurple
        switcher.translatesAutoresizingMaskIntoConstraints = false
        
        let metricSystem = UILabel()
        metricSystem.text = "Метрическая система"
        metricSystem.font = .systemFont(ofSize: 17, weight: .medium)
        metricSystem.textColor = .appMainText
        metricSystem.translatesAutoresizingMaskIntoConstraints = false
        
        let scaleImage = UIImageView(image: UIImage(named: "scales"))
        scaleImage.translatesAutoresizingMaskIntoConstraints = false
        
        currentWeightView.addSubview(title)
        currentWeightView.addSubview(weight)
        currentWeightView.addSubview(diff)
        currentWeightView.addSubview(switcher)
        currentWeightView.addSubview(metricSystem)
        currentWeightView.addSubview(scaleImage)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: currentWeightView.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: currentWeightView.leadingAnchor, constant: 16),
            
            weight.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            weight.leadingAnchor.constraint(equalTo: currentWeightView.leadingAnchor, constant: 16),
            
            diff.bottomAnchor.constraint(equalTo: weight.bottomAnchor),
            diff.leadingAnchor.constraint(equalTo: weight.trailingAnchor, constant: 8),
            
            switcher.topAnchor.constraint(equalTo: weight.bottomAnchor, constant: 16),
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
        label.textColor = .appMainText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        return label
    }()
    
    private lazy var lineView: UIView = {
        let uiView = UIView(frame: .zero)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = .appGray20
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
        weightLabel.textColor = .appBlack40
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let diffLabel = UILabel()
        diffLabel.text = "Изменения"
        diffLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        diffLabel.textColor = .appBlack40
        diffLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        dateLabel.text = "Дата"
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        dateLabel.textColor = .appBlack40
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        columnHeaderView.addSubview(weightLabel)
        columnHeaderView.addSubview(diffLabel)
        columnHeaderView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            weightLabel.leadingAnchor.constraint(equalTo: columnHeaderView.leadingAnchor),
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
        table.dataSource = self
        view.addSubview(table)
        
        return table
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.tintColor = .appPurple.withAlphaComponent(0.3)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapCreateRecordButton), for: .touchUpInside)
        view.addSubview(button)
        
        return button
    }()
    
    init(_ viewModel: WeightMonitorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            
            currentWeight.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            currentWeight.heightAnchor.constraint(equalToConstant: 129),
            currentWeight.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            currentWeight.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            historyLabel.topAnchor.constraint(equalTo: currentWeight.bottomAnchor, constant: 16),
            historyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            columnHeaderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            columnHeaderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
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
}

extension WeightMonitorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WeightMonitortViewControllerCell
          
        if indexPath.row >= viewModel.records.count {
            print("should never happen")
        }
    
        cell.configure(weight: viewModel.records[indexPath.row])
        
        return cell
    }
    
    @objc func tapCreateRecordButton() {
        let editWeightRecordVM = EditWeightRecordViewModel(store: WeightsStore(), tableReloader: self)
        let editWeightRecordVC = EditWeightRecordViewController(viewModel: editWeightRecordVM)
        editWeightRecordVM.delegate = editWeightRecordVC
        editWeightRecordVC.modalPresentationStyle = .popover
        self.present(editWeightRecordVC, animated: true)
    }
}

extension WeightMonitorViewController: WeightMonitorViewModelDelegate {
    func reloadData() {
        weightsTable.reloadData()
    }
}

extension WeightMonitorViewController: WeightsTableReloader {
    func updateWeightTable() {
        viewModel.listRecords()
        weightsTable.reloadData()
    }
}
