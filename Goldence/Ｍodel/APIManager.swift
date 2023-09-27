//
//  APIManager.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/14.
//

import Foundation

class GoogleBooksAPIManager {
    static let shared = GoogleBooksAPIManager()
    private let baseURL = "https://www.googleapis.com/books/v1/volumes"
    private let apiKey = "AIzaSyCA0UALLdo7qmYmH0h2kxfIU54xHdbRDBc"
    func searchBookByISBN(isbn: String, completion: @escaping (Result<Book, Error>) -> Void) {
        // 構建 API 請求 URL
        let urlString = "\(baseURL)?q=isbn:\(isbn)&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        // 創建 API 請求
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            do {
                // 解析 JSON 回應
                let decoder = JSONDecoder()
                let book = try decoder.decode(Book.self, from: data)
                completion(.success(book))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
