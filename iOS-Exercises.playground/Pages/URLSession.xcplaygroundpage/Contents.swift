//: [Previous](@previous)

import Foundation

class URLSessionGist {
  lazy var urlSession = URLSession.shared
  lazy var url = URL(string: "https://api.github.com/")!
  lazy var urlRequest = URLRequest(url: url)
  
  // URL and String encoding.
  func fetchData() {
    let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Error: \(error)")
        return
      }
      if let response = response as? HTTPURLResponse, response.statusCode != 200 {
        print("Status code: \(response.statusCode) \n Response: \(response)")
        return
      }
      // String encoding.
      if let data = data, let body = String(data: data, encoding: String.Encoding.utf8) {
        print(body)
      }
    }
    dataTask.resume()
  }
  
  // URLRequest, Completion handler and JSONSerialization.
  func fetchData(completionHandler: @escaping (Dictionary<String, Any>) -> Void) {
    let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
      if let error = error {
        completionHandler(["Error": error])
        return
      }
      if let response = response as? HTTPURLResponse, response.statusCode != 200 {
        completionHandler(["Status Code": response.statusCode, "Response": response])
        return
      }
      if let data = data {
        do {
          if let jsonData =
              try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            completionHandler(jsonData)
          }
        } catch let parseError {
          completionHandler(["JSONSerialization Error": parseError.localizedDescription])
        }
      }
    }
    dataTask.resume()
  }
  
}
let gist = URLSessionGist()
gist.fetchData()
gist.fetchData(completionHandler: { (dictionary) in
  for (key, valye) in dictionary {
    print("\(key) = \(valye)")
  }
})

//: [Next](@next)
