import Foundation
import XCTest
@testable import WeightTracker

class FormatDayMonthTests: XCTestCase {
    func testDayMonthRu() {
        struct testCase {
            var inputDate: String
            var expectedResult: String
        }
        
        let testCases: [testCase] = [
            testCase(
                inputDate: "05/01/2016",
                expectedResult: "05 янв."
            ),
            testCase(
                inputDate: "01/02/2016",
                expectedResult: "01 февр."
            ),
            testCase(
                inputDate: "10/03/2016",
                expectedResult: "10 марта"
            ),
            testCase(
                inputDate: "23/04/2016",
                expectedResult: "23 апр."
            ),
            testCase(
                inputDate: "05/05/2016",
                expectedResult: "05 мая"
            ),
            testCase(
                inputDate: "16/06/2016",
                expectedResult: "16 июня"
            ),
            testCase(
                inputDate: "05/07/2016",
                expectedResult: "05 июля"
            ),
            testCase(
                inputDate: "15/08/2016",
                expectedResult: "15 авг."
            ),
            testCase(
                inputDate: "01/09/2016",
                expectedResult: "01 сент."
            ),
            testCase(
                inputDate: "29/10/2016",
                expectedResult: "29 окт."
            ),
            testCase(
                inputDate: "30/11/2016",
                expectedResult: "30 нояб."
            ),
            testCase(
                inputDate: "31/12/2016",
                expectedResult: "31 дек."
            ),
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        for tc in testCases {
            let date = dateFormatter.date(from: tc.inputDate)!
            XCTAssertEqual(date.formatDayMonth(locale: Locale.init(identifier: "ru-RU")), tc.expectedResult)
        }
    }
}
