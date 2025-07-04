
import SwiftUI

@main
struct SimpleLoginScreenApp: App {
    @StateObject private var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
        }
    }

}
