//
//  MessageServiceHelper.swift
//  Kinder Care
//
//  Created by CIPL0668 on 17/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

class MessageServiceHelper {
    
    class func requestFormData<T: Codable>(router: MessageServiceManager, completion: @escaping (Result<T, CustomError>) -> ()) {
        
        let window = UIApplication.shared.windows.first
        
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(.offline("Please Check Your Internet Connection")))
            return
        }
        
       // MBProgressHUD.showAdded(to: window!, animated: true)
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
       // components.port = router.port
        
        guard let url = components.url else { return }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = router.method
        
        for (key, value) in router.headerFields {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        if let parameters = router.formDataParameters {
            
            print(parameters)
            
            for(key, value) in parameters {
                
                print(key, value)
                
                if let attachmentValue = value as? [URL] {
                    if attachmentValue.count > 0 {
                    for index in 0...attachmentValue.count-1 {
                        
                        let filename = attachmentValue[index].lastPathComponent
                        
                        let splitName = filename.split(separator: ".")
                        
                        let filetype = String(splitName.last ?? "")
                        
                        let today = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyyMMddHHmmss"
                        formatter.timeZone = TimeZone(abbreviation: "IST")
                        let timeStampDate = formatter.string(from: today)
                        
                        if let _spliName = splitName.first {
                            
                            let fileNameWithDate =  _spliName + timeStampDate
                            
                            let _key = "\(key)[\(index)]"
                            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                            data.append("Content-Disposition: form-data; name=\"\(_key)\"; filename=\"\(fileNameWithDate)\"\r\n".data(using: .utf8)!)
                            data.append("Content-Type: image/\(filetype)\r\n\r\n".data(using: .utf8)!)
                            
                            do {
                                let imageData = try Data(contentsOf:attachmentValue[index], options:[])
                                data.append(imageData)
                            }
                            catch {
                                // can't load image data
                                print("can't load image data")
                            }
                        }
                    }
                }
                }
                else if let sentToIds = value as? [Int] {
                    for x in 0...sentToIds.count-1 {
                        let _key = "\(key)[\(x)]"
                        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                        data.append("Content-Disposition: form-data; name=\"\(_key)\"\r\n\r\n".data(using: .utf8)!)
                        data.append("\(sentToIds[x])".data(using: .utf8)!)
                    }
                }
                else if let image = value as? UIImage, let imageData = image.jpegData(compressionQuality: 1.0) {
                    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    data.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\("Image")\"\r\n".data(using: .utf8)!)
                    data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    data.append(imageData)
                }
                else {
                    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                    data.append("\(value)".data(using: .utf8)!)
                }
            }
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        
        ServiceHelper.instance.requestFormData(withData: data, forRequest: request, completion: { data, error, statusCode  in
            
            DispatchQueue.main.async {
                
              //  MBProgressHUD.hide(for: window!, animated: true)
                
                switch statusCode {
                case .create: break
                case .success:
                    
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            
                            print("Success Dictionary :",dict)
                            
                            let responseObject = try! JSONDecoder().decode(T.self, from: _data)
                            print(responseObject)
                            completion(.success(responseObject))
                            
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                case .noContent :
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            print(dict)
                            if let errorMessages = dict["message"] as? String{
                                completion(.failure(.message(errorMessages)))
                            }
                            else if let errorMessages = dict["Message"] as? String{
                                completion(.failure(.message(errorMessages)))
                            }
                            else {
                                completion(.failure(.unKnown("Please Give Valid Data")))
                            }
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                case .notFound,.serverError:
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            print(dict)
                            if let errorMessages = dict["errors"] as? NSDictionary, let key = errorMessages.allKeys.first as? String, let value = errorMessages[key] as? String {
                                completion(.failure(.message(value)))
                            }
                            else {
                                completion(.failure(.unKnown("Please Give Valid Data")))
                            }
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                    
                case .unAuthorized:
                    completion(.failure(.unKnown("Please Give Valid Data")))
                case .tooManyAttempts:
                    completion(.failure(.tooManyAttemps))
                }
            }
        })
    }
    
    class func request<T: Codable>(router: MessageServiceManager, completion: @escaping (Result<T, CustomError>) -> ()) {
        
        let window = UIApplication.shared.windows.first
        
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(.offline("Please Check Your Internet Connection")))
            return
        }
        
        MBProgressHUD.showAdded(to: window!, animated: true)
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
       // components.port = router.port
        components.queryItems = router.parameters
        
        guard let url = components.url else { return }
        
        print(url)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in router.headerFields {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        if let data = router.body {
            urlRequest.httpBody = data
        }
        
        ServiceHelper.instance.request(forUrlRequest: urlRequest, completion: { data, error, statusCode  in
            
            DispatchQueue.main.async {
                
                MBProgressHUD.hide(for: window!, animated: true)
                
                switch statusCode {
                case .create: break
                case .success:
                    
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            
                            print(dict)
                            
                            let responseObject = try! JSONDecoder().decode(T.self, from: _data)
                            print(responseObject)
                            completion(.success(responseObject))
                            
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                case .noContent :
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            print(dict)
                            if let errorMessages = dict["message"] as? String{
                                completion(.failure(.message(errorMessages)))
                            }
                            else {
                                completion(.failure(.unKnown("Please Give Valid Data")))
                            }
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                case .notFound,.serverError:
                    guard let _data = data else {
                        completion(.failure(.unKnown("Please Give Valid Data")))
                        return
                    }
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                            print(dict)
                            if let errorMessages = dict["errors"] as? NSDictionary, let key = errorMessages.allKeys.first as? String, let value = errorMessages[key] as? String {
                                completion(.failure(.message(value)))
                            }
                            else {
                                completion(.failure(.unKnown("Please Give Valid Data")))
                            }
                        }
                        else {
                            completion(.failure(.unKnown("Please Give Valid Data")))
                        }
                    }
                    catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                    
                    
                    //                case .serverError:
                    //                    completion(.failure(.unKnown))
                    
                    
                case .unAuthorized:
                    completion(.failure(.unKnown("Please Give Valid Data")))
                case .tooManyAttempts:
                    completion(.failure(.tooManyAttemps))
                case .tooManyAttempts:
                    completion(.failure(.tooManyAttemps))
                }
            }
        })
    }
}
