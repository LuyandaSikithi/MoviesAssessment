import Foundation
import Combine
@testable import MoviesAssessment

class MockedDataResponse {
    static let response = """
        {
        "movies": [
            {
                "backdrop": "https://wookie.codesubmit.io/static/backdrops/d8cbdc3d-c683-4a59-aae3-9a7327f0743a.jpg",
                "cast": [
                    "Tommy Lee Jones",
                    "Javier Bardem",
                    "Josh Brolin"
                ],
                "classification": "18+",
                "director": [
                    "Ethan Coen",
                    "Joel Coen"
                ],
                "genres": [
                    "Crime",
                    "Drama",
                    "Thriller"
                ],
                "id": "d8cbdc3d-c683-4a59-aae3-9a7327f0743a",
                "imdb_rating": 8.1,
                "length": "2h 2min",
                "overview": "Llewelyn Moss stumbles upon dead bodies, $2 million and a hoard of heroin in a Texas desert, but methodical killer Anton Chigurh comes looking for it, with local sheriff Ed Tom Bell hot on his trail. The roles of prey and predator blur as the violent pursuit of money and justice collide.",
                "poster": "https://wookie.codesubmit.io/static/posters/d8cbdc3d-c683-4a59-aae3-9a7327f0743a.jpg",
                "released_on": "2007-11-08T00:00:00",
                "slug": "no-country-for-old-men-2007",
                "title": "No Country for Old Men"
            },
            {
            "backdrop": "https://wookie.codesubmit.io/static/backdrops/4d949e14-b08b-47fb-bab0-22c732dbedf3.jpg",
            "cast": [
                "Harrison Ford",
                "Karen Allen",
                "Paul Freeman"
            ],
            "classification": "7+",
            "director": "Steven Spielberg",
            "genres": [
                "Action",
                "Adventure"
            ],
            "id": "4d949e14-b08b-47fb-bab0-22c732dbedf3",
            "imdb_rating": 8.5,
            "length": "1h 55min",
            "overview": "When Dr. Indiana Jones – the tweed-suited professor who just happens to be a celebrated archaeologist – is hired by the government to locate the legendary Ark of the Covenant, he finds himself up against the entire Nazi regime.",
            "poster": "https://wookie.codesubmit.io/static/posters/4d949e14-b08b-47fb-bab0-22c732dbedf3.jpg",
            "released_on": "1981-06-12T00:00:00",
            "slug": "raiders-of-the-lost-ark-1981",
            "title": "Raiders of the Lost Ark"
        }
        ]
    }
"""
}

