//
//  APICaller.swift
//  NewsApp
//
//  Created by Burak on 27.08.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlineURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f46da0328da347f3807101e407b911fe")
    }
    
    private init(){}
    
    public func getTopStories(completion: @escaping (Result <[Article],Error>) -> Void){
        guard let url = Constants.topHeadlineURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url){data, _ , error  in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
