//
//  MyUrlConnection.swift
//  Posts
//
//  Created by yespinoza on 7/25/20.
//

import UIKit

enum httpCode: CustomStringConvertible {
    case get
    case put
    case delete
    case post
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .delete:
            return "DELETE"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        default:
            return "GET"
        }
    }
}

typealias Result = (Data?) -> Void

class UrlConnectionPod: NSObject {
    
    var session:URLSession?
    var request:URLRequest?
    var apiHost:String
    var delegate:CompletitionDelegate?
    
    init(host:String) {
        self.apiHost = host
        session = URLSession.shared
    }
    
    func Execute(path:String, httpMethod:httpCode, httpRequestParams:[String:String]? = nil) {
        request = URLRequest(url: URL(string: apiHost + path)!)
        request?.httpMethod = httpMethod.description
        
        if let params = httpRequestParams {
            for param in params {
                request?.setValue(param.value, forHTTPHeaderField: param.key)
            }
        }
        
        session?.dataTask(with: request!) { (data, response, error) in
            
            do {
                
                DispatchQueue.main.async {
                    if let delegate = self.delegate {
                        delegate.didFinish(data: data!)
                    }
                }
            } catch let error{
                print(error.localizedDescription)
            }
        }.resume()
        
    }

}
