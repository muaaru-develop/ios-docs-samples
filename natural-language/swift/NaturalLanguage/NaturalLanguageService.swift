//
// Copyright 2019 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import googleapis
import AVFoundation

private let apiKey = "[YOUR API KEY]"
class NaturalLanguageService {
  private var client : LanguageService = LanguageService(host: ApplicationConstants.Host)
  private var writer : GRXBufferedPipe = GRXBufferedPipe()
  private var call : GRPCProtoCall!
  static let sharedInstance = NaturalLanguageService()
  var authToken: String = ""

  func textToSentiment(text:String, completionHandler: @escaping (_ documentResponse: AnalyzeSentimentResponse, _ entityResponse: AnalyzeEntitySentimentResponse) -> Void) {
    let documet: Document = Document()
    documet.content = text
    documet.type = Document_Type.plainText

    let analyzeSentiment = AnalyzeSentimentRequest()
    analyzeSentiment.document = documet

    call = client.rpcToAnalyzeSentiment(with: analyzeSentiment) { (analyzeSentimentResponse, error) in
      if error != nil {
        print(error?.localizedDescription ?? "No error description available")
        return
      }
      guard let response = analyzeSentimentResponse else {
        print("No response received")
        return
      }
      print("analyzeSentimentResponse\(response)")
      self.textToEntitySentimentAnalysis(document: documet, analyzeSentimentResponse: response, completionHandler: completionHandler)
    }
    call.requestHeaders.setObject(NSString(string: apiKey), forKey: NSString(string: "X-Goog-Api-Key"))
    // if the API key has a bundle ID restriction, specify the bundle ID like this
    self.call.requestHeaders.setObject(NSString(string:Bundle.main.bundleIdentifier!), forKey:NSString(string:"X-Ios-Bundle-Identifier"))
    print("HEADERS:\(String(describing: call.requestHeaders))")
    call.start()
  }

  func textToEntitySentimentAnalysis(document: Document, analyzeSentimentResponse: AnalyzeSentimentResponse, completionHandler: @escaping (_ documentResponse: AnalyzeSentimentResponse, _ entityResponse: AnalyzeEntitySentimentResponse) -> Void) {
    let analyzeEntitySentiment = AnalyzeEntitySentimentRequest()
    analyzeEntitySentiment.document = document

    call = client.rpcToAnalyzeEntitySentiment(with: analyzeEntitySentiment, handler: { (analyzeEntitySentimentResponse, error) in
      if error != nil {
        print(error?.localizedDescription ?? "No error description available")
        return
      }
      guard let response = analyzeEntitySentimentResponse else {
        print("No response received")
        return
      }
      print("analyzeSentimentResponse\(response)")
      completionHandler(analyzeSentimentResponse, response)
    })
    call.requestHeaders.setObject(NSString(string: apiKey), forKey: NSString(string: "X-Goog-Api-Key"))
    // if the API key has a bundle ID restriction, specify the bundle ID like this
    self.call.requestHeaders.setObject(NSString(string:Bundle.main.bundleIdentifier!), forKey:NSString(string:"X-Ios-Bundle-Identifier"))
    print("HEADERS:\(String(describing: call.requestHeaders))")
    call.start()
  }

  func textToEntity(text:String, completionHandler: @escaping (_ response: AnalyzeEntitiesResponse) -> Void) {
    let documet: Document = Document()
    documet.content = text
    documet.type = Document_Type.plainText

    let analyzeEntity = AnalyzeEntitiesRequest()
    analyzeEntity.document = documet

    call = client.rpcToAnalyzeEntities(with: analyzeEntity) { (analyzeEntitiesResponse, error) in
      if error != nil {
        print(error?.localizedDescription ?? "No error description available")
        return
      }
      guard let response = analyzeEntitiesResponse else {
        print("No response received")
        return
      }
      print("analyzeEntitiesResponse\(response)")
      completionHandler(response)
    }
    call.requestHeaders.setObject(NSString(string: apiKey), forKey: NSString(string: "X-Goog-Api-Key"))
    // if the API key has a bundle ID restriction, specify the bundle ID like this
    self.call.requestHeaders.setObject(NSString(string:Bundle.main.bundleIdentifier!), forKey:NSString(string:"X-Ios-Bundle-Identifier"))
    print("HEADERS:\(String(describing: call.requestHeaders))")
    call.start()
  }

  func textToSyntax(text:String, completionHandler: @escaping (_ response: AnalyzeSyntaxResponse) -> Void) {
    let documet: Document = Document()
    documet.content = text
    documet.type = Document_Type.plainText

    let analyzeSyntax = AnalyzeSyntaxRequest()
    analyzeSyntax.document = documet

    call = client.rpcToAnalyzeSyntax(with: analyzeSyntax) { (analyzeSyntaxResponse, error) in
      if error != nil {
        print(error?.localizedDescription ?? "No error description available")
        return
      }
      guard let response = analyzeSyntaxResponse else {
        print("No response received")
        return
      }
      print("analyzeSyntaxResponse\(response)")
      completionHandler(response)
    }
    call.requestHeaders.setObject(NSString(string: apiKey), forKey: NSString(string: "X-Goog-Api-Key"))
    // if the API key has a bundle ID restriction, specify the bundle ID like this
    self.call.requestHeaders.setObject(NSString(string:Bundle.main.bundleIdentifier!), forKey:NSString(string:"X-Ios-Bundle-Identifier"))
    print("HEADERS:\(String(describing: call.requestHeaders))")
    call.start()
  }

  func textToCategory(text:String, completionHandler: @escaping (_ response: ClassifyTextResponse) -> Void) {
    let documet: Document = Document()
    documet.content = text
    documet.type = Document_Type.plainText

    let classifyText = ClassifyTextRequest()
    classifyText.document = documet

    call = client.rpcToClassifyText(with: classifyText) { (classifyTextResponse, error) in
      print("classifyTextResponse : \(String(describing: classifyTextResponse))")
      if error != nil {
        print(error?.localizedDescription ?? "No error description available")
        return
      }
      guard let response = classifyTextResponse else {
        print("No response received")
        return
      }
      print("classifyTextResponse\(response)")
      completionHandler(response)
    }
    call.requestHeaders.setObject(NSString(string: apiKey), forKey: NSString(string: "X-Goog-Api-Key"))
    // if the API key has a bundle ID restriction, specify the bundle ID like this
    call.requestHeaders.setObject(NSString(string:Bundle.main.bundleIdentifier!), forKey:NSString(string:"X-Ios-Bundle-Identifier"))
    print("HEADERS:\(String(describing: call.requestHeaders))")
    call.start()
  }
}
