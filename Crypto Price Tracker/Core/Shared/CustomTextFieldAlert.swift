//
//  CustomTextFieldAlert.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//


import SwiftUI

struct CustomTextFieldAlert: View {
    @Binding var isPresented: Bool
    @Binding var text: String
    var title: String
    var onSave: (String) -> Void

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    Text(title)
                        .font(.headline)

                    TextField("Enter name", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    HStack {
                        Button("Cancel") {
                            isPresented = false
                            text = ""
                        }
                        Spacer()
                        Button("Save") {
                            onSave(text)
                            isPresented = false
                            text = ""
                        }
                        .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 10)
                .frame(maxWidth: 300)
            }
            .transition(.opacity)
        }
    }
}
