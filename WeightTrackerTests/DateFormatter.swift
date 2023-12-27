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
    
    func testDayMonthEn() {
        struct testCase {
            var inputDate: String
            var expectedResult: String
        }
        
        let testCases: [testCase] = [
            testCase(
                inputDate: "05/01/2016",
                expectedResult: "05 Jan"
            ),
            testCase(
                inputDate: "01/02/2016",
                expectedResult: "01 Feb"
            ),
            testCase(
                inputDate: "10/03/2016",
                expectedResult: "10 Mar"
            ),
            testCase(
                inputDate: "23/04/2016",
                expectedResult: "23 Apr"
            ),
            testCase(
                inputDate: "05/05/2016",
                expectedResult: "05 May"
            ),
            testCase(
                inputDate: "16/06/2016",
                expectedResult: "16 Jun"
            ),
            testCase(
                inputDate: "05/07/2016",
                expectedResult: "05 Jul"
            ),
            testCase(
                inputDate: "15/08/2016",
                expectedResult: "15 Aug"
            ),
            testCase(
                inputDate: "01/09/2016",
                expectedResult: "01 Sep"
            ),
            testCase(
                inputDate: "29/10/2016",
                expectedResult: "29 Oct"
            ),
            testCase(
                inputDate: "30/11/2016",
                expectedResult: "30 Nov"
            ),
            testCase(
                inputDate: "31/12/2016",
                expectedResult: "31 Dec"
            ),
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        for tc in testCases {
            let date = dateFormatter.date(from: tc.inputDate)!
            XCTAssertEqual(date.formatDayMonth(locale: Locale.init(identifier: "en-EN")), tc.expectedResult)
        }
    }
}

class FormatShortFullDateTests: XCTestCase {
    func testWithRuLocale() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let date = dateFormatter.date(from: "31/12/2016")!
        
        XCTAssertEqual(date.formatShortFullDate(locale: Locale.init(identifier: "ru-RU")), "31.12.16")
    }
    
    func testWithEnLocale() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let date = dateFormatter.date(from: "01/08/2023")!
        
        XCTAssertEqual(date.formatShortFullDate(locale: Locale.init(identifier: "en-EN")), "01.08.23")
    }
}

class FormatFullDateTests: XCTestCase {
    func testFullDateRu() {
        struct testCase {
            var inputDate: String
            var expectedResult: String
        }
        
        let testCases: [testCase] = [
            testCase(
                inputDate: "05/01/2016",
                expectedResult: "05 января 2016"
            ),
            testCase(
                inputDate: "01/02/2016",
                expectedResult: "01 февраля 2016"
            ),
            testCase(
                inputDate: "10/03/2016",
                expectedResult: "10 марта 2016"
            ),
            testCase(
                inputDate: "23/04/2016",
                expectedResult: "23 апреля 2016"
            ),
            testCase(
                inputDate: "05/05/2016",
                expectedResult: "05 мая 2016"
            ),
            testCase(
                inputDate: "16/06/2016",
                expectedResult: "16 июня 2016"
            ),
            testCase(
                inputDate: "05/07/2016",
                expectedResult: "05 июля 2016"
            ),
            testCase(
                inputDate: "15/08/2016",
                expectedResult: "15 августа 2016"
            ),
            testCase(
                inputDate: "01/09/2016",
                expectedResult: "01 сентября 2016"
            ),
            testCase(
                inputDate: "29/10/2016",
                expectedResult: "29 октября 2016"
            ),
            testCase(
                inputDate: "30/11/2016",
                expectedResult: "30 ноября 2016"
            ),
            testCase(
                inputDate: "31/12/2016",
                expectedResult: "31 декабря 2016"
            ),
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        for tc in testCases {
            let date = dateFormatter.date(from: tc.inputDate)!
            XCTAssertEqual(date.formatFullDate(locale: Locale.init(identifier: "ru-RU")), tc.expectedResult)
        }
    }
    
    func testDayMonthEn() {
        struct testCase {
            var inputDate: String
            var expectedResult: String
        }
        
        let testCases: [testCase] = [
            testCase(
                inputDate: "05/01/2016",
                expectedResult: "05 January 2016"
            ),
            testCase(
                inputDate: "01/02/2016",
                expectedResult: "01 February 2016"
            ),
            testCase(
                inputDate: "10/03/2016",
                expectedResult: "10 March 2016"
            ),
            testCase(
                inputDate: "23/04/2016",
                expectedResult: "23 April 2016"
            ),
            testCase(
                inputDate: "05/05/2016",
                expectedResult: "05 May 2016"
            ),
            testCase(
                inputDate: "16/06/2016",
                expectedResult: "16 June 2016"
            ),
            testCase(
                inputDate: "05/07/2016",
                expectedResult: "05 July 2016"
            ),
            testCase(
                inputDate: "15/08/2016",
                expectedResult: "15 August 2016"
            ),
            testCase(
                inputDate: "01/09/2016",
                expectedResult: "01 September 2016"
            ),
            testCase(
                inputDate: "29/10/2016",
                expectedResult: "29 October 2016"
            ),
            testCase(
                inputDate: "30/11/2016",
                expectedResult: "30 November 2016"
            ),
            testCase(
                inputDate: "24/12/2010",
                expectedResult: "24 December 2010"
            ),
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        for tc in testCases {
            let date = dateFormatter.date(from: tc.inputDate)!
            XCTAssertEqual(date.formatFullDate(locale: Locale.init(identifier: "en-EN")), tc.expectedResult)
        }
    }
}

class StartOfYearTests: XCTestCase {
    func testDateIsBeginOfYear() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let date = dateFormatter.date(from: "01/01/2023")!
        let expectedStartOdYear = dateFormatter.date(from: "01/01/2023")!
        
        XCTAssertEqual(date.startOfYear(), expectedStartOdYear)
    }
    
    func testDateIsEndOfYear() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let date = dateFormatter.date(from: "31/12/2023")!
        let expectedStartOdYear = dateFormatter.date(from: "01/01/2023")!
        
        XCTAssertEqual(date.startOfYear(), expectedStartOdYear)
    }
    
    func testMidYearDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let date = dateFormatter.date(from: "12/06/2023")!
        let expectedStartOdYear = dateFormatter.date(from: "01/01/2023")!
        
        XCTAssertEqual(date.startOfYear(), expectedStartOdYear)
    }
}
