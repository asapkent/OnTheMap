import Foundation


public struct userInfo {
    static var userID = ""
    static var firstName = ""
    static var lastName = ""
    static var mapString = ""
    static var mediaURL = ""
    static var latitude: Float = 0
    static var longitude: Float = 0
    static var objectId: String = ""
}

class Client {
    class func login(username: String, password: String, completion: @escaping (Session?, LoginErrorResponse?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                let networkError = LoginErrorResponse (status: 99, error: "The Network Is Down")
                DispatchQueue.main.async {
                    completion(nil, networkError)
                }
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(Session.self, from: newData!)
                userInfo.userID = responseObject.account.key
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }  catch {
                do {
                    let errorResponse = try decoder.decode(LoginErrorResponse.self, from: newData!)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                        print(errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error as! LoginErrorResponse)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    class func getStudentData(completion: @escaping (StudentData?, Error?) -> Void) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil  {
                let networkError = LoginErrorResponse (status: 99, error: "The Network Is Down")
                DispatchQueue.main.async {
                    completion(nil, networkError)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(StudentData.self, from: data!)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                return
            }
        }
        task.resume()
    }
    

    class func getUserData(completion : @escaping (UserInfo?,Error?)->Void) {
        let userID = userInfo.userID
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(userID)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(UserInfo.self, from: newData!)
                print(String(data: newData!, encoding: .utf8)!)
                    userInfo.firstName = responseObject.firstName
                    userInfo.lastName = responseObject.lastName
                    userInfo.mediaURL = responseObject.mediaURL ?? ""
                print(userInfo.firstName + " " + userInfo.lastName + " " + userInfo.mediaURL)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                return
            }
        }
        task.resume()
    }
    
    
    class func postUserData(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completion : @escaping (Bool,Error?)->Void) {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = StudentLocation(uniqueKey: userInfo.userID, firstName: userInfo.firstName, lastName: userInfo.lastName, mapString: userInfo.mapString, mediaURL: userInfo.mediaURL, latitude: userInfo.latitude, longitude: userInfo.longitude)
        request.httpBody = try! JSONEncoder().encode(body)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {data, response, error in
            if  data != nil {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                
            }
        }
        task.resume()
    }
    
    
    
    class func deleteSession(completion : @escaping (Bool,Error?)->Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            completion(true, nil)
        }
        task.resume()
    }
}
