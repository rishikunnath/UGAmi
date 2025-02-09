import SwiftUI

struct Home: View {
    var userID: String
    private var people: [String] = ["mario","toad","luigi","peach","daisy"]
    init(userID: String) {
        self.userID = userID
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.black
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        TabView {
            // Home View
            NavigationView {
                VStack {
                    ZStack {
                        ForEach(people, id: \.self) { person in
                            CardView(person: person)
                        }
                    }
                }
                .navigationTitle("Home")
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            NavigationView {
                Search()
                    .navigationBarBackButtonHidden(true)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }

            NavigationView {
                Chat()
                    .navigationBarBackButtonHidden(true)
            }
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                Text("Chat")
            }

            NavigationView {
                Notifications()
                    .navigationBarBackButtonHidden(true)
            }
            .tabItem {
                Image(systemName: "bell.fill")
                Text("Notifications")
            }

            NavigationView {
                Profile(userID: userID)
                    .navigationBarBackButtonHidden(true)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .accentColor(.white)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home(userID: "userID_1234")  
}
