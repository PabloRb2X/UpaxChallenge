//
//  CoreDataManager.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        let frameworkBundle = Bundle(for: CoreDataManager.self)
        
        guard let modelURL = frameworkBundle.url(forResource: "LoginModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("No se encontró el modelo de CoreData en el bundle del framework")
        }
        
        persistentContainer = NSPersistentContainer(name: "LoginModel", managedObjectModel: model)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error cargando CoreData: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error guardando contexto: \(error)")
            }
        }
    }
}
