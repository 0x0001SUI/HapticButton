# HapticButton

A control that initiates an action with a haptic feedback.

## Discussion

You can create a haptic button the same way as a simple button. The difference is that the action has a return value describing a haptic feedback.

```swift
HapticButton {
    let success = signIn()

    if success {
        return .notification(style: .success)
    } else {
        return .notification(style: .error)
    }
} label:  {
    Text("Sign In")
}
```

Obviously, the feedback from the action’s return value will trigger feedback only after the action happens. You can generate haptic feedback before the action using the `feedback` parameter.

```swift
HapticButton(feedback: .selectionChanged) {
    let success = signIn()

    if success {
        return .notification(style: .success)
    } else {
        return .notification(style: .error)
    }
} label:  {
    Text("Sign In")
}
```

You can omit the return value if you don’t need a feedback after performing the action.

```swift
HapticButton(feedback: .selectionChanged) {
    selectItem(item)
} label:  {
    ItemLabel(item)
}
```

Since it's just a button under the hood, you can also provide a semantic role, use a simple string as a label, or use custom button styles.

```swift
HapticButton("Delete Item", role: .destructive) {
    let success = deleteItem(item)

    if success {
        return .notification(style: .success)
    } else {
        return .notification(style: .error)
    }
}
.buttonStyle(.borderless)
```
