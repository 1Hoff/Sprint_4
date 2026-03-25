import Foundation

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL: URL {
        let imageURLString = imageURL.absoluteString
        if let index = imageURLString.range(of: "._")?.lowerBound {
            let basePath = String(imageURLString[..<index])
            let newURLString = basePath + "._V1_UX600_CR0,0,600,900_AL_.jpg"
            return URL(string: newURLString) ?? imageURL
        }
        return imageURL
    }

    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}


struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

