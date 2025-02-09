import SwiftUI

struct Notifications: View {
    var body: some View {
        VStack {
            Text("Notifications View")
                .font(.largeTitle)
                .padding()

            Text("Here are your notifications.")
                .font(.body)
                .padding()
        }
        .navigationTitle("Notifications")
    }
}

struct Notifications_Previews: PreviewProvider {
    static var previews: some View {
        Notifications()
    }
}
