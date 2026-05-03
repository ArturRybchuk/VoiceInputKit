// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "VoiceInputKit",
    
    platforms: [
        .iOS(.v13)
    ],
    
    products: [
        .library(
            name: "VoiceInputKit",
            targets: ["VoiceInputKit"]
        ),
    ],
    
    targets: [
        .target(
            name: "VoiceInputKit",
            dependencies: [],
            path: "Sources/VoiceInputKit",
            linkerSettings: [
                .linkedFramework("Speech"),
                .linkedFramework("AVFoundation")
            ]
        )
    ]
)
