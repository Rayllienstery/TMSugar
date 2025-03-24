//
//  File.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 23.03.2025.
//

import XCTest
@testable import TMSugar

final class DataConversionTests: XCTestCase {

    // MARK: - Test Models
    struct TestUser: Codable, Sendable, Equatable {
        let id: Int
        let name: String
        let email: String
    }

    struct ComplexUser: Codable, Sendable, Equatable {
        let id: Int
        let firstName: String
        let lastName: String
        let createdAt: Date
    }

    struct NestedUser: Codable, Sendable, Equatable {
        struct Address: Codable, Sendable, Equatable {
            let street: String
            let city: String
            let zipCode: String
        }

        let id: Int
        let name: String
        let address: Address
        let tags: [String]
    }

    struct OptionalFieldsUser: Codable, Sendable, Equatable {
        let id: Int
        let name: String
        let email: String?
        let phoneNumber: String?
        let age: Int?
    }

    enum UserType: String, Codable, Sendable {
        case admin
        case regular
        case guest
    }

    struct EnumUser: Codable, Sendable, Equatable {
        let id: Int
        let name: String
        let type: UserType
    }

    struct DecimalUser: Codable, Sendable, Equatable {
        let id: Int
        let name: String
        let balance: Decimal
    }

    // MARK: - Test Properties
    private var validJsonData: Data!
    private var invalidJsonData: Data!
    private var complexJsonData: Data!

    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()

        validJsonData = """
        {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com"
        }
        """.data(using: .utf8)

        invalidJsonData = "invalid json".data(using: .utf8)

