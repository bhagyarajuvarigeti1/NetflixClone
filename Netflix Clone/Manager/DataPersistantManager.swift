//
//  File.swift
//  Netflix Clone
//
//  Created by mac on 28/10/22.
//

import UIKit
import CoreData

class DataPersistantManager {
    
    enum DataBaseError: Error {
        case failedToSave
    }
    
    static let shared = DataPersistantManager()
    
    func downloadTitleWith(modal: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelgate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelgate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        
        item.originalTitle  = modal.originalTitle
        item.id             = Int64(modal.id)
        item.overView       = modal.overview
        item.originalName   = modal.originalName
        item.mediaType      = modal.mediaType
        item.postarPath     = modal .posterPath
        item.releaseDate    = modal.releaseDate
        item.voteCount      = Int64(modal.voteCount)
        item.voteAverage    = modal.voteAverage
        
        do {
           try context.save()
            completion(.success(()))
        }
        catch {
            print(error.localizedDescription)
            completion(.failure(DataBaseError.failedToSave))
        }
        
    }
    
    func fetchingTitlesDataBase(completion: @escaping (Result<[TitleItem],Error>) -> Void) {
        guard let appDelgate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelgate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do{
           let titels = try context.fetch(request)
            completion(.success(titels))
        } catch {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
}
