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
   
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Монитор веса"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .appMainText
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        return currentWeightView
    }()
    
    private lazy var historyLabel: UILabel = {
        let label = UILabel()
        label.text = "История"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .appMainText
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var line: UIImageView = {
        let image = UIImageView(image: UIImage(named: "line"))
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var columnHeaderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 27))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
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
        
        view.addSubview(weightLabel)
        view.addSubview(diffLabel)
        view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            weightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            diffLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            diffLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2 * (view.bounds.width - WeightMonitortViewControllerCell.chevronSideLenght) / 5),
            
            dateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4 * (view.bounds.width - WeightMonitortViewControllerCell.chevronSideLenght) / 5),
        ])
        
        return view
    }()
    
    private lazy var weightsTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.rowHeight = rowHeight
        
        table.register(WeightMonitortViewControllerCell.self, forCellReuseIdentifier: cellIdentifier)
        table.dataSource = self
//        table.delegate = self

        return table
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.tintColor = .appPurple
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapCreateRecordButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appGeneralBackground
        
        view.addSubview(titleLabel)
        view.addSubview(currentWeight)
        view.addSubview(historyLabel)
        view.addSubview(columnHeaderView)
        view.addSubview(line)
        view.addSubview(weightsTable)
        view.addSubview(addButton)
        
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
            
            line.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            line.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            line.topAnchor.constraint(equalTo: columnHeaderView.bottomAnchor, constant: 8),
            
            weightsTable.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 8),
            weightsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            weightsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            weightsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 72),
            addButton.widthAnchor.constraint(equalToConstant: 72),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}

extension WeightMonitorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WeightMonitortViewControllerCell
          
        if indexPath.row >= weights.count {
            print("should never happen")
        }
        
        var lastWeight: Double?
        if indexPath.row < weights.count - 1 {
            lastWeight = weights[indexPath.row + 1].value
        }
        
        cell.configure(weight: weights[indexPath.row], lastWeight: lastWeight)
        
        return cell
    }
    
    @objc func tapCreateRecordButton() {
        let editWeightRecordVC = EditWeightRecordViewController()
        editWeightRecordVC.modalPresentationStyle = .popover
        self.present(editWeightRecordVC, animated: true)
    }
}

var weights = [
    WeightRecord(value: 56.3, date: Date()),
    WeightRecord(value: 56.9, date: Date()),
    WeightRecord(value: 54.9, date: Date()),
    WeightRecord(value: 56.1, date: Date()),
]
