//
//  Movie.swift
//  Movie
//
//  Created by Dias on 2/8/21.
//

import Foundation

class Movie {
    let id: Int
    var posterPath: String
    var date: String
    var title: String
    var overview: String
    var isFavourite: Bool = false
    
    init(json: [String: Any]) throws  {
        guard let id = json["id"] as? Int,
              let posterPath = json["poster_path"] as? String,
              let title = json["original_title"] as? String,
              let date = json["release_date"] as? String,
              let overview = json["overview"] as? String
        else {
            throw NSError(domain: "Error in parsing json", code: 0, userInfo: nil)
        }
        self.id = id
        self.posterPath = posterPath
        self.date = date
        self.title = title
        self.overview = overview
    }
}
