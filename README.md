# TMSugar (SwiftUI)
<br/>
<img src= "https://raw.githubusercontent.com/Rayllienstery/TMMediaStorage/main/TMSugar/Icon.png" width="256" >

## Installation

### Swift Package Manager
Add the following to your `Package.swift` file:
```swift
dependencies: [
    .package(url: "your-repository-url", from: "1.0.0")
]
```

## Requirements
- iOS 16.0+
- Swift 5.9+
- Xcode 10.0+



# Syntax Sugar for the common iOS functionality
<br/>

## Date Estensions
 - A Swift extension for the Date class that provides convenient methods for handling week and month-related calculations.
 - This extension simplifies working with calendar components by providing easy access to day and month indices.

## Features
- Get zero-based day of week index (0-6, Sunday = 0)
- Get one-based day of week number (1-7, Sunday = 1)
- Get zero-based current month index (0-11, January = 0)
- Get one-based current month number (1-12, January = 1)

### Usage
```swift
let date = Date()

// Get day of week (0-6, Sunday = 0)
if let dayIndex = date.dayOfWeekIndex {
    print("Day index: \(dayIndex)")
}

// Get day of week (1-7, Sunday = 1)
if let dayNumber = date.dayOfWeekNumber {
    print("Day number: \(dayNumber)")
}

// Get current month (0-11, January = 0)
if let monthIndex = date.currentMonthIndex {
    print("Month index: \(monthIndex)")
}

// Get current month (1-12, January = 1)
if let monthNumber = date.currentMonthNumber {
    print("Month number: \(monthNumber)")
}
```



## Color Extensions for SwiftUI
A collection of Swift extensions that provide convenient conversion methods between SwiftUI Color and dictionary representations. These extensions simplify color handling and storage by allowing seamless conversion between Color objects and their RGBA component dictionaries.
<br/>

## Features
- Convert SwiftUI Color to dictionary with RGBA components
- Convert dictionary with RGBA components back to SwiftUI Color
- Special handling for primary colors (red, green, blue)
- Safe fallback values for missing dictionary components

### Usage
```swift
// Using standard colors
let redColor = Color.red
let redDict = redColor.asDictionary
// Result: ["red": 1, "green": 0, "blue": 0, "opacity": 1]

// Using custom color
let customColor = Color(red: 0.5, green: 0.3, blue: 0.7, opacity: 0.8)
let colorDict = customColor.asDictionary
// Result: ["red": 0.5, "green": 0.3, "blue": 0.7, "opacity": 0.8]

// Complete color components
let dict: [String: Double] = [
    "red": 0.5,
    "green": 0.3,
    "blue": 0.7,
    "opacity": 0.8
]
let color = dict.asColor

// With missing components (using default values)
let partialDict: [String: Double] = [
    "red": 0.5,
    "green": 0.3
]
let colorWithDefaults = partialDict.asColor
// Missing blue defaults to 0
// Missing opacity defaults to 1
```



## Data Extensions for Swift
A comprehensive set of Swift extensions for Data type that provides convenient conversion methods to common formats like UIImage, SwiftUI Image, String, and JSON string. These extensions simplify data handling and conversion operations in iOS applications.
<br/>

## Features
- Convert Data to UIKit.UIImage
- Convert Data to SwiftUI.Image
- Convert Data to String with UTF-8 encoding
- Convert Data to formatted JSON string
- Safe conversions with optional returns

### Usage
```swift
// Assuming we have some data
let data: Data = // ... some data ...

// Convert to UIImage
if let uiImage = data.asUIImage {
    // Use UIKit image
    let imageView = UIImageView(image: uiImage)
}

// Convert to SwiftUI Image
if let swiftUIImage = data.asImage {
    // Use in SwiftUI view
    VStack {
        swiftUIImage
            .resizable()
            .frame(width: 100, height: 100)
    }
}

// Convert to String
if let string = data.asString {
    print("String content: \(string)")
    // Example output: "String content: Hello, World!"
}

// Convert to JSON String
if let jsonString = data.asJSONString {
    print("JSON content: \(jsonString)")
    // Example output:
    // JSON content: {
    //    "name": "John",
    //    "age": 30
    // }
}
```



