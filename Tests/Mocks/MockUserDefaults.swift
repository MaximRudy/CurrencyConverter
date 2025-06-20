import Foundation

class MockUserDefaults: UserDefaults {
    var mockData: [String: Any] = [:]
    var setDataCalled = false
    
    override func data(forKey defaultName: String) -> Data? {
        return mockData[defaultName] as? Data
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        mockData[defaultName] = value
        if value is Data {
            setDataCalled = true
        }
    }
    
    override func removeObject(forKey defaultName: String) {
        mockData.removeValue(forKey: defaultName)
    }
}
