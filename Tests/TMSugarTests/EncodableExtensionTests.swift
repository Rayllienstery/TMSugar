import XCTest
@testable import TMSugar

class EncodableExtensionTests: XCTestCase {
    
    // MARK: - Test Models
    
    struct SimpleModel: Codable, Equatable {
        let name: String
        let age: Int
    }
    
    struct NestedModel: Codable, Equatable {
        let id: String
        let simple: SimpleModel
    }
    
    struct ComplexModel: Codable, Equatable {
        let id: UUID
        let date: Date
        let url: URL
        let optionalValue: String?
        let array: [SimpleModel]
        let dictionary: [String: Int]
    }
    
    // MARK: - Test Properties
    
    private var jsonDecoder: JSONDecoder!
    private var testDate: Date!
    private var testURL: URL!
    private var testUUID: UUID!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        jsonDecoder = JSONDecoder()
        testDate = Date(timeIntervalSince1970: 1234567890)
        testURL = URL(string: "https://example.com")!
        testUUID = UUID()
    }
    
    override func tearDown() {
        jsonDecoder = nil
        testDate = nil
        testURL = nil
        testUUID = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    private func assertEncodingAndDecoding<T: Codable & Equatable>(_ original: T, file: StaticString = #file, line: UInt = #line) throws {
        // When
        let jsonString = try original.asJSONString()
        
        // Then
        // 1. Verify we got a non-empty string
        XCTAssertFalse(jsonString.isEmpty, "JSON string should not be empty", file: (file), line: line)
        
        // 2. Verify it's a valid JSON
        let jsonData = jsonString.data(using: .utf8)!
        XCTAssertNoThrow(try JSONSerialization.jsonObject(with: jsonData), "Should be valid JSON", file: (file), line: line)
        
        // 3. Verify we can decode it back
        let decoded = try JSONDecoder().decode(T.self, from: jsonData)
        XCTAssertEqual(original, decoded, "Decoded object should match original", file: (file), line: line)
    }
    
    // MARK: - Basic Tests
    
    func testSimpleModelEncoding() throws {
        let model = SimpleModel(name: "John", age: 30)
        try assertEncodingAndDecoding(model)
    }
    
    func testNestedModelEncoding() throws {
        let nested = NestedModel(
            id: "123",
            simple: SimpleModel(name: "John", age: 30)
        )
        try assertEncodingAndDecoding(nested)
    }
    
    // MARK: - Complex Type Tests
    
    func testComplexModelEncoding() throws {
        let complex = ComplexModel(
            id: testUUID,
            date: testDate,
            url: testURL,
            optionalValue: nil,
            array: [
                SimpleModel(name: "John", age: 30),
                SimpleModel(name: "Jane", age: 25)
            ],
            dictionary: ["one": 1, "two": 2]
        )
        try assertEncodingAndDecoding(complex)
    }
    
    // MARK: - Collection Tests
    
    func testArrayEncoding() throws {
        let array = [
            SimpleModel(name: "John", age: 30),
            SimpleModel(name: "Jane", age: 25)
        ]
        try assertEncodingAndDecoding(array)
    }
    
    func testEmptyArrayEncoding() throws {
        let emptyArray: [SimpleModel] = []
        try assertEncodingAndDecoding(emptyArray)
    }
    
    func testDictionaryEncoding() throws {
        let dictionary = ["key1": SimpleModel(name: "John", age: 30)]
        try assertEncodingAndDecoding(dictionary)
    }
    
    // MARK: - Performance Tests
    
    func testEncodingPerformance() throws {
        let model = SimpleModel(name: "John", age: 30)
        measure {
            _ = try? model.asJSONString()
        }
    }
    
    func testLargeArrayEncodingPerformance() throws {
        let largeArray = (0..<1000).map { SimpleModel(name: "Name\($0)", age: $0) }
        measure {
            _ = try? largeArray.asJSONString()
        }
    }
    
    // MARK: - Special Cases
    
    func testEncodingWithSpecialCharacters() throws {
        let model = SimpleModel(name: "John \"Quote\" O'Neil\n新年快乐", age: 30)
        try assertEncodingAndDecoding(model)
    }
    
    func testEncodingWithEmptyStrings() throws {
        let model = SimpleModel(name: "", age: 30)
        try assertEncodingAndDecoding(model)
    }
}
