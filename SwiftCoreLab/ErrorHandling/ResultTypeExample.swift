//
//  ResultTypeExample.swift
//  SwiftCoreLab
//
//  Created by Vidhi Rana on 29/12/25.
//

enum NetworkError: Error {
    case badURL
    case serverError
}

func fetchData(from url: String) throws -> String {
    if url.isEmpty {
        throw NetworkError.badURL
    }
    return "Success"
}

func demoErrorHandling() {
    do {
        let result = try fetchData(from: "")
        print(result)
    } catch {
        print("Error:", error)
    }
}

func demoResultType(completion: (Result<String, Error>) -> Void) {
    if Bool.random() {
        completion(.success("OK"))
    } else {
        completion(.failure(NetworkError.serverError))
    }
}

