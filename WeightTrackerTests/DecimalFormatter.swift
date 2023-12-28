import Foundation
import XCTest
@testable import WeightTracker

class FormatWeightWithoutUnitTests: XCTestCase {
    func testDisplayRuLocale() {
        let num: Decimal = 56.6
        XCTAssertEqual(num.formatWeightWithoutUnit(locale: Locale(identifier: "ru")), "56,6")
    }

    func testDisplayEnLocale() {
        let num: Decimal = 56.6
        XCTAssertEqual(num.formatWeightWithoutUnit(locale: Locale(identifier: "en")), "56.6")
    }
    
    func testMaximumFractionDigits() {
        let num: Decimal = 56.6123
        XCTAssertEqual(num.formatWeightWithoutUnit(locale: Locale(identifier: "ru")), "56,6")
    }
}

class FormatWeightTests: XCTestCase {
    func testDisplayKgRu() {
        let num: Decimal = 56.6
        XCTAssertEqual(num.formatWeight(in: UnitMass.kilograms, locale: Locale(identifier: "ru")), "56,6 кг")
    }
    
    func testDisplayKgEn() {
        let num: Decimal = 56.6
        XCTAssertEqual(num.formatWeight(in: UnitMass.kilograms, locale: Locale(identifier: "en")), "56.6kg")
    }
    
    func testDisplayLbRu() {
        let num: Decimal = 56.6
        XCTAssertEqual(num.formatWeight(in: UnitMass.pounds, locale: Locale(identifier: "ru")), "124,8 фунт.")
    }
    
    func testDisplayLbEn() {
        let num: Decimal = 56.6
        XCTAssertEqual(num.formatWeight(in: UnitMass.pounds, locale: Locale(identifier: "en_IE")), "124.8lb")
    }
    
    func testMaximumFractionDigits() {
        let num: Decimal = 56.6123
        XCTAssertEqual(num.formatWeight(in: UnitMass.kilograms, locale: Locale(identifier: "ru")), "56,6 кг")
    }
}

class FormatWeightDiffTests: XCTestCase {
    func testPositiveDiffRuKg() {
        let num: Decimal = 56.6
        XCTAssertEqual(num.formatWeightDiff(in: UnitMass.kilograms, locale: Locale(identifier: "ru")), "+56,6 кг")
    }
    
    func testPositiveDiffRuLb() {
        let num: Decimal = 56.6
        XCTAssertEqual(num.formatWeightDiff(in: UnitMass.pounds, locale: Locale(identifier: "ru")), "+124,8 фунт.")
    }
    
    func testPositiveDiffEnKg() {
        let num: Decimal = 56.6
        XCTAssertEqual(num.formatWeightDiff(in: UnitMass.kilograms, locale: Locale(identifier: "en")), "+56.6kg")
    }
    
    func testPositiveDiffEnLb() {
        let num: Decimal = 56.6
        XCTAssertEqual(num.formatWeightDiff(in: UnitMass.pounds, locale: Locale(identifier: "en-IE")), "+124.8lb")
    }
    
    func testNegativeDiffRuKg() {
        let num: Decimal = -56.6
        XCTAssertEqual(num.formatWeightDiff(in: UnitMass.kilograms, locale: Locale(identifier: "ru")), "-56,6 кг")
    }
    
    func testZeroDiffRuKg() {
        let num: Decimal = 0
        XCTAssertEqual(num.formatWeightDiff(in: UnitMass.kilograms, locale: Locale(identifier: "ru")), "0 кг")
    }
    
    func testZeroDiffRuLb() {
        let num: Decimal = 0
        XCTAssertEqual(num.formatWeightDiff(in: UnitMass.pounds, locale: Locale(identifier: "ru")), "0 фунт.")
    }
    
    func testZeroDiffEnKg() {
        let num: Decimal = 0
        XCTAssertEqual(num.formatWeightDiff(in: UnitMass.kilograms, locale: Locale(identifier: "en")), "0kg")
    }
    
    func testZeroDiffEnLb() {
        let num: Decimal = 0
        XCTAssertEqual(num.formatWeightDiff(in: UnitMass.pounds, locale: Locale(identifier: "en-IE")), "0lb")
    }
    
    func testMaximumFractionDigits() {
        let num: Decimal = 56.6234
        XCTAssertEqual(num.formatWeightDiff(in: UnitMass.kilograms, locale: Locale(identifier: "en")), "+56.6kg")
    }
}
