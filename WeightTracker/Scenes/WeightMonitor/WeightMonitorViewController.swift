//
//  WeightMonitorViewController.swift
//  WeightTracker
//
//  Created by Алия Давлетова on 17.12.2023.
//

import Foundation
import UIKit

class WeightMonitorViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Монитор веса"
        title.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        title.textColor = .appMainText
        title.textAlignment = .center
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        return title
    }()
    
    private lazy var currentWeight: UIView = {
        let currentWeightView = UIView(frame: CGRect(x: 0, y: 0, width: 340, height: 130))
        currentWeightView.backgroundColor = .appGrayBackground
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appGeneralBackground
        
        view.addSubview(titleLabel)
        view.addSubview(currentWeight)
        
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
        ])
    }
    
}
