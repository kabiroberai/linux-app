# Linux iOS Sample App

A sample iOS app designed for cross-compilation on Linux.

This is a sample project from my SwiftTO talk "Beyond Xcode: Batteries Not Included".

## Slides

See [Slides.pdf](/Slides.pdf)

## Setup

Note that this has been tested on Ubuntu 22.04 for AArch64. Your mileage may vary on other Linux distros/setups.

Prerequisites:
- [ideviceinstaller](https://github.com/libimobiledevice/ideviceinstaller) (on or after [7fbc6d1](https://github.com/libimobiledevice/ideviceinstaller/commit/7fbc6d180105b798af619c7994ed271cede2559e))
- [libimobiledevice](https://github.com/libimobiledevice/libimobiledevice) CLI tools (for debugging)
- [Swift 5.9](https://swift.org/download)

1. Install my `swift-package-manager` fork
    1. Clone the repo: `git clone https://github.com/kabiroberai/swift-package-manager -b kabir/develop`.
    3. Run `swift build`.
    4. Copy the built `swift-package`, `swift-build`, `swift-run`, `swift-experimental-sdk` tools (in `.build/debug`) into your Swift 5.9 toolchain's bin directory, overwriting existing files.
2. Build and install my Darwin SDK: see the `develop` branch of <https://github.com/kabiroberai/swift-sdk-darwin>
3. Obtain signing resources from your Apple Developer account (TODO: add commands):
    1. Create a local RSA keypair and certificate signing request.
    2. Upload the CSR to <https://developer.apple.com/account> to obtain a certificate.
    3. Create `Resources/identity.p12` with the private key, certificate, as well as Apple's intermediate and root CAs.
    4. Generate a wildcard provisioning profile on Apple's member center, and save it at `Resources/embedded.mobileprovision`.
4. Done. Run `make do` and sit back :)

## LSP Support

These steps are designed for VSCode but you can adapt them to your preferred LSP-compatible IDE.

1. Set up [SourceKit-LSP](https://github.com/apple/sourcekit-lsp) for your IDE. For VSCode, this means installing the "Swift" extension.
2. Update the paths in `.vscode/settings.json` to use your home directory instead of `/home/kabiroberai`

Note that SourceKit-LSP does not officially support SwiftSDKs yet. While this repo implements a workaround, IDE experience will be sub-optimal until official support lands. See <https://github.com/apple/sourcekit-lsp/issues/786>.

## Debugging

1. Install the app on your device with `make do`.
2. Start debugserver: run `make debug` in a background terminal window. Keep this running.
3. Connect LLDB to debugserver. If you're in VSCode, just use the "Attach" configuration. Otherwise, you want something along the lines of:
```
(lldb) platform select remote-ios
(lldb) target create --no-dependents .build/debug/MyApp.app/MyApp
(lldb) process connect connect://localhost:1234
(lldb) process attach --waitfor
```
4. Launch the app on your device.
