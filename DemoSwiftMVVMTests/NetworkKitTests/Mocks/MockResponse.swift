import Foundation

public struct MockResponse {
    
    static var postData: Data {
        let json = """
{"message": ["affenpinscher","african","airedale","akita","appenzeller","australian","bakharwal"],"status": "success"} 
"""
        return json.data(using: .utf8)!
    }
    
    static var dummyData: Data {
        let dummyText = "dummyText"
        return dummyText.data(using: .utf8)!
    }
}
