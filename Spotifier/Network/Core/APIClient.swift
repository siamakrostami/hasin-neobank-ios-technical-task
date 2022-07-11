//
//  APIClient.swift
//  Spotifier
//
//  Created by Siamak Rostami on 5/16/22.
//

import Foundation
import Alamofire

//MARK: - Networking Protocols
protocol APIClientProtocols {
    func request<T>(_ endpoint: URLRequestConvertible, result: @escaping (Result<T, ClientError>) -> Void) where T: Decodable, T: Encodable
    func uploadRequest<T>(_ endpoint: URLRequestConvertible,file: Data? ,result: @escaping (Result<T, ClientError>) -> Void,  progressCompletion: @escaping (Double) -> Void) where T: Decodable, T: Encodable
    func cancelAllRequests()
}

//MARK: - Class Definition
class APIClient {
    private let sessionManager: Session
    private let decoder: JSONDecoder
    private let interceptor : RetrierInterceptor
    required init(session: Session = Session()) {
        self.sessionManager = session
        self.decoder = JSONDecoder()
        self.interceptor = RetrierInterceptor(limit: 3, delay: 3)
    }
    
}

//MARK: - Protocol Impl
extension APIClient : APIClientProtocols {
    //reuquest
    func request<T : Codable>(_ endpoint: URLRequestConvertible, result: @escaping (Result<T, ClientError>) -> Void) {
        guard let urlRequest = try? endpoint.asURLRequest() else {
            result(.failure(.invalidRequest))
            return
        }
        let request = sessionManager.request(urlRequest,interceptor: interceptor)
        request
            .responseData { response in
                guard let code = response.response?.statusCode else {
                    result(.failure(.unknown))
                    return
                }
                switch code{
                case 200...299:
                    switch response.result{
                    case.success(let data):
                        do{
                            let finalData = try self.decoder.decode(T.self, from: data)
                            result(.success(finalData))
                            
                        }catch{
                            debugPrint(error.localizedDescription)
                            result(.failure(.parser))
                        }
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                        let finalError = ClientError(rawValue: error.responseCode ?? 1002)
                        result(.failure(finalError ?? .unknown))
                    }
                default:
                    let finalError = ClientError(rawValue: response.response?.statusCode ?? 1002)
                    result(.failure(finalError ?? .unknown))
                }
                
            }
    }
    //upload reques
    func uploadRequest<T: Codable>(_ endpoint: URLRequestConvertible, file: Data?, result: @escaping (Result<T, ClientError>) -> Void,  progressCompletion: @escaping (Double) -> Void) {
        guard let urlRequest = try? endpoint.asURLRequest() else {
            result(.failure(ClientError.invalidRequest))
            return
        }
        
        let request = sessionManager.upload(multipartFormData: { multiPart in
            guard let file = file else {return}
            guard let type = Swime.mimeType(data: file) else {return}
            multiPart.append(file, withName: "file" , fileName: "file", mimeType: type.mime)
        }, with: urlRequest)
        
        request
            .validate()
            .uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
                progressCompletion(progress.fractionCompleted)
            }
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case let .success(model):
                    result(.success(model))
                case let .failure(error):
                    result(.failure(ClientError(rawValue: error.responseCode ?? 1002) ?? ClientError.unknown))
                }
            }
    }
    
    //cancel all requests
    func cancelAllRequests() {
        self.sessionManager.cancelAllRequests()
    }
    
}
