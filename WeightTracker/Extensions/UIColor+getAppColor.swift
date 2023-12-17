//
//  UIColor+getAppColor.swift
//  WeightTracker
//
//  Created by Алия Давлетова on 17.12.2023.
//

import Foundation
import UIKit

enum AppColor {
    case appBackground, appBlack40, appBlack60, appMainText, appPurple
    
    func getColor() -> UIColor {
        switch self {
        case .appBackground:
            guard let appBackground = UIColor(named: "appBackground") else {
                assertionFailure("appBackground not found")
                return .gray
            }
            return appBackground
        case .appBlack40:
            guard let appBlack40 = UIColor(named: "appBlack40") else {
                assertionFailure("appBlack40 color not found")
                return UIColor.gray
            }
            return appBlack40
        case .appBlack60:
            guard let appBlack60 = UIColor(named: "appBlack60") else {
                assertionFailure("appBlack60 color not found")
                return UIColor.gray
            }
            return appBlack60
        case .appMainText:
            guard let appMainText = UIColor(named: "appMainText") else {
                assertionFailure("appMainText color not found")
                return UIColor.white
            }
            return appMainText
        case .appPurple:
            guard let appPurple = UIColor(named: "appPurple") else {
                assertionFailure("appPurple not found")
                return UIColor.blue
            }
            return appPurple
        }
    }
}

extension UIColor {
    static func getAppColors(_ colorName: AppColor) -> UIColor {
        colorName.getColor()
    }
}