### Example with Network Response
```swift
// Example with URLSession response
URLSession.shared.dataTask(with: url) { data, response, error in
    guard let data = data else { return }
    
    // Convert API JSON response to formatted string
    if let jsonString = data.asJSONString {
        print("API Response: \(jsonString)")
    }
    
    // Convert image data to SwiftUI Image
    if let image = data.asImage {
        DispatchQueue.main.async {
            // Use image in SwiftUI view
            self.imageView = image
        }
    }
}.resume()
```



## Data and Encodable Extensions for Swift
Advanced extensions for Data and Encodable types that provide robust encoding and decoding capabilities with support for both synchronous and asynchronous operations. These extensions offer flexible configuration options for JSON encoding/decoding strategies.
<br/>

## Features
- Convert Data to any Decodable object type
- Convert Encodable objects to Data
- Support for custom key encoding/decoding strategies
- Support for custom date encoding/decoding strategies
- Async/await support for encoding and decoding operations
- Comprehensive error handling

### Usage

#### Decoding Data to Objects
```swift
// Sample JSON data
let jsonData: Data = """
{
    "user_name": "John Doe",
    "created_at": "2023-01-01T12:00:00Z"
}
""".data(using: .utf8)!

// Define a model
struct User: Decodable {
    let userName: String
    let createdAt: Date
}

// Basic usage
do {
    let user = try jsonData.asObject(of: User.self)
    print("User name: \(user.userName)")
} catch {
    print("Decoding failed: \(error)")
}

// With custom decoding strategies
do {
    let decoder = JSONDecoder()
    let user = try jsonData.asObject(
        of: User.self,
        using: decoder,
        keyDecodingStrategy: .convertFromSnakeCase,
        dateDecodingStrategy: .iso8601
    )
    print("User created at: \(user.createdAt)")
} catch {
    print("Decoding failed: \(error)")
}

// Async usage
Task {
    do {
        let user = try await jsonData.asObject(of: User.self)
        print("Async decoded user: \(user.userName)")
    } catch {
        print("Async decoding failed: \(error)")
    }
}
```

#### Encoding Objects to Data
```swift
// Define a model
struct Product: Encodable {
    let productName: String
    let price: Double
    let createdAt: Date
}

// Create an instance
let product = Product(
    productName: "iPhone",
    price: 999.99,
    createdAt: Date()
)

// Basic encoding
do {
    let data = try product.toData()
    print("Encoded data size: \(data.count) bytes")
} catch {
    print("Encoding failed: \(error)")
}

// With custom encoding strategies
do {
    let encoder = JSONEncoder()
    let data = try product.toData(
        using: encoder,
        keyEncodingStrategy: .convertToSnakeCase,
        dateEncodingStrategy: .iso8601
    )
    
    if let jsonString = String(data: data, encoding: .utf8) {
        print("Encoded JSON: \(jsonString)")
    }
} catch {
    print("Encoding failed: \(error)")
}

// Async encoding
Task {
    do {
        let data = try await product.toData()
        print("Async encoded data size: \(data.count) bytes")
    } catch {
        print("Async encoding failed: \(error)")
    }
}
```

### Error Handling Example
```swift
enum DataConversionError: Error {
    case decodingFailed(Error)
    case encodingFailed(Error)
}

// Handling specific errors
do {
    let user = try jsonData.asObject(of: User.self)
} catch DataConversionError.decodingFailed(let error) {
    print("Decoding error: \(error.localizedDescription)")
} catch {
    print("Unknown error: \(error)")
}
```



## Encodable Extension for JSON String Conversion
An extension for Encodable types that provides a convenient way to convert any encodable object into a formatted JSON string. This extension includes pretty printing for better readability and comprehensive error handling.
<br/>

## Features
- Convert any Encodable object to a formatted JSON string
- Pretty-printed output formatting
- Comprehensive error handling
- UTF-8 encoding support

