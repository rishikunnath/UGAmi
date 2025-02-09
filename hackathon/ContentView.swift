import SwiftUI

struct ContentView: View {
    @State private var showSignup: Bool = false
    
    var body: some View {
        NavigationStack {
            Login()
        }
    }
}
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
