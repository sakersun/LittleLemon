//
//  Onboarding.swift
//  LittleLemon
//
//  Created by sakersun on 2025/8/15.
//

import SwiftUI

let kFirstName = "key first name"
let kLastName = "key last name"
let kEmail = "key email"
let kIsLoggedIn = "key is logged in"
let kName = "key name"

struct Onboarding: View {
    @State private var email: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("little-lemon")
                VStack {
                    Text("Little Lemon")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.yellow).frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )

                    HStack {
                        VStack(alignment: .leading, spacing: 8) {

                            Text("Chicago")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            Text(
                                "We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist."
                            )
                            .font(.body)
                            .foregroundColor(.white)
                            .lineLimit(nil)
                        }

                        Spacer()

                        Image("restaurant-food")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(
                    Color(red: 75 / 255, green: 90 / 255, blue: 82 / 255)
                )
                Text("Name *").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(.gray)
                TextField("Name", text: $name)
                Text("Email *").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(.gray)
                TextField("Email", text: $email)

                Spacer()
                Button("Register") {
                    if name.isEmpty || email.isEmpty {
                        print("register failed")
                        return
                    }
                    if !isValidEmail(email) {
                        print("invalid email")
                        return
                    }
                    isLoggedIn = true
                    UserDefaults.standard.set(name, forKey: kName)
                    UserDefaults.standard.set(email, forKey: kEmail)
                    UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                }
            }.padding().navigationDestination(isPresented: $isLoggedIn) {
                Home()
            }.onAppear {
                if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                    isLoggedIn = true
                }
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(
            with: email
        )
    }
}

#Preview {
    Onboarding()
}
