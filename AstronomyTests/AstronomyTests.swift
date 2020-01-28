//
//  AstronomyTests.swift
//  AstronomyTests
//
//  Created by Patrick Millet on 1/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import Astronomy

class AstronomyTests: XCTestCase {
    
    func testFetchRover() {
        let mockData = MockDataLoader()
        mockData.data = validRoverJSON
        let controller = MarsRoverClient(networkDataLoader: mockData)
        
        let completionExpectation = expectation(description: "Async finished")
        controller.fetchMarsRover(named: "Curiosity") { _, _ in
            completionExpectation.fulfill()
        }
        wait(for: [completionExpectation], timeout: 10)
        guard let rover = controller.rover else {return}
        XCTAssertEqual("Curiosity", rover.name)
    }
    
    func testFetchPhotos() {
        let mockData = MockDataLoader()
        mockData.data = validRoverJSON
        let controller = MarsRoverClient(networkDataLoader: mockData)
        
        let fetchRoverExpectation = expectation(description: "Rover Found")
        controller.fetchMarsRover(named: "Curiosity") { _, _ in
            fetchRoverExpectation.fulfill()
        }
        
        wait(for: [fetchRoverExpectation], timeout: 10)
        guard let rover = controller.rover else {return}
        
        XCTAssertEqual("Curiosity", rover.name)
        
        mockData.data = validSol1JSON
        let completionExpectation = expectation(description: "Async finished")
        controller.fetchPhotos(from: rover, onSol: 1) { (photos, _) in
            completionExpectation.fulfill()
        }
        wait(for: [completionExpectation], timeout: 10)
        XCTAssertTrue(controller.photos.count > 0)
    }
    
    func testFetchPhotoOperation() {
        let mockData = MockDataLoader()
        let controller = MarsRoverClient(networkDataLoader: mockData)
        mockData.data = validRoverJSON
        
        let fetchRoverExpectation = expectation(description: "Rover Found")
        controller.fetchMarsRover(named: "Curiosity") { _, _ in
            fetchRoverExpectation.fulfill()
        }
        
        wait(for: [fetchRoverExpectation], timeout: 10)
        guard let rover = controller.rover else { return }
        XCTAssertEqual("Curiosity", rover.name)
        
        mockData.data = validSol1JSON
        let completionExpectation = expectation(description: "Async finished")
        var photoRef:MarsPhotoReference?
        
        controller.fetchPhotos(from: rover, onSol: 1) { (photos, _) in
            completionExpectation.fulfill()
            guard let receivedPhotos = photos else {return}
            photoRef = receivedPhotos[0]
        }
        wait(for: [completionExpectation], timeout: 10)
        XCTAssertTrue(controller.photos.count > 0)
        
        guard let photo = photoRef else { return }
        
        let fetchOperationExpectation = expectation(description: "Photos Fetched")
        let fetchPhotoOperation = FetchPhotoOperation(photoReference: photo)
        let photoFetchQueue = OperationQueue()
        
        photoFetchQueue.addOperation {
            fetchOperationExpectation.fulfill()
            fetchPhotoOperation.start()
        }
        
        wait(for: [fetchOperationExpectation], timeout: 10)
        XCTAssertFalse(fetchPhotoOperation.isCancelled)
        XCTAssertNotNil(fetchPhotoOperation.image)
    }
    
    /*
     */
}
