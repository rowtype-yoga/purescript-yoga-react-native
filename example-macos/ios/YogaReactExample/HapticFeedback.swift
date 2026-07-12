import UIKit

@objc(HapticFeedback)
final class HapticFeedback: NSObject {
  @objc static func requiresMainQueueSetup() -> Bool {
    true
  }

  @objc func selectionChanged() {
    runOnMain {
      let generator = UISelectionFeedbackGenerator()
      generator.prepare()
      generator.selectionChanged()
    }
  }

  @objc func impact(_ style: String) {
    runOnMain {
      let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
      switch style {
      case "heavy": feedbackStyle = .heavy
      case "medium": feedbackStyle = .medium
      default: feedbackStyle = .light
      }
      let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
      generator.prepare()
      generator.impactOccurred()
    }
  }

  @objc func notification(_ type: String) {
    runOnMain {
      let feedbackType: UINotificationFeedbackGenerator.FeedbackType
      switch type {
      case "error": feedbackType = .error
      case "warning": feedbackType = .warning
      default: feedbackType = .success
      }
      let generator = UINotificationFeedbackGenerator()
      generator.prepare()
      generator.notificationOccurred(feedbackType)
    }
  }

  private func runOnMain(_ action: @escaping () -> Void) {
    if Thread.isMainThread {
      action()
    } else {
      DispatchQueue.main.async(execute: action)
    }
  }
}
