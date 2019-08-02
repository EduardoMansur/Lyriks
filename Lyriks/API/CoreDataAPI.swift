//
//  CoreDataAPI.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 02/08/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit
import CoreData

struct LocalMovieAtributes{
     static let id = "id"
     static let title = "title"
     static let release = "release_data"
     static let voteAverage = "vote_average"
     static let overview = "overview"
     static let entity = "LocalMovie"
    
}

struct CoreDataAPI{
    static var favorites: [LocalMovie] = []
    
    static func fetch(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: LocalMovieAtributes.entity)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            favorites = (result as? [LocalMovie]) ?? []

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    static func save(movie: Movie,image:UIImage?) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: LocalMovieAtributes.entity,
                                       in: managedContext)!
        
        let localMovie = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        localMovie.setValue(String(movie.id), forKeyPath: LocalMovieAtributes.id )
         localMovie.setValue(movie.title ?? "", forKeyPath: LocalMovieAtributes.title)
        localMovie.setValue(String(movie.vote_average), forKeyPath: LocalMovieAtributes.voteAverage)
        localMovie.setValue(movie.overview ?? "", forKeyPath: LocalMovieAtributes.overview)
        localMovie.setValue(movie.release_date, forKeyPath: LocalMovieAtributes.release)
        if let image = image {
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
       
        
        // 4
        
    }
    static func delete(id:String){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let object = favorites.first { (object) -> Bool in
            guard let comparableId = object.value(forKeyPath: LocalMovieAtributes.id) as? String else{
                return false
            }
            return id == comparableId
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

