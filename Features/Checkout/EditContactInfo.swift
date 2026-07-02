//
//  EditContactInfo.swift
//  Checkout
//
//  Created by Derrick Deese on 4/22/26.
//

import SwiftUI

struct EditContactInfo: View {
    @Environment(\.dismiss) private var dismiss
    @State private var emailAddress = ""
    @State private var phoneNumber = ""
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case email, phone
    }

    var body: some View {

        NavigationStack {
            Form {

                Section(header: Text("Required Fields*")
                    .font(.callout)
                    .foregroundColor(.secondary)
                ) {
                    TextField("Email*", text: $emailAddress)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .phone }

                    TextField("Phone Number*", text: $phoneNumber)
                        .autocorrectionDisabled()
                        .keyboardType(.phonePad)
                        .focused($focusedField, equals: .phone)
                        .submitLabel(.done)
                }

            }
            .navigationTitle("Contact Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Back", systemImage: "xmark") { dismiss() }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Save and Continue")
                    {}
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.glassProminent)
                    .tint(.accent)
                    .padding(8)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusedField = .email
            }
        }
    }
}

#Preview {
    EditContactInfo()
}
