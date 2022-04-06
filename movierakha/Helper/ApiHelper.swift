//
//  ApiHelper.swift
//  movierakha
//
//  Created by Mohammad Rakha Mauludi on 05/04/22.
//

import Foundation

enum Result {
    struct ErrorMessage {
        let message: String
    }
    
    case success
    case failed(ErrorMessage)
}

class ApiHelper {
    private static var baseUrl: String = "https://api.themoviedb.org/3"
    private static var apiKey = "aa252500f232fbfc44bae13e1ff980da"
    
    static func generateImageUrl(image: String) -> String {
        return "https://image.tmdb.org/t/p/w500/\(image)"
    }
    
    static func getMoviesList(category: MovieCategory, completion: @escaping (Result?, MoviesResult?) -> Void) {
        var components = URLComponents(string: "\(baseUrl)/movie/\(category.rawValue)")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            print("\(response)")
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                let resultData = try? decoder.decode(MoviesResult.self, from: data)
                print("data: \(resultData)")
                completion(Result.success, resultData)
            } else {
                completion(Result.failed(Result.ErrorMessage(message: error?.localizedDescription ?? "Error \(response.statusCode)")), nil)
            }
        }
        
        task.resume()
    }
    
    static func getReviews(movieId: Int, completion: @escaping (Result?, ReviewsResult?) -> Void) {
        var components = URLComponents(string: "\(baseUrl)/movie/\(movieId)/reviews")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            print("\(response)")
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                let resultData = try? decoder.decode(ReviewsResult.self, from: data)
                print("data: \(resultData)")
                completion(Result.success, resultData)
            } else {
                completion(Result.failed(Result.ErrorMessage(message: error?.localizedDescription ?? "Error \(response.statusCode)")), nil)
            }
        }
        
        task.resume()
    }
}
