//
//  movierakhaTests.swift
//  movierakhaTests
//
//  Created by LIMA 1 on 05/04/22.
//

import Foundation
import XCTest
@testable import movierakha

class movierakhaTests: XCTestCase {

    func testParseJson_Movie() {
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "adult": false,
                    "backdrop_path": "/iQFcwSGbZXMkeyKrxbPnwnRo5fl.jpg",
                    "genre_ids": [
                        28,
                        12,
                        878
                    ],
                    "id": 634649,
                    "original_language": "en",
                    "original_title": "Spider-Man: No Way Home",
                    "overview": "Peter Parker is unmasked and no longer able to separate his normal life from the high-stakes of being a super-hero. When he asks for help from Doctor Strange the stakes become even more dangerous, forcing him to discover what it truly means to be Spider-Man.",
                    "popularity": 6064.019,
                    "poster_path": "/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg",
                    "release_date": "2021-12-15",
                    "title": "Spider-Man: No Way Home",
                    "video": false,
                    "vote_average": 8.2,
                    "vote_count": 11022
                }
            ],
            "total_pages": 33023,
            "total_results": 660442
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let resultData = try? decoder.decode(MoviesResult.self, from: json)
        
        XCTAssertNotNil(resultData)
        XCTAssertEqual(resultData?.results?.first?.id, 634649)
    }
    
    func testParseJson_Review() {
        let json = """
        {
            "id": 634649,
            "page": 1,
            "results": [
                {
                    "author": "garethmb",
                    "author_details": {
                        "name": "",
                        "username": "garethmb",
                        "avatar_path": "/https://www.gravatar.com/avatar/3593437cbd05cebe0a4ee753965a8ad1.jpg",
                        "rating": 10.0
                    },
                    "content": "Life for Peter Parker",
                    "created_at": "2021-12-15T15:35:00.071Z",
                    "id": "61ba0b24d1444300413e2cbe",
                    "updated_at": "2021-12-15T15:35:00.071Z",
                    "url": "https://www.themoviedb.org/review/61ba0b24d1444300413e2cbe"
                }
            ],
            "total_pages": 1,
            "total_results": 8
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let resultData = try? decoder.decode(ReviewsResult.self, from: json)
        
        XCTAssertNotNil(resultData)
        XCTAssertEqual(resultData?.id, 634649)
        XCTAssertEqual(resultData?.results?.first?.author, "garethmb")
    }
    
    func testDateFormatFromString() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let someDateTime = formatter.date(from: "2022-04-05 22:22")
        let dateTest = "2022-04-05 22:22".toDate(format: "yyyy-MM-dd HH:mm")
        
        XCTAssertEqual(someDateTime, dateTest)
    }
    
    func testConvertDateFormat() {
        let stringDate = "2022-04-04T10:00:34.832Z"
        let oldFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let newFormat = "yyyy-MM-dd HH:mm"
        let expected = "2022-04-04 10:00"
        
        let result = stringDate.toDate(format: oldFormat)?.convertToString(format: newFormat)
        
        XCTAssertEqual(result, expected)
    }

}
