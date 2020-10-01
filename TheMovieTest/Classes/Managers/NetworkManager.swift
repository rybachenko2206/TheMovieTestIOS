//
//  NetworkManager.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 26.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation


class NetworkManager {
    func getPopularMovies(page: Int, completion: @escaping (Result<GetMoviesResponse, TMError>) -> Void) {
        request(with: .getPopularMovies(page: page), completion: completion)
    }

    func getVideos(for movieId: Int64, completion: @escaping (Result<GetVideosResult, TMError>) -> Void) {
        request(with: .getVideos(movieId: movieId.description), completion: completion)
    }

    
    func request<D: Decodable>(with method: APIMethod, completion: @escaping (Result<D, TMError>) -> Void) {
        guard let urlRequest = method.urlRequest else {
            completion(.failure(TMError.defaultError))
            return
        }
        
        pl("request.url = \n\(urlRequest.url?.absoluteString ?? ".. is nil")")
        
        URLSession
            .shared
            .dataTask(with: urlRequest,
                      completionHandler: { [weak self] data, response, error in
                        guard let self = self else { return }
                        
                        guard self.isResponseValid(response),
                            error == nil,
                            let responseData = data
                            else {
                                self.handleFailure(with: data,
                                                    response: response,
                                                    error: error,
                                                    completion: completion)
                                return
                        }
                        
                        let json = JSON(responseData)
                        pl("\nrequest \(method) response: \n\(json)\n")
                        
                        if let serverError = try? JSONDecoder().decode(ServerError.self, from: responseData) {
                            self.executeInMainThread(with: .failure(TMError(serverError: serverError)),
                                                     completion: completion)
                        } else {
                            do {
                                let decodedResponse = try Utils.jsonDecoder.decode(D.self, from: responseData)
                                self.executeInMainThread(with: .success(decodedResponse), completion: completion)
                            } catch let err {
                                var message: String?
                                if let decodingError = err as? DecodingError {
                                    pl("Decoding error: \n\(decodingError)")
                                    message = decodingError.localizedDescription
                                }
                                self.executeInMainThread(with: .failure(.parseResponseModel(message)), completion: completion)
                            }
                        }
                        
            })
            .resume()
    }
    
    private func executeInMainThread<D: Decodable>(with result: Result<D, TMError>, completion:  @escaping (Result<D, TMError>) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
    private func isResponseValid(_ response: URLResponse?) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse,
            200..<300 ~= httpResponse.statusCode
            else { return false }
        return true
    }
    
    private func handleFailure<D: Decodable>(with data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<D, TMError>) -> Void) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        if let errorData = data  {
            do {
                let serverErr = try JSONDecoder().decode(ServerError.self, from: errorData)
                let apiError = TMError(serverError: serverErr)
                executeInMainThread(with: .failure(apiError), completion: completion)
            } catch let decodeError {
                if let stCode = statusCode {
                    let apiError = TMError(error: error, statusCode: stCode)
                    executeInMainThread(with: .failure(apiError), completion: completion)
                } else {
                    pl("decode response error: \n\(decodeError.localizedDescription)")
                    executeInMainThread(with: .failure(TMError.defaultError), completion: completion)
                }
            }
        } else if let error = error {
            pl("received error = \n\(error)")
            let apiError = TMError(error: error, statusCode: statusCode)
            executeInMainThread(with: .failure(apiError), completion: completion)
        } else {
            let apiError = TMError(error: error, statusCode: statusCode)
            executeInMainThread(with: .failure(apiError), completion: completion)
        }
    }
    
}


enum APIMethod {
    static let baseURL: URL = URL(string: "https://api.themoviedb.org/3")!
    
    case getPopularMovies(page: Int)
    case getVideos(movieId: String)
    
    var httpMethod: String {
        switch self {
        case .getPopularMovies,
             .getVideos:
            return "GET"
        }
    }
    
    var url: URL? {
        switch self {
        case .getPopularMovies:
            return APIMethod.baseURL.appendingPathComponent("movie/popular")
        case .getVideos(let movieId):
            return APIMethod.baseURL.appendingPathComponent("movie/\(movieId)/videos")
        }
    }
    
    var headers: [String: String] {
        let headerFields: [String: String] = [
            "Content-Type": "application/json;charset=utf-8"
        ]
        
        return headerFields
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url,
            var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else { return nil }
        
        if let params = requestParameters {
            urlComp.queryItems = params.compactMap({ URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        guard let finalUrl = urlComp.url else { return nil}
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    var requestParameters: [String: String]? {
        var parameters: [String: String] = [
            Keys.kApiKey: Constants.tmdbApiKey
        ]
        
        switch self {
        case .getPopularMovies(let page):
            parameters[Keys.kPage] = page.description
        default:
            break
        }
        
        return parameters
    }
    
}
