import SwiftUI
import FirebaseFirestore
import UIKit

struct Profile: View {
    var userID: String?  // Accept userID passed from the previous view
    @State private var userName: String = ""
    @State private var userMajor: String = ""
    @State private var userYear: String = ""
    @State private var userHobbies: String = ""
    @State private var userEmail: String = ""
    
    @State private var profileImage: Image?  // Store the profile image
    @State private var showImagePicker = false  // Toggle to show Image Picker
    @State private var selectedImage: UIImage?  // Store selected image from gallery
    
    // Track selected option
    @State private var selectedOption = "Bio"
    
    private let db = Firestore.firestore()

    // Fetch user data from Firestore using the userID
    func fetchUserData() {
        guard let userID = userID else { return }
        
        let userRef = db.collection("Users").document(userID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get user data from the Firestore document and update state
                let firstName = document.get("firstName") as? String ?? ""
                let lastName = document.get("lastName") as? String ?? ""
                userName = "\(firstName) \(lastName)"
                userMajor = document.get("major") as? String ?? ""
                userYear = document.get("year") as? String ?? ""
                userHobbies = document.get("hobbies") as? String ?? ""
                userEmail = document.get("email") as? String ?? ""
            } else {
                print("User document does not exist or error retrieving document: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // Save updated data to Firestore
    func saveUserData() {
        guard let userID = userID else { return }
        
        let userRef = db.collection("Users").document(userID)
        
        // Split userName into firstName and lastName
        let nameComponents = userName.split(separator: " ")
        let firstName = nameComponents.first.map { String($0) } ?? ""
        let lastName = nameComponents.dropFirst().joined(separator: " ") // In case there are middle names or multiple last names
        
        // Update or set fields in the "UserDetails"
        userRef.setData([
            "firstName": firstName,
            "lastName": lastName,
            "major": userMajor,
            "year": userYear,
            "hobbies": userHobbies,
            "email": userEmail
        ], merge: true) { error in
            if let error = error {
                print("Error saving data: \(error.localizedDescription)")
            } else {
                print("Data saved successfully")
            }
        }
        
        // Update the "Friends" collection with a placeholder list if needed
        let friendsRef = userRef.collection("Friends").document("List")
        friendsRef.setData([
            "friendsList": [] // Example of storing an empty list for now
        ], merge: true)
    }

    var body: some View {
        VStack {
            // Profile Picture (using placeholder for now)
            Button(action: {
                showImagePicker.toggle()  // Show Image Picker when profile picture is tapped
            }) {
                profileImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 4)) // Border around the circle
                    .shadow(radius: 10)
                    .padding()
                // Display placeholder image when no profile image is selected
                if profileImage == nil {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 4)) // Border around the circle
                        .shadow(radius: 10)
                        .padding()
                }
            }
            
            // Display User's Full Name below the profile picture
            Text(userName)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            // Options: Bio, Friends, Photos
            HStack {
                OptionButton(title: "Bio", selectedOption: $selectedOption)
                OptionButton(title: "Friends", selectedOption: $selectedOption)
                OptionButton(title: "Photos", selectedOption: $selectedOption)
            }
            .padding()

            // Display the selected option content
            if selectedOption == "Bio" {
                BioSection(userName: $userName, userMajor: $userMajor, userYear: $userYear, userHobbies: $userHobbies, userEmail: $userEmail)
            } else if selectedOption == "Friends" {
                FriendsSection()
            } else {
                PhotosSection()
            }
            
            // Save Button, only shown when "Bio" is selected
            if selectedOption == "Bio" {
                Button(action: {
                    saveUserData()
                }) {
                    Text("Save")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        .padding(.bottom, 15)
                }
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            fetchUserData()  // Fetch user data when the view appears
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage) {
                if let selectedImage = selectedImage {
                    // Update profile picture when the user selects an image
                    profileImage = Image(uiImage: selectedImage)
                    // Optionally, save this image to Firestore or Firebase Storage here
                }
            }
        }
    }
}

struct OptionButton: View {
    var title: String
    @Binding var selectedOption: String
    
    var body: some View {
        Button(action: {
            selectedOption = title
        }) {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(selectedOption == title ? .blue : .gray)
                .padding()
                .frame(maxWidth: .infinity)
                .background(selectedOption == title ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(10)
        }
        .padding(.horizontal, 5)
    }
}

struct BioSection: View {
    @Binding var userName: String
    @Binding var userMajor: String
    @Binding var userYear: String
    @Binding var userHobbies: String
    @Binding var userEmail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Major
            HStack {
                Text("Major:")
                    .fontWeight(.semibold)
                    .frame(width: 80, alignment: .leading) // Align colon to the left
                Spacer()
                TextField("Enter your major", text: $userMajor)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // Year
            HStack {
                Text("Year:")
                    .fontWeight(.semibold)
                    .frame(width: 80, alignment: .leading) // Align colon to the left
                Spacer()
                TextField("Enter your year", text: $userYear)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // Hobbies
            HStack {
                Text("Hobbies:")
                    .fontWeight(.semibold)
                    .frame(width: 80, alignment: .leading) // Align colon to the left
                Spacer()
                TextField("Enter your hobbies", text: $userHobbies)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // Email
            HStack {
                Text("Email:")
                    .fontWeight(.semibold)
                    .frame(width: 80, alignment: .leading) // Align colon to the left
                Spacer()
                TextField("Enter your email", text: $userEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .font(.body)
        .padding()
    }
}

struct FriendsSection: View {
    var body: some View {
        VStack {
            Text("No Friends Yet!")
                .font(.title)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

struct PhotosSection: View {
    var body: some View {
        VStack {
            Text("No Photos Yet!")
                .font(.title)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

struct ImagePicker: View {
    @Binding var selectedImage: UIImage?
    var onDismiss: () -> Void

    var body: some View {
        ImagePickerController(selectedImage: $selectedImage, onDismiss: onDismiss)
    }
}

struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var onDismiss: () -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImage: $selectedImage, onDismiss: onDismiss)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var selectedImage: UIImage?
        var onDismiss: () -> Void
        
        init(selectedImage: Binding<UIImage?>, onDismiss: @escaping () -> Void) {
            _selectedImage = selectedImage
            self.onDismiss = onDismiss
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                selectedImage = image
            }
            picker.dismiss(animated: true, completion: onDismiss)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: onDismiss)
        }
    }
}

#Preview {
    Profile(userID: "userID_1234")  // Example usage of the Profile view
}
