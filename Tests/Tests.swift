import XCTest
@testable import RSRangedDateTimePicker

final class RSRangedDateTimePickerTests: XCTestCase {

    // MARK: - DateRange Tests

    func testDateRangeNormalOrder() {
        let start = Date(timeIntervalSince1970: 1000)
        let end = Date(timeIntervalSince1970: 2000)
        let range = PickerView.DateRange(start: start, end: end)

        XCTAssertEqual(range.start, start)
        XCTAssertEqual(range.end, end)
    }

    func testDateRangeSwapsInvertedDates() {
        let start = Date(timeIntervalSince1970: 2000)
        let end = Date(timeIntervalSince1970: 1000)
        let range = PickerView.DateRange(start: start, end: end)

        XCTAssertEqual(range.start, end)
        XCTAssertEqual(range.end, start)
    }

    func testDateRangeEqualDates() {
        let date = Date(timeIntervalSince1970: 1000)
        let range = PickerView.DateRange(start: date, end: date)

        XCTAssertEqual(range.start, range.end)
    }

    func testDateRangeEquality() {
        let range1 = PickerView.DateRange(start: Date(timeIntervalSince1970: 1000), end: Date(timeIntervalSince1970: 2000))
        let range2 = PickerView.DateRange(start: Date(timeIntervalSince1970: 1000), end: Date(timeIntervalSince1970: 2000))

        XCTAssertEqual(range1, range2)
    }

    // MARK: - Config Tests

    func testDateConfigDefaults() {
        let config = PickerView.Config.date

        XCTAssertEqual(config.minutesInterval, 1440)
        XCTAssertEqual(config.minimumMultipleOfMinutesIntervalForRangeDuration, 0)
        XCTAssertTrue(config.minimumDate < config.maximumDate)
    }

    func testTimeConfigDefaults() {
        let config = PickerView.Config.time

        XCTAssertEqual(config.minutesInterval, 15)
        XCTAssertEqual(config.minimumMultipleOfMinutesIntervalForRangeDuration, 3)
        XCTAssertTrue(config.minimumDate < config.maximumDate)
    }

    func testCustomConfigCreation() {
        let min = Date(timeIntervalSince1970: 0)
        let max = Date(timeIntervalSince1970: 86400)
        let config = PickerView.Config(
            minimumDate: min,
            maximumDate: max,
            minutesInterval: 30,
            minimumMultipleOfMinutesIntervalForRangeDuration: 2,
            calendar: Calendar.current
        )

        XCTAssertEqual(config.minutesInterval, 30)
        XCTAssertEqual(config.minimumMultipleOfMinutesIntervalForRangeDuration, 2)
        XCTAssertEqual(config.minimumDate, min)
        XCTAssertEqual(config.maximumDate, max)
    }

    // MARK: - Style Tests

    func testStyleIsRange() {
        XCTAssertFalse(PickerView.Style.date().isRange)
        XCTAssertFalse(PickerView.Style.time().isRange)
        XCTAssertTrue(PickerView.Style.dateRange().isRange)
        XCTAssertTrue(PickerView.Style.timeRange().isRange)
    }

    func testStyleIsTime() {
        XCTAssertFalse(PickerView.Style.date().isTime)
        XCTAssertTrue(PickerView.Style.time().isTime)
        XCTAssertFalse(PickerView.Style.dateRange().isTime)
        XCTAssertTrue(PickerView.Style.timeRange().isTime)
    }

    func testDefaultDateFormatterNotNil() {
        let formatter = PickerView.Style.defaultDateFormatter
        let result = formatter.string(from: Date())
        XCTAssertFalse(result.isEmpty)
    }

    func testDefaultTimeFormatterNotNil() {
        let formatter = PickerView.Style.defaultTimeFormatter
        let result = formatter.string(from: Date())
        XCTAssertFalse(result.isEmpty)
    }

    // MARK: - Coordinator Helper Tests

    func testCoordinatorDateCalculation() {
        let pickerView = PickerView(style: .dateRange(), config: .date)
        let coordinator = PickerView.Coordinator(pickerView)
        coordinator.refreshDates()

        let baseDate = coordinator.startDate(component: 0)
        let row5Date = coordinator.date(component: 0, row: 5)

        let expectedInterval = TimeInterval(5 * 1440 * 60)
        XCTAssertEqual(row5Date.timeIntervalSince(baseDate), expectedInterval, accuracy: 1)
    }

    func testCoordinatorRowCalculation() {
        let pickerView = PickerView(style: .dateRange(), config: .date)
        let coordinator = PickerView.Coordinator(pickerView)
        coordinator.refreshDates()

        let baseDate = coordinator.startDate(component: 0)
        let targetDate = baseDate.addingTimeInterval(TimeInterval(5 * 1440 * 60))
        let row = coordinator.row(date: targetDate, component: 0)

        XCTAssertEqual(row, 5)
    }

    func testCoordinatorRowRoundTrip() {
        let pickerView = PickerView(style: .timeRange(), config: .time)
        let coordinator = PickerView.Coordinator(pickerView)
        coordinator.refreshDates()

        let originalRow = 3
        let date = coordinator.date(component: 0, row: originalRow)
        let computedRow = coordinator.row(date: date, component: 0)

        XCTAssertEqual(originalRow, computedRow)
    }

    func testCoordinatorNumberOfDatesPositive() {
        let pickerView = PickerView(style: .dateRange(), config: .date)
        let coordinator = PickerView.Coordinator(pickerView)
        coordinator.refreshDates()

        let count0 = coordinator.numberOfDatesForComponent(0)
        let count1 = coordinator.numberOfDatesForComponent(1)

        XCTAssertGreaterThan(count0, 0)
        XCTAssertGreaterThan(count1, 0)
    }

    func testCoordinatorSingleModeNumberOfDates() {
        let pickerView = PickerView(style: .time(), config: .time)
        let coordinator = PickerView.Coordinator(pickerView)
        coordinator.refreshDates()

        let count = coordinator.numberOfDatesForComponent(0)
        XCTAssertGreaterThan(count, 0)
    }

    func testCoordinatorEndComponentStartDateHasOffset() {
        let pickerView = PickerView(style: .timeRange(), config: .time)
        let coordinator = PickerView.Coordinator(pickerView)
        coordinator.refreshDates()

        let startStart = coordinator.startDate(component: 0)
        let endStart = coordinator.startDate(component: 1)
        let expectedOffset = TimeInterval(coordinator.minimumRangeDurationInMinutes * 60)

        XCTAssertEqual(endStart.timeIntervalSince(startStart), expectedOffset, accuracy: 1)
    }

    func testCoordinatorExtractTime() {
        let pickerView = PickerView(style: .time(), config: .time)
        let coordinator = PickerView.Coordinator(pickerView)

        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.hour = 14
        components.minute = 30
        let date = calendar.date(from: components)!

        let extracted = coordinator.extractTimeFrom(date: date)
        let extractedComponents = calendar.dateComponents([.hour, .minute], from: extracted)

        XCTAssertEqual(extractedComponents.hour, 14)
        XCTAssertEqual(extractedComponents.minute, 30)
    }

    func testRowNeverNegative() {
        let pickerView = PickerView(style: .dateRange(), config: .date)
        let coordinator = PickerView.Coordinator(pickerView)
        coordinator.refreshDates()

        let veryOldDate = Date(timeIntervalSince1970: 0)
        let row = coordinator.row(date: veryOldDate, component: 0)

        XCTAssertGreaterThanOrEqual(row, 0)
    }
}
