import SwiftUI
import ConfettiSwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var counter = 0

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Button("Hello, SwiftTO!") {
                counter += 1
            }
        }
        .padding()
        .confettiCannon(counter: $counter)
    }
}
