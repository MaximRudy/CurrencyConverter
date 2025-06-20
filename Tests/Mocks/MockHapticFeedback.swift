import UIKit
@testable import CurrencyConverter

class MockHapticFeedback: HapticFeedbackProtocol {
    var impactCalled = false
    var notificationCalled = false
    var lastImpactStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    var lastNotificationType: UINotificationFeedbackGenerator.FeedbackType?
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        impactCalled = true
        lastImpactStyle = style
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationCalled = true
        lastNotificationType = type
    }
    
    func selection() {}
}
