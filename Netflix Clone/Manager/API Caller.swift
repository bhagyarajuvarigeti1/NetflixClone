//
//  API Caller.swift
//  Netflix Clone
//
//  Created by mac on 26/10/22.
//

import Foundation

struct Constants {
    static let baseUrl          = "https://api.themoviedb.org"
    static let API_KEY          = "04f3c8840cdf350b2e693cbfe6a05b12"
    static let YouTube_ApiKey   = "AIzaSyA5R2TdSiKkfFZ6yt9Vo5ofRVAitCrHcIs"
    static let youtubebaseUrl   = "https://youtube.googleapis.com/youtube/v3/search?"
}

class APICaller {
    
    static let shared = APICaller()
    
    private init() { }
    private var searchMoviesTask : URLSessionDataTask?
    
    func fetchTrendingMovies(completion: @escaping(Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/all/day?api_key=\(Constants.API_KEY)") else { return }
        let task      = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder  = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result   = try decoder.decode( TrendingMovieResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }

     func fetchTrendingTvs(completion: @escaping (Result<[Movie], Error>) -> Void) {
         guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
         let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
             guard let data = data, error == nil else {
                 return
             }

             do {
                 let decoder  = JSONDecoder()
                 decoder.keyDecodingStrategy = .convertFromSnakeCase
                 let result   = try decoder.decode( TrendingMovieResponse.self, from: data)
                 completion(.success(result.results))
             }
             catch {
                 completion(.failure(APIError.failedTogetData))
             }
         }
         
         task.resume()
     }
     
     
     func fetchUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
         guard let url = URL(string: "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
         let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
             guard let data = data, error == nil else {
                 return
             }
             
             do {
                 let decoder  = JSONDecoder()
                 decoder.keyDecodingStrategy = .convertFromSnakeCase
                 let result   = try decoder.decode( TrendingMovieResponse.self, from: data)
                 completion(.success(result.results))
             } catch {
                 print(error.localizedDescription)
             }

         }
         task.resume()
     }
     
     func fetchPopular(completion: @escaping (Result<[Movie], Error>) -> Void) {
         guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
         let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
             guard let data = data, error == nil else {
                 return
             }
             
             do {
                 let decoder  = JSONDecoder()
                 decoder.keyDecodingStrategy = .convertFromSnakeCase
                 let result   = try decoder.decode( TrendingMovieResponse.self, from: data)
                 completion(.success(result.results))
             } catch {
                 completion(.failure(APIError.failedTogetData))
             }
         }
         
         task.resume()
     }
     
     func fetchTopRated(completion: @escaping (Result<[Movie], Error>) -> Void) {
         guard let url = URL(string: "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
         let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
             guard let data = data, error == nil else {
                 return
             }
             
             do {
                 let decoder  = JSONDecoder()
                 decoder.keyDecodingStrategy = .convertFromSnakeCase
                 let result   = try decoder.decode( TrendingMovieResponse.self, from: data)
                 completion(.success(result.results))
             } catch {
                 completion(.failure(APIError.failedTogetData))
             }

         }
         task.resume()
     }
     
     
     func getDiscoverMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
         guard let url = URL(string: "\(Constants.baseUrl)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
         let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
             guard let data = data, error == nil else {
                 return
             }
             
             do {
                 let decoder  = JSONDecoder()
                 decoder.keyDecodingStrategy = .convertFromSnakeCase
                 let result   = try decoder.decode( TrendingMovieResponse.self, from: data)
                 completion(.success(result.results))

             } catch {
                 completion(.failure(APIError.failedTogetData))
             }

         }
         task.resume()
     }
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        searchMoviesTask?.cancel()
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {return }
        searchMoviesTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder  = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result   = try decoder.decode( TrendingMovieResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        searchMoviesTask?.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtubebaseUrl)q=\(query)&key=\(Constants.YouTube_ApiKey)") else {return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder  = JSONDecoder()
                let result   = try decoder.decode( YouTubeSearchResponse.self, from: data)
                completion(.success(result.items[0]))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
}

enum  APIError: Error {
    case failedTogetData
}
