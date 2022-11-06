import SwiftUI


// MARK: - HapticButton

/// A control that initiates an action with a haptic feedback.
///
/// You can create a haptic button the same way as a simple button.
/// The difference is that the action has a return value describing a haptic feedback.
///
///     HapticButton {
///         let success = signIn()
///
///         if success {
///             return .notification(style: .success)
///         } else {
///             return .notification(style: .error)
///         }
///     } label:  {
///         Text("Sign In")
///     }
///
/// Obviously, the feedback from the action's return value will generate a haptic feedback only after the action happens.
/// You can generate tactile feedback before the action using the ``feedback`` parameter.
///
///     HapticButton(feedback: .selectionChanged) {
///         let success = signIn()
///
///         if success {
///             return .notification(style: .success)
///         } else {
///             return .notification(style: .error)
///         }
///     } label:  {
///         Text("Sign In")
///     }
///
/// You can omit the return value if you don't need a feedback after performing the action.
///
///     HapticButton(feedback: .selectionChanged) {
///         selectItem(item)
///     } label:  {
///         ItemLabel(item)
///     }
///
/// Since it's just a button under the hood, you can also provide a semantic role, use a simple string as a label, or use custom button styles.
///
///     HapticButton("Delete Item", role: .destructive) {
///         let success = deleteItem(item)
///
///         if success {
///             return .notification(style: .success)
///         } else {
///             return .notification(style: .error)
///         }
///     }
///     .buttonStyle(.borderless)
///
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct HapticButton<Label>: View where Label: View {
    private var role: ButtonRole?
    private var feedback: Feedback?
    private var action: () -> Feedback?
    private var label: () -> Label
    
    /// Creates a button with a specified role and haptic feedback that displays a custom label.
    ///
    /// - Parameters:
    ///   - role: An optional semantic role that describes the button. A value of `nil` means that the button doesn't have an assigned role.
    ///   - feedback: An optional haptic feedback that will occur before the action. A value of `nil` means that the button doesn't have a feedback before the action.
    ///   - action: The action to perform when the user interacts with the button. The action should return an optional feedback that will occur after the action. A return value of `nil` means that the button doesn't have a feedback after the action.
    ///   - label: A view that describes the purpose of the button's `action`.
    public init(role: ButtonRole? = nil, feedback: Feedback? = nil, action: @escaping () -> Feedback?, @ViewBuilder label: @escaping () -> Label) {
        self.role = role
        self.feedback = feedback
        self.action = action
        self.label = label
    }
    
    /// Creates a button with a specified role and haptic feedback that displays a custom label.
    ///
    /// - Parameters:
    ///   - role: An optional semantic role that describes the button. A value of `nil` means that the button doesn't have an assigned role.
    ///   - feedback: An haptic feedback that will occur before performing the action.
    ///   - action: The action to perform when the user interacts with the button.
    ///   - label: A view that describes the purpose of the button's `action`.
    public init(role: ButtonRole? = nil, feedback: Feedback, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.role = role
        self.feedback = feedback
        self.action = { action(); return nil }
        self.label = label
    }
    
    // MARK: Body
    
    public var body: some View {
        Button(role: role, action: buttonAction, label: label)
    }
    
    private func buttonAction() {
        // generate a feedback before the action
        if let feedback = feedback {
            generateFeedback(feedback)
        }
        
        // perform the action
        if let feedback = action() {
            //  and generate a feedback after the action
            generateFeedback(feedback)
        }
    }
    
    private func generateFeedback(_ feedback: Feedback) {
        #if os(iOS)
        switch feedback {
        case .selectionChanged:
            UISelectionFeedbackGenerator().selectionChanged()
        case .impact(let style):
            if let feedbackStyle = UIImpactFeedbackGenerator.FeedbackStyle(rawValue: style.rawValue) {
                UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
            }
        case .notification(let style):
            if let feedbackStyle = UINotificationFeedbackGenerator.FeedbackType(rawValue: style.rawValue) {
                UINotificationFeedbackGenerator().notificationOccurred(feedbackStyle)
            }
        }
        #endif
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension HapticButton where Label == Text {
    /// Creates a button with a specified role and haptic feedback that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the localized key similar to ``Text/init(_:tableName:bundle:comment:)``.
    /// See ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the button's localized title, that describes the purpose of the button's `action`.
    ///   - role: An optional semantic role describing the button. A value of `nil` means that the button doesn't have an assigned role.
    ///   - feedback: An optional haptic feedback that will occur before the action. A value of `nil` means that the button doesn't have a feedback before the action.
    ///   - action: The action to perform when the user interacts with the button. The action should return an optional feedback that will occur after the action. A return value of `nil` means that the button doesn't have a feedback after the action.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init(_ titleKey: LocalizedStringKey, role: ButtonRole? = nil, feedback: Feedback? = nil, action: @escaping () -> Feedback?) {
        self.role = role
        self.feedback = feedback
        self.action = action
        self.label = { Text(titleKey) }
    }
    
    /// Creates a button with a specified role and haptic feedback that generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the title similar to ``Text/init(_:)``.
    /// See ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the button's `action`.
    ///   - role: An optional semantic role describing the button. A value of `nil` means that the button doesn't have an assigned role.
    ///   - feedback: An optional haptic feedback that will occur before the action. A value of `nil` means that the button doesn't have a feedback before the action.
    ///   - action: The action to perform when the user interacts with the button. The action should return an optional feedback that will occur after the action. A return value of `nil` means that the button doesn't have a feedback after the action.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<S>(_ title: S, role: ButtonRole? = nil, feedback: Feedback? = nil, action: @escaping () -> Feedback?) where S : StringProtocol {
        self.role = role
        self.feedback = feedback
        self.action = action
        self.label = { Text(title) }
    }
    
    /// Creates a button with a specified role and haptic feedback that generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the title similar to ``Text/init(_:)``.
    /// See ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the button's localized title, that describes the purpose of the button's `action`.
    ///   - role: An optional semantic role that describes the button. A value of `nil` means that the button doesn't have an assigned role.
    ///   - feedback: An haptic feedback that will occur before performing the action.
    ///   - action: The action to perform when the user interacts with the button.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init(_ titleKey: LocalizedStringKey, role: ButtonRole? = nil, feedback: Feedback, action: @escaping () -> Void) {
        self.role = role
        self.feedback = feedback
        self.action = { action(); return nil }
        self.label = { Text(titleKey) }
    }
    
    /// Creates a button with a specified role and haptic feedback that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the localized key similar to ``Text/init(_:tableName:bundle:comment:)``.
    /// See ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the button's `action`.
    ///   - role: An optional semantic role that describes the button. A value of `nil` means that the button doesn't have an assigned role.
    ///   - feedback: An haptic feedback that will occur before performing the action.
    ///   - action: The action to perform when the user interacts with the button.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<S>(_ title: S, role: ButtonRole? = nil, feedback: Feedback, action: @escaping () -> Void) where S : StringProtocol {
        self.role = role
        self.feedback = feedback
        self.action = { action(); return nil }
        self.label = { Text(title) }
    }
}


@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension HapticButton {

    // MARK: - Feedback
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public enum Feedback {
        case selectionChanged
        case impact(style: ImpactFeedbackStyle)
        case notification(style: NotificationFeedbackStyle)
    }
    
    // MARK: - ImpactFeedbackStyle
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public enum ImpactFeedbackStyle: Int {
        case light = 0
        case medium = 1
        case heavy = 2
        case soft = 3
        case rigid = 4
    }

    // MARK: - NotificationFeedbackStyle
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public enum NotificationFeedbackStyle: Int {
        case success = 0
        case warning = 1
        case error = 2
    }
}


