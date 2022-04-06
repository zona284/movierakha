//
//  FavoriteMovieProvider.swift
//  movierakha
//
//  Created by LIMA 1 on 06/04/22.
//

import CoreData
import UIKit

class FavoriteMovieProvider {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "movierakha")

        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil

        return container
    }()

    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil

        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }

    func getAllFavorite(completion: @escaping(_ members: [MovieData]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var favorites: [MovieData] = []
                for result in results {
                    let movieData = MovieData(
                        backdropPath: result.value(forKeyPath: "backdropPath") as? String,
                        id: result.value(forKeyPath: "id") as? Int,
                        originalTitle: result.value(forKeyPath: "originalTitle") as? String,
                        overview: result.value(forKeyPath: "overview") as? String,
                        releaseDate: result.value(forKeyPath: "releaseDate") as? String,
                        title: result.value(forKeyPath: "title") as? String
                    )
                    favorites.append(movieData)
                }
                completion(favorites)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }

    func addToFavorite(
        _ movieData: MovieData,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: taskContext) {
                let favorite = NSManagedObject(entity: entity, insertInto: taskContext)
                favorite.setValue(movieData.id, forKeyPath: "id")
                favorite.setValue(movieData.backdropPath, forKeyPath: "backdropPath")
                favorite.setValue(movieData.releaseDate, forKeyPath: "releaseDate")
                favorite.setValue(movieData.title, forKeyPath: "title")
                favorite.setValue(movieData.originalTitle, forKeyPath: "originalTitle")
                favorite.setValue(movieData.overview, forKeyPath: "overview")

                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }

    func checkIsFavorite(id: Int, completion: @escaping(_ favorite: Bool) -> Void) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                let lastFav = try taskContext.fetch(fetchRequest)
                if let favData = lastFav.first, let _ = favData.value(forKeyPath: "id") as? Int {
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func deleteFavorite(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }

}
