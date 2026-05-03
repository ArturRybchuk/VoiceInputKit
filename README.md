# 🎤 VoiceInputKit (Speech-to-Text for iOS)

![Platform](https://img.shields.io/badge/platform-iOS-blue)
![Swift](https://img.shields.io/badge/Swift-5-orange)
![License](https://img.shields.io/badge/license-MIT-green)

Simple and reusable voice input (speech-to-text) for iOS using `Speech.framework`

---

## ✨ Features

- 🎙 Voice → Text (real-time)
- 🔁 Toggle recording (start / stop)
- ⏱ Auto stop after 5 seconds
- 🔐 Built-in permissions handling
- 📦 Easy to integrate in any project

---

## 📦 Installation

### Swift Package Manager

In Xcode:

```
File → Add Packages...
```

Add your repository URL:

```
https://github.com/yourname/VoiceInputKit.git
```

---

## 🔌 Usage

### 1. Import

```swift
import VoiceInputKit
```

---

### 2. Setup in ViewController

#### Step 1. Add manager

```swift
private let voiceManager = VoiceInputManager()
```

---

#### Step 2. Enable mic button

```swift
searchController.searchBar.showsBookmarkButton = true
```

---

#### Step 3. Handle mic button tap

```swift
func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    
    voiceManager.requestPermissions { [weak self] granted in
        DispatchQueue.main.async {
            
            guard let self = self else { return }
            
            if !granted {
                print("Permissions not granted")
                return
            }
            
            self.voiceManager.toggleRecording(
                onText: { text in
                    self.searchController.searchBar.text = text
                },
                onFinish: {
                    print("Recording finished")
                }
            )
        }
    }
}
```

---

## ⚠️ Permissions (IMPORTANT)

Add this to your **Info.plist**:

```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>We use speech recognition for voice search</string>

<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access for voice input</string>
```

---

## 🎨 Optional UI (Speech Indicator)

```swift
private lazy var speechIndicatorView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.systemBlue
    view.layer.cornerRadius = 10
    view.alpha = 0

    let micIcon = UIImageView(image: UIImage(systemName: "mic"))
    micIcon.tintColor = .white

    let label = UILabel()
    label.text = "EN"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 12)

    let stack = UIStackView(arrangedSubviews: [micIcon, label])
    stack.spacing = 4
    stack.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stack)

    NSLayoutConstraint.activate([
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    return view
}()
```

---

## 🧠 Notes

- Uses `Speech.framework` (not system keyboard dictation)
- Works only on **iOS**
- Requires user permissions
- Auto stops after 5 seconds (customizable)

---

## 🚀 Example Use Cases

- Search bars
- Chat input
- Forms
- Voice commands

---

## 🛠 Requirements

- iOS 13+
- Swift 5+

---

## 📄 License

MIT License