### Usage
```swift
// Example with a simple struct
struct User: Encodable {
    let name: String
    let age: Int
    let email: String
}

let user = User(
    name: "John Doe",
    age: 30,
    email: "john@example.com"
)

// Convert to JSON string
do {
    let jsonString = try user.asJSONString()
    print(jsonString)
    /* Output:
    {
      "name" : "John Doe",
      "age" : 30,
      "email" : "john@example.com"
    }
    */
} catch {
    print("Conversion failed: \(error)")
}

// Example with nested structures
struct Company: Encodable {
    let name: String
    let employees: [User]
}

let company = Company(
    name: "Tech Corp",
    employees: [
        User(name: "John Doe", age: 30, email: "john@example.com"),
        User(name: "Jane Smith", age: 28, email: "jane@example.com")
    ]
)

do {
    let jsonString = try company.asJSONString()
    print(jsonString)
    /* Output:
    {
      "name" : "Tech Corp",
      "employees" : [
        {
          "name" : "John Doe",
          "age" : 30,
          "email" : "john@example.com"
        },
        {
          "name" : "Jane Smith",
          "age" : 28,
          "email" : "jane@example.com"
        }
      ]
    }
    */
} catch DataConversionError.invalidData {
    print("Invalid data error")
} catch DataConversionError.encodingFailed(let error) {
    print("Encoding failed: \(error)")
} catch {
    print("Unknown error: \(error)")
}
```



## String Extensions for URL and Data Conversion
A collection of Swift extensions for String that provide convenient methods for URL handling and data conversion. These extensions include URL validation, URL extraction from text, and data conversion capabilities.
<br/>

## Features
- Convert String to URL with validation
- Extract URLs from text content
- Convert String to File URL
- Convert String to Data with UTF-8 encoding
- Comprehensive error handling for URL extraction

### Usage

#### Basic URL Conversion
```swift
// Convert string to URL
let urlString = "https://www.example.com"
if let url = urlString.asURL {
    print("Valid URL: \(url)")
} else {
    print("Invalid URL")
}

// Invalid URL examples
let invalidURL = "https://example with spaces.com"
print(invalidURL.asURL == nil) // true

let invalidURLNoHost = "just-a-string"
print(invalidURLNoHost.asURL == nil) // true
```

#### Extracting URLs from Text
```swift
let text = """
    Check out these websites:
    https://www.example.com
    Contact us at support@example.com
    Or visit http://blog.example.com
    """

do {
    let urls = try text.extractURLs()
    urls.forEach { url in
        print("Found URL: \(url)")
    }
    /* Output:
    Found URL: https://www.example.com
    Found URL: http://blog.example.com
    */
} catch {
    print("URL extraction failed: \(error)")
}
```

#### File URL Conversion
```swift
// Convert string path to file URL
let filePath = "/Users/username/Documents/file.txt"
if let fileURL = filePath.convertToFileURL() {
    print("File URL: \(fileURL)")
    // Output: "File URL: file:///Users/username/Documents/file.txt"
}
```

#### Data Conversion
```swift
// Convert string to Data
let message = "Hello, World!"
if let data = message.asData {
    print("Data byte count: \(data.count)")
    
    // Convert back to string
    if let backToString = String(data: data, encoding: .utf8) {
        print("Converted string: \(backToString)")
    }
}
```

#### Real-world Example
```swift
// Example of processing a text document with URLs
func processDocument(content: String) {
    // Extract and validate URLs
    do {
        let urls = try content.extractURLs()
        
        for url in urls {
            // Validate each URL
            if url.absoluteString.asURL != nil {
                print("Valid URL found: \(url)")
                
                // Process the URL
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data,
                       let responseString = data.asString {
                        print("Response from \(url): \(responseString)")
                    }
                }.resume()
            }
        }
    } catch {
        print("URL processing failed: \(error)")
    }
}

// Usage
let document = """
    Please visit our website at https://www.example.com
    For support: https://support.example.com
    Invalid URL: not a url
    """
processDocument(content: document)
```
