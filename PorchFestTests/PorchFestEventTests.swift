//
//  PorchFestEventTests.swift
//  PorchFestTests
//
//  Created by Griffin Homan on 9/23/24.
//

import Foundation
import XCTest
@testable import PorchFest

class PorchFestEventTests: XCTestCase {
    
    func testDecodePorchFestEventLocally() {
        guard let url = Bundle(for: type(of: self)).url(forResource: "Ithaca2024", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            XCTFail("Could not load Ithaca2024.json")
            return
        }

        let decoder = JSONDecoder()
        
        do {
            let porchFestEvent = try decoder.decode(PorchFestEvent.self, from: data)
            XCTAssertEqual(porchFestEvent.city, "Ithaca")
            XCTAssertFalse(porchFestEvent.artists.isEmpty)
            XCTAssertEqual(porchFestEvent.artists[0].name, "The Accords")
        } catch {
            XCTFail("Failed to decode PorchFestEvent: \(error)")
        }
    }
    
    //Testing that JSON works with S3 bucket
    func testDecodePorchFestEventFromRemote() {
        guard let url = URL(string: "https://porchfest-assets.s3.amazonaws.com/porchfest-data/porchfests/Ithaca2024.json") else {
            XCTFail("Invalid URL")
            return
        }
        
        let expectation = self.expectation(description: "Downloading Ithaca2024.json from remote server")
        
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
                let porchFestEvent = try decoder.decode(PorchFestEvent.self, from: data)
                XCTAssertEqual(porchFestEvent.city, "Ithaca")
                XCTAssertFalse(porchFestEvent.artists.isEmpty)
                XCTAssertEqual(porchFestEvent.artists[0].name, "The Accords")
            } catch {
                XCTFail("Failed to decode PorchFestEvent from remote: \(error)")
            }
            
            // Fulfill the expectation when the task is complete
            expectation.fulfill()
        }
        
        task.resume()
        
        // Wait for the asynchronous task to complete (timeout after 10 seconds)
        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
