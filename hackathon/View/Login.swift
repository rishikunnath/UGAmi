import SwiftUI
import FirebaseAuth

struct Login: View {
    @State private var showSignup = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    @State private var userID: String? = nil
    @State private var isLoggedIn = false
    
    init() {

        if let currentUser = Auth.auth().currentUser {
            _isLoggedIn = State(initialValue: true)
            _userID = State(initialValue: currentUser.uid)
        }
    }

    func signIn() {
        guard !emailID.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            showAlert = true
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.signInUser(email: emailID, password: password)
                print("Login Successful")

                DispatchQueue.main.async {
                    self.userID = returnedUserData.uid
                    self.isLoggedIn = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Incorrect email or password"
                    self.showAlert = true
                }
                print("Error: \(error)")
            }
        }
    }
    
    func signUp() {
        guard !firstName.isEmpty, !lastName.isEmpty, !emailID.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required."
            showAlert = true
            return
        }
        
        Task {
            do {
                let newUser = try await AuthenticationManager.shared.createUser(email: emailID, password: password)

                try await UserManager().createNewUser(auth: newUser, firstName: firstName, lastName: lastName, email: emailID)
                
                print("Sign Up Successful & User Data Stored")

                DispatchQueue.main.async {
                    self.userID = newUser.uid
                    self.isLoggedIn = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Sign Up failed. Please try again."
                    self.showAlert = true
                }
                print("Error: \(error)")
            }
        }
    }
    var body: some View {
        if isLoggedIn {
            Home(userID: userID ?? "")
        } else {
            NavigationStack {
                ZStack {
                    VStack(alignment: .leading, spacing: 15) {
                        Spacer(minLength: 0)
                        
                        Text(showSignup ? "Sign Up" : "Login")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        VStack(spacing: 25) {
                            if showSignup {
                                CustomTF(sfIcon: "person", hint: "First Name", value: $firstName)
                                CustomTF(sfIcon: "person", hint: "Last Name", value: $lastName)
                            }
                            
                            CustomTF(sfIcon: "at", hint: "Email ID", value: $emailID)
                            CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                                .padding(.top, 5)
                            
                            if !showSignup {
                                Button("Forgot Password") {}
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .padding(.top, 20)
                                    .padding(.bottom, 10)
                            }
                            
                            GradientButton(title: showSignup ? "Sign Up" : "Login", icon: "arrow.right") {
                                showSignup ? signUp() : signIn()
                            }
                            .disabled((showSignup && (firstName.isEmpty || lastName.isEmpty || emailID.isEmpty || password.isEmpty)) ||
                                      (!showSignup && (emailID.isEmpty || password.isEmpty)))
                        }
                        .padding(.top, 20)
                        
                        Spacer(minLength: 0)
                        
                        HStack(spacing: 6) {
                            Text(showSignup ? "Already have an account? " : "Don't have an account? ")
                                .foregroundStyle(.gray)
                            Button(showSignup ? "Login" : "Sign Up") {
                                withAnimation(.smooth(duration: 0.45, extraBounce: 0)) {
                                    showSignup.toggle()
                                }
                            }
                            .fontWeight(.bold)
                        }
                        .font(.callout)
                        .hSpacing()
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 25)
                    .toolbar(.hidden, for: .navigationBar)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }

                    CircleView(showSignup: showSignup)
                }
            }
        }
    }
    
    @ViewBuilder
    func CircleView(showSignup: Bool) -> some View {
        Circle()
            .fill(.linearGradient(colors: [.red], startPoint: .top, endPoint: .bottom))
            .frame(width: 200, height: 200, alignment: .center)
            .offset(x: showSignup ? 90 : -90, y: -90)
            .hSpacing(showSignup ? .trailing : .leading)
            .vSpacing(.top)
            .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSignup)
    }
}

#Preview {
    Login()
}
