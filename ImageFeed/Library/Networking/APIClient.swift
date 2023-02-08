//
//  APIClient.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 05.02.2023.
//

import Foundation

struct APIClient {
    private let session: URLSession
    private let queue: DispatchQueue
    
    init(session: URLSession) {
        self.session = session
        queue = DispatchQueue(label: "SimpleNetworking", qos: .userInitiated, attributes: .concurrent)
    }
    
    // TODO: - дописать функционал
    func send(request: Request) {
        let urlRequest = request.urlRequest()
        
        let task = self.session.dataTask(with: urlRequest) { (data, response, error) in
            
            let result: Result<Data, APIError>
            if let error = error {
                result = .failure(.networkError(error))
            } else if let apiError = APIError.error(from: response) {
                result = .failure(apiError)
            } else {
                result = .success(data ?? Data())
            }
            
            DispatchQueue.main.async {
                // TODO: - решить!
                //request.completion(result)
            }
        }
        task.resume()
    }
}

// MARK: - Result
extension Result where Success == Data, Failure == APIError {
    func decoding<M : Model>(
        _ model: M.Type,
        completion: @escaping (Result<M, APIError>) -> Void
    ) {
        DispatchQueue.global().async {
            let result = self.flatMap { data -> Result<M, APIError> in
                do {
                    let decoder = M.decoder
                    let model = try decoder.decode(M.self, from: data)
                    return .success(model)
                } catch let e as DecodingError {
                    return .failure(.decodingError(e))
                } catch {
                    return .failure(.unhandledResponse)
                }
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
