//
//  ApplicationFormView.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 25/09/25.
//
import SwiftUI

struct ApplicationSubmissionView: View {
    let project: Project
    @StateObject private var viewModel = ApplicationViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Project Info Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Applying for:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(project.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("blue1"))
                        
                        Text("Faculty: \(project.facultyName)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("blue1").opacity(0.1))
                    )
                    
                    // Application Form
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Application Details")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        // Name Field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Full Name *")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Enter your full name", text: $viewModel.name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            if !viewModel.name.isEmpty && !viewModel.isNameValid {
                                Text("Name must be between 3-30 characters")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Email Address *")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Enter your email", text: $viewModel.email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            
                            if !viewModel.email.isEmpty && !viewModel.isEmailValid {
                                Text("Please enter a valid email address")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Phone Field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Phone Number *")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Enter your phone number", text: $viewModel.phone)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            if !viewModel.phone.isEmpty && !viewModel.isPhoneValid {
                                Text("Phone number must be at least 10 digits")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Address Field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Address *")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Enter your address", text: $viewModel.address, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(2...4)
                            
                            if !viewModel.address.isEmpty && !viewModel.isAddressValid {
                                Text("Address is required")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // CGPA Field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("CGPA *")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Enter your CGPA (4.0 - 10.0)", text: $viewModel.cgpa)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                            
                            if !viewModel.cgpa.isEmpty && !viewModel.isCGPAValid {
                                Text("CGPA must be between 4.0 and 10.0")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Cover Letter Field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Cover Letter *")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Write your cover letter...", text: $viewModel.coverLetter, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(5...10)
                            
                            if !viewModel.coverLetter.isEmpty && !viewModel.isCoverLetterValid {
                                Text("Cover letter is required")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    // Error Message
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.1))
                            )
                    }
                    
                    // Submit Button
                    Button {
                        Task {
                            await viewModel.submitApplication(for: project)
                        }
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            }
                            
                            Text(viewModel.isLoading ? "Submitting..." : "Submit Application")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            viewModel.isFormValid && !viewModel.isLoading ?
                            Color("blue1") : Color.gray
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationTitle("Apply for Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Application Submitted!", isPresented: $showingSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(viewModel.successMessage)
            }
            .onChange(of: viewModel.isSubmitted) { isSubmitted in
                if isSubmitted {
                    showingSuccessAlert = true
                }
            }
        }
    }
}
