//
//  DataPersistence.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 3/5/23.
//

import UIKit
import CoreData

struct DataPersistence {
    // MARK: - Properties
    var sleepData = [SleepData]()
    let context: NSManagedObjectContext
    static var shared = DataPersistence()
    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    mutating func loadTitles(with savedRequest: NSFetchRequest<SleepData> = SleepData.fetchRequest(),
                             completion: ([SleepData]) -> ()) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sleepData: [SleepData]
        do {
            sleepData = try context.fetch(savedRequest)
        } catch {
            print("Error fetching sleepData context, \(error)")
            return
        }
        
        self.sleepData = sleepData
        
        completion(sleepData)
    }
    
    mutating func saveData(_ sleepStats: SleepStat? = nil, completion: ([SleepData]) -> ()) {
        if let stats = sleepStats {
            let data = SleepData(context: context)
            
            data.date = stats.date
            data.dateString = stats.dateString
            data.sleepDuration = stats.sleepDuration
            data.timeOfSleep = stats.timeOfSleep
            data.wakeUpTime = stats.wakeUpTime
            data.weekOfYear = stats.weekOfYear
            data.year = stats.year
            
            sleepData.append(data)
        }

        do {
            try context.save()
            completion(sleepData)
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    mutating func deleteData(_ sleepStat: SleepStat) {
        
        if let index = sleepData.firstIndex(where: {$0.dateString! == sleepStat.dateString}) {
            context.delete(sleepData [index])
            saveData { _ in }
            sleepData.remove(at: index)
        } else {
            print("Error deleting data")
        }
    }

    mutating func deleteAllData() {
        for data in sleepData {
            context.delete(data)
            saveData { _ in }
        }
        sleepData.removeAll()
    }
}
