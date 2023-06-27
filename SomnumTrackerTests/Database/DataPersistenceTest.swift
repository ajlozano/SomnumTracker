//
//  SomnumTrackerTests.swift
//  SomnumTrackerTests
//
//  Created by Toni Lozano Fernández on 19/4/23.
//

import XCTest
import CoreData
@testable import SomnumTracker

final class DataPersistenceTest: XCTestCase {

    // GIVEN
    var sut: DataPersistence?
    
    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "SleepStatsDB", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            	
            // Check if creating container wrong
            if let error = error {
                fatalError("In memory coordinator creation failed \(error)")
            }
        }
        return container
    }()
    
    override func setUp() {
        super.setUp()
        self.sut = DataPersistence(container: self.mockPersistentContainer)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadTitlesWhenIsEmptyData() {
        // WHEN
        sut?.loadData(completion: { sleepStats in
            // THEN
            XCTAssertEqual(sleepStats.count, 0)
        })
    }
    
    func testSaveAndLoadDataWhenResultWithData() {
        sut?.loadData(completion: { sleepStats in
            XCTAssertEqual(sleepStats.count, 0)
        })
        // WHEN
        for i in 1...10 {
            sut?.saveData(SleepStat(weekOfYear: "\(i)", timeOfSleep: "\(i)", wakeUpTime: "\(i)", sleepDuration: Double(i), dateString: "\(i)", year: "\(i)", date: Date()), completion: { _ in })
        }
        
        // WHEN
        sut?.loadData(completion: { sleepStats in
            // THEN
            XCTAssertEqual(sleepStats.count, 10)
        })
    }
    
    func testDeleteData() {
        sut?.loadData(completion: { sleepStats in
            XCTAssertEqual(sleepStats.count, 0)
        })
        // WHEN
        for i in 1...10 {
            sut?.saveData(SleepStat(weekOfYear: "\(i)", timeOfSleep: "\(i)", wakeUpTime: "\(i)", sleepDuration: Double(i), dateString: "\(i)", year: "\(i)", date: Date()), completion: { _ in })
        }

        sut?.loadData(completion: { sleepStats in
            XCTAssertEqual(sleepStats.count, 10)
        })

        sut?.deleteData(SleepStat(weekOfYear: "1", timeOfSleep: "1", wakeUpTime: "1", sleepDuration: Double(1), dateString: "1", year: "1", date: Date()))

        sut?.loadData(completion: { sleepStats in
            XCTAssertEqual(sleepStats.count, 9)
            XCTAssertNil(sleepStats.firstIndex(where: {$0.dateString == "1"}))
        })
    }
    
    func testDeleteAllData() {
        sut?.loadData(completion: { sleepStats in
            XCTAssertEqual(sleepStats.count, 0)
        })
        // WHEN
        for i in 1...10 {
            sut?.saveData(SleepStat(weekOfYear: "\(i)", timeOfSleep: "\(i)", wakeUpTime: "\(i)", sleepDuration: Double(i), dateString: "\(i)", year: "\(i)", date: Date()), completion: { _ in })
        }

        sut?.loadData(completion: { sleepStats in
            XCTAssertEqual(sleepStats.count, 10)
        })

        sut?.deleteAllData()

        sut?.loadData(completion: { sleepStats in
            XCTAssertEqual(sleepStats.count, 0)
        })
    }
}
