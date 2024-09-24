//
//  SimplePorchFestEventTests.swift
//  PorchFestTests
//
//  Created by Griffin Homan on 9/23/24.
//

import XCTest
@testable import PorchFest

class SimplePorchFestEventTests: XCTestCase {

    // Test decoding SimplePorchFestEvent locally
    func testDecodeSimplePorchFestEventLocally() {
        guard let url = Bundle(for: type(of: self)).url(forResource: "PorchfestList", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            XCTFail("Could not load PorchfestList.json")
            return
        }

        let decoder = JSONDecoder()

        do {
            let simplePorchFestEvents = try decoder.decode([SimplePorchFestEvent].self, from: data)
            XCTAssertEqual(simplePorchFestEvents[0].city, "Ithaca") // Assuming the first event is Ithaca
            XCTAssertFalse(simplePorchFestEvents.isEmpty) // Check that events are present
        } catch {
            XCTFail("Failed to decode SimplePorchFestEvent: \(error)")
        }
    }

    // Test decoding SimplePorchFestEvent from remote (e.g., S3 bucket)
    func testDecodeSimplePorchFestEventFromRemote() {
        guard let url = URL(string: "https://porchfest-assets.s3.amazonaws.com/porchfest-data/PorchfestList.json") else {
            XCTFail("Invalid URL")
            return
        }

        let expectation = self.expectation(description: "Downloading PorchfestList.json from remote server")

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for networking errors
            if let error = error {
                XCTFail("Failed to download JSON: \(error)")
                return
            }

            guard let data = data else {
                XCTFail("No data returned from remote server")
                return
            }

            // Create JSONDecoder to decode the downloaded data
            let decoder = JSONDecoder()

            do {
                let simplePorchFestEvents = try decoder.decode([SimplePorchFestEvent].self, from: data)
                XCTAssertEqual(simplePorchFestEvents[0].city, "Ithaca") // Assuming the first event is Ithaca
                XCTAssertFalse(simplePorchFestEvents.isEmpty) // Check that events are present
            } catch {
                XCTFail("Failed to decode SimplePorchFestEvent from remote: \(error)")
            }

            // Fulfill the expectation when the task is complete
            expectation.fulfill()
        }

        task.resume()

        // Wait for the asynchronous task to complete (timeout after 10 seconds)
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
