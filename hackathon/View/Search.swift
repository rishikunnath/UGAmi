import SwiftUI

struct Search: View {
    var body: some View {
        VStack {
            Text("Search View")
                .font(.largeTitle)
                .padding()

            Text("Search for content here.")
                .font(.body)
                .padding()
        }
        .navigationTitle("Search")
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
