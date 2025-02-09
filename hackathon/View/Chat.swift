import SwiftUI

struct Chat: View {
    var body: some View {
        VStack {
            Text("Chat View")
                .font(.largeTitle)
                .padding()

            Text("Start chatting with others here.")
                .font(.body)
                .padding()
        }
        .navigationTitle("Chat")
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat()
    }
}
