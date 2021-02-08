//
//  Logic.swift
//  Movie
//
//  Created by Dias on 2/8/21.
//

import Foundation
import UIKit

class MoviesModel {
    static var movies: [Movie] = []
    static let apiToken = "6c78da2cf41529284dc65d510d302bca"
    
    static func getFavouriteMovies() -> [Movie] {
        var res = [Movie]()
        for movie in MoviesModel.movies {
            if movie.isFavourite {
                res.append(movie)
            }
        }
        return res
    }
    
    static func getMovies(reloadData: @escaping (Bool) -> ())  {
        let url = URL(string: "https://api.themoviedb.org/4/list/1?api_key=\(MoviesModel.apiToken)")
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) { rawdata, response, error in
            var isSuccess = true
            if let error = error {
                print(#function, "error", error.localizedDescription)
                return
            }
            
            guard let data = rawdata, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print(#function, "error", "\(String(describing: rawdata))")
                return
            }
            
            guard let movieJSON = json["results"] as? [[String: Any]] else {
                return
            }
            
            for movie in movieJSON {
                do {
                    let parsedMovie = try Movie(json: movie)
                    self.movies.append(parsedMovie)
                } catch {
                    print("Error")
                    isSuccess = false
                }
            }
            
            DispatchQueue.main.async {
                reloadData(isSuccess)
            }
        }.resume()
    }
    
    static func setPoster(for movie: Movie, update: @escaping (Data) -> ()) {
        let posterPath = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
        
        var task: URLSessionTask? = nil
        if let url = posterPath {
            task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    update(data)
                }
            })
        }
        task?.resume()
    }
    
    static func getTrailer(for movie: Movie, update: @escaping (URLRequest) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/videos?api_key=\(apiToken)")

        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        
        let session = URLSession.shared

        session.dataTask(with: request) { rawdata, response, error in
            if let error = error {
                print(#function, "error", error.localizedDescription)
                return
            }

            guard let data = rawdata, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print(#function, "error", "\(String(describing: rawdata))")
                return
            }

            guard let trailerJSON = json["results"] as? [[String: Any]],
                  let trailerKey = trailerJSON[0]["key"] as? String else { return }

            DispatchQueue.main.async {
                guard let url = URL(string: "https://www.youtube.com/embed/\(trailerKey)?playsinline=1?autoplay=1") else { return }
                let request = URLRequest(url: url)
                update(request)
            }
        }.resume()
    }
}
