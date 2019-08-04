//
//  LyriksTests.swift
//  LyriksTests
//
//  Created by Eduardo Pereira on 28/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//
import Foundation
import Quick
import Nimble


@testable import Lyriks

class LyriksTests: QuickSpec {

    override func spec(){
        describe("View Modell") {
            
        
            context("on Collection cell"){
                let movieMock = MovieMock()
                let movie = movieMock.mock[0]
                let model = CollectionCellViewModel(movie: movie)
                it("Should have same title"){
                    expect(movie.title).to(equal(model.title.string))
                }
                it("Should have same id"){
                    expect(movie.id).to(equal(model.id))
                }
                it("Should have same image"){
                    expect(movie.image).to(equal(model.image))
                }
                it("Have the right model reference"){
                    expect(movie).to(be(model.getMovie()))
                }
            }
            context("on Table cell"){
                let movieMock = MovieMock()
                let movie = movieMock.mock[0]
                let model = TableCellViewModel(movie: movie)
              
                it("Should have same title"){
                    expect(movie.title).to(equal(model.title.string))
                }
                it("Have the same release"){
                    expect(movie.vote_average).to(be(model.vote.string))
                }

                it("Have the right model reference"){
                    expect(movie).to(be(model.getMovie()))
                }
            }
            
            context("on Detail View Model"){
                let movieMock = MovieMock()
                let movie = movieMock.mock[0]
                let model = DetailsViewModel(movie: movie)
                
                it("Should have same id"){
                    expect(movie.id).to(equal(model.id))
                }
            
                
            }
            

        }
    }

}


