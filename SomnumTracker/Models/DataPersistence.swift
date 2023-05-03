//
//  DataPersistence.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 3/5/23.
//

import Foundation

import UIKit
import CoreData

struct DataPersistence {
    var sleepStats = [SleepData]()
    
    let context: NSManagedObjectContext
    
    static var shared = DataPersistence()
    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveData(completion: ([SleepData]) -> ()) {
        do {
            try context.save()
            completion(sleepStats)
        } catch {
            print("Error saving context, \(error)")
        }
    }

    mutating func deleteData(index: Int, sleepItem: SleepData) {
        context.delete(sleepItem)
        sleepStats.remove(at: index)

        saveData { _ in }
    }
}
