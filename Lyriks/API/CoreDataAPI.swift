//
//  CoreDataAPI.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 02/08/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit
import CoreData

struct CoredataEntity{
    
     static let localMovie = "LocalMovie"
    
}

struct CoreDataAPI{
    static private var favorites: [LocalMovie] = []
    static func favoritesMovies() -> [Movie]{
        var result:[Movie] = []
        favorites.forEach({ (localMovie) in
            result.append(localMovie.convertToMovie())
        })
        return result
        
    }
    static func fetch(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoredataEntity.localMovie)
        
        do {
            let localMovies = try managedContext.fetch(fetchRequest) as? [LocalMovie]
            favorites = localMovies ?? []

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    static func save(movie: Movie) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: entity,
                                       in: managedContext)!

        
        let localMovie = LocalMovie(entity: entity, insertInto: managedContext)
       
        localMovie.id = String(movie.id)
        localMovie.genres = movie.genres
        localMovie.title = movie.title
        localMovie.vote_average = String(movie.vote_average)
        localMovie.release_data = movie.release_date
        localMovie.overview = movie.overview

        if let image = movie.image {
            if(image.save(id: String(movie.id))){
                print("Sucesso ao salvar imagem")
                
            }else{
                print("Erro ao salvar imagem")
            }
        }
        do {
            try managedContext.save()
            fetch()
            print("favorite saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    static func delete(id:String){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let object = favorites.first { (object) -> Bool in
            return id == object.id
        }
        guard let validateObject = object else{
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        managedContext.delete(validateObject)
        do {
            try managedContext.save()
            fetch()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
    }
    static func isFavorite(id:String)->Bool{
        return self.favorites.contains { (movie) -> Bool in
            guard let comparableId = movie.value(forKeyPath: LocalMovieAtributes.id) as? String else{
                return false
            }
            return id == comparableId
        }
    }
   
}
extension UIImage{
     func save(id:String) -> Bool {
        guard let data = self.jpegData(compressionQuality: 1)
            ?? self.pngData() else {
                return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(id).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    static func getSavedImage(id: String) ->UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return  UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(id).path)
        }
        return nil
    }
}