        complexJsonData = """
        {
            "id": 1,
            "first_name": "John",
            "last_name": "Doe",
            "created_at": "2023-01-01T12:00:00Z"
        }
        """.data(using: .utf8)
    }

    override func tearDown() {
        validJsonData = nil
        invalidJsonData = nil
        complexJsonData = nil
        super.tearDown()
    }

    // MARK: - Basic Decoding Tests
    func testValidDataDecoding() throws {
        let expectedUser = TestUser(id: 1, name: "John Doe", email: "john@example.com")
        let decodedUser = try validJsonData.asObject(of: TestUser.self)
        XCTAssertEqual(decodedUser, expectedUser)
    }

    func testInvalidDataDecoding() {
        XCTAssertThrowsError(try invalidJsonData.asObject(of: TestUser.self)) { error in
            guard case DataConversionError.decodingFailed = error else {
                XCTFail("Expected DataConversionError.decodingFailed, got \(error)")
                return
            }
        }
    }

    // MARK: - Complex Object Tests
    func testComplexDataDecodingWithStrategies() throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        let decodedUser = try complexJsonData.asObject(
            of: ComplexUser.self,
            using: decoder
        )

        XCTAssertEqual(decodedUser.firstName, "John")
        XCTAssertEqual(decodedUser.lastName, "Doe")
        XCTAssertEqual(
            decodedUser.createdAt.formatted(.iso8601),
            "2023-01-01T12:00:00Z"
        )
    }

    func testNestedObjectDecoding() throws {
        let nestedJsonData = """
        {
            "id": 1,
            "name": "John Doe",
            "address": {
                "street": "123 Main St",
                "city": "New York",
                "zipCode": "10001"
            },
            "tags": ["developer", "swift"]
        }
        """.data(using: .utf8)!

        let decodedUser = try nestedJsonData.asObject(of: NestedUser.self)

        XCTAssertEqual(decodedUser.id, 1)
        XCTAssertEqual(decodedUser.name, "John Doe")
        XCTAssertEqual(decodedUser.address.street, "123 Main St")
        XCTAssertEqual(decodedUser.address.city, "New York")
        XCTAssertEqual(decodedUser.tags, ["developer", "swift"])
    }

    // MARK: - Optional Fields Tests
    func testOptionalFieldsDecoding() throws {
        let partialJsonData = """
        {
            "id": 1,
            "name": "John Doe"
        }
        """.data(using: .utf8)!

        let fullJsonData = """
        {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com",
            "phoneNumber": "+1234567890",
            "age": 30
        }
        """.data(using: .utf8)!

        let partialUser = try partialJsonData.asObject(of: OptionalFieldsUser.self)
        let fullUser = try fullJsonData.asObject(of: OptionalFieldsUser.self)

        XCTAssertNil(partialUser.email)
        XCTAssertNil(partialUser.phoneNumber)
        XCTAssertNil(partialUser.age)

        XCTAssertEqual(fullUser.email, "john@example.com")
        XCTAssertEqual(fullUser.phoneNumber, "+1234567890")
        XCTAssertEqual(fullUser.age, 30)
    }

    // MARK: - Enum Tests
    func testEnumDecoding() throws {
        let enumJsonData = """
        {
            "id": 1,
            "name": "John Doe",
            "type": "admin"
        }
        """.data(using: .utf8)!

        let user = try enumJsonData.asObject(of: EnumUser.self)
        XCTAssertEqual(user.type, .admin)
    }

    func testInvalidEnumDecoding() {
        let invalidEnumJsonData = """
        {
            "id": 1,
            "name": "John Doe",
            "type": "invalid_type"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try invalidEnumJsonData.asObject(of: EnumUser.self))
    }

    // MARK: - Decimal Tests
    func testDecimalDecoding() throws {
        let decimalJsonData = """
        {
            "id": 1,
            "name": "John Doe",
            "balance": 1234.56
        }
        """.data(using: .utf8)!

        let user = try decimalJsonData.asObject(of: DecimalUser.self)
        XCTAssertEqual(user.balance, Decimal(string: "1234.56"))
    }

    // MARK: - Edge Cases Tests
    func testEmptyObjectDecoding() throws {
        let emptyJsonData = "{}".data(using: .utf8)!
        XCTAssertThrowsError(try emptyJsonData.asObject(of: TestUser.self))
    }

    func testNullValueHandling() throws {
        let jsonWithNull = """
        {
            "id": 1,
            "name": "John Doe",
            "email": null
        }
        """.data(using: .utf8)!

        let user = try jsonWithNull.asObject(of: OptionalFieldsUser.self)
        XCTAssertNil(user.email)
    }

    // MARK: - Array Tests
    func testArrayDecoding() throws {
        let arrayJsonData = """
        [
            {
                "id": 1,
                "name": "John Doe",
                "email": "john@example.com"
            },
            {
                "id": 2,
                "name": "Jane Doe",
                "email": "jane@example.com"
            }
        ]
        """.data(using: .utf8)!

        let users = try arrayJsonData.asObject(of: [TestUser].self)

        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users[0].name, "John Doe")
        XCTAssertEqual(users[1].name, "Jane Doe")
    }

    // MARK: - Encoding Tests
    func testValidDataEncoding() throws {
        let user = TestUser(id: 1, name: "John Doe", email: "john@example.com")
        let encodedData = try user.toData()
        let decodedUser = try encodedData.asObject(of: TestUser.self)
        XCTAssertEqual(user, decodedUser)
    }

    func testCustomEncodingStrategy() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let user = TestUser(id: 1, name: "John Doe", email: "john@example.com")
        let encodedData = try user.toData(using: encoder)
        let encodedString = String(data: encodedData, encoding: .utf8)

        XCTAssertNotNil(encodedString)
        XCTAssert(encodedString?.contains("  ") ?? false)
    }

    // MARK: - Async Tests
    func testAsyncValidDataDecoding() async throws {
        let expectedUser = TestUser(id: 1, name: "John Doe", email: "john@example.com")
        let decodedUser = try await validJsonData.asObject(of: TestUser.self)
        XCTAssertEqual(decodedUser, expectedUser)
    }

    func testAsyncInvalidDataDecoding() async {
        do {
            _ = try await invalidJsonData.asObject(of: TestUser.self)
            XCTFail("Expected error to be thrown")
        } catch {
            guard case DataConversionError.decodingFailed = error else {
                XCTFail("Expected DataConversionError.decodingFailed, got \(error)")
                return
            }
        }
    }

    func testConcurrentDecoding() async throws {
        let numberOfOperations = 100
        let user = TestUser(id: 1, name: "John Doe", email: "john@example.com")
        let encodedData = try await user.toData()

        async let decodingOperations = withTaskGroup(of: TestUser.self) { group in
            for _ in 0..<numberOfOperations {
                group.addTask {
                    try! await encodedData.asObject(of: TestUser.self)
                }
            }

            var results: [TestUser] = []
            for await result in group {
                results.append(result)
            }
            return results
        }

        let results = await decodingOperations

        XCTAssertEqual(results.count, numberOfOperations)
        XCTAssertTrue(results.allSatisfy { $0 == user })
    }

    // MARK: - Performance Tests
    func testDecodingPerformance() throws {
        measure {
            for _ in 0..<1000 {
                do {
                    _ = try validJsonData.asObject(of: TestUser.self)
                } catch {
                    XCTFail("Decoding failed: \(error)")
                }
            }
        }
    }

    func testEncodingPerformance() throws {
        let user = TestUser(id: 1, name: "John Doe", email: "john@example.com")

        measure {
            for _ in 0..<1000 {
                do {
                    _ = try user.toData()
                } catch {
                    XCTFail("Encoding failed: \(error)")
                }
            }
        }
    }
}
