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
    
}
