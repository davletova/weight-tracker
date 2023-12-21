import Foundation
import UIKit

enum AppColor {
    case appLightGray, appBlack40, appBlack60, appMainText, appPurple,
         appGeneralBackground, appGray20, appPopoverBackground
    
    func getColor() -> UIColor {
        switch self {
        case .appLightGray:
            guard let appLightGray = UIColor(named: "appLightGray") else {
                assertionFailure("appLightGray not found")
                return .white
            }
            return appLightGray
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
                return UIColor.black
            }
            return appMainText
        case .appPurple:
            guard let appPurple = UIColor(named: "appPurple") else {
                assertionFailure("appPurple not found")
                return UIColor.purple
            }
            return appPurple
        case .appGeneralBackground:
            guard let appGeneralBackground = UIColor(named: "appGeneralBackground") else {
                assertionFailure("appGeneralBackground not found")
                return UIColor.white
            }
            return appGeneralBackground
        case .appGray20:
            guard let appGray20 = UIColor(named: "appGray20") else {
                assertionFailure("appGray20 not found")
                return UIColor.gray
            }
            return appGray20
        case .appPopoverBackground:
            guard let appPopoverBackground = UIColor(named: "appPopoverBackground") else {
                assertionFailure("appPopoverBackground not found")
                return UIColor.gray
            }
            return appPopoverBackground
        }
    }
}
