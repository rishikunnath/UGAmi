import SwiftUI
import Foundation
import FirebaseFirestore

final class UserManager {
    private let db = Firestore.firestore()
    
    func createNewUser(auth: AuthDataResultModel, firstName: String, lastName: String, email: String) async throws {
        let userRef = db.collection("Users").document(auth.uid)

        let userDetails: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "user_id": auth.uid
        ]

        do {
            try await userRef.setData(userDetails)

            try await userRef.collection("Friends").document("List").setData([
                "friends": [] 
            ])
            
            print("User created successfully in Firestore")
        } catch {
            print("Error storing user data: \(error.localizedDescription)")
            throw error
        }
    }
}
