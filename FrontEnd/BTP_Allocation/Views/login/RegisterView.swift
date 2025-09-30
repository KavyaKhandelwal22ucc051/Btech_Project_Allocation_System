//
//  RegisterView.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 29/09/25.
//
import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = LoginViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingLogin = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("blue1").ignoresSafeArea()
                
                
                    VStack(spacing: 20) {
                        Spacer()
                        HeaderSection()
                        FormSection(viewModel: viewModel)
                        ActionSection(viewModel: viewModel, showingLogin: $showingLogin)
                        
                        Button{
                            dismiss()
                        }label: {
                            Text("Already Have an account ? Login")
                                .font(.callout)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                }
            
            if viewModel.role == "student" {
                NavigationLink(destination: userDashboard(viewModel: viewModel), isActive: $viewModel.isLoggedIn) {
                    EmptyView()
                }
            } else {
                NavigationLink(destination: facultyDashBoard(viewModel: viewModel), isActive: $viewModel.isLoggedIn) {
                    EmptyView()
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingLogin) {
            loginView()
        }
        .onChange(of: viewModel.isRegistrationSuccessful) { success in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    viewModel.clearRegistrationForm()
                }
            }
        }
    }
}

// MARK: - Header Section
struct HeaderSection: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Create Account")
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.bold)
            
        }
        .padding(.top, 60)
    }
}

// MARK: - Form Section
struct FormSection: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            
                CustomTextField(text: $viewModel.name, placeholder: "Full Name")
                CustomTextField(text: $viewModel.email, placeholder: "LNMIIT Email", keyboardType: .emailAddress)
                CustomTextField(text: $viewModel.phoneNumber, placeholder: "Phone Number", keyboardType: .phonePad)
            RoleSelectionView(selectedRole: $viewModel.role, roles: viewModel.roles)
            BranchSelectionView(selectedBranch: $viewModel.branch, branches: viewModel.availableBranches)
            
           
                CustomSecureField(text: $viewModel.password, placeholder: "Password")
                CustomSecureField(text: $viewModel.confirmPassword, placeholder: "Confirm Password")
                PasswordMatchIndicator(password: viewModel.password, confirmPassword: viewModel.confirmPassword)
                MessageSection(viewModel: viewModel)
            
        }
    }
}

struct RoleSelectionView: View {
    @Binding var selectedRole: String
    let roles: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Role")
                .foregroundColor(.white)
                .font(.caption)
                .fontWeight(.bold)
            
            HStack(spacing: 15) {
                ForEach(roles, id: \.self) { role in
                    Button {
                        selectedRole = role
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: selectedRole == role ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(.white)
                            Text(role.capitalized)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedRole == role ? Color.white.opacity(0.2) : Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.white, lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
        .frame(width: 280)
    }
}

struct BranchSelectionView: View {
    @Binding var selectedBranch: String
    let branches: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Branch")
                .foregroundColor(.white)
                .font(.caption)
                .fontWeight(.semibold)
            
            Menu {
                ForEach(branches, id: \.self) { branch in
                    Button(branch) {
                        selectedBranch = branch
                    }
                }
            } label: {
                HStack {
                    Text(selectedBranch.isEmpty ? "Choose Branch" : selectedBranch)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .padding()
                .frame(width: 280, height: 30)
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.white, lineWidth: 2)
                }
            }
        }
    }
}

// MARK: - Action Section
struct ActionSection: View {
    @ObservedObject var viewModel: LoginViewModel
    @Binding var showingLogin: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            
                RegisterButton(viewModel: viewModel)
               
            
        }
    }
}

// MARK: - Custom Components

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.white))
            .padding()
            .foregroundColor(.white)
            .fontWeight(.bold)
            .font(text.isEmpty ? .caption : .headline)
            .frame(width: 280, height: 30)
            .keyboardType(keyboardType)
            .autocapitalization(keyboardType == .emailAddress ? .none : .words)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.white, lineWidth: 2)
            }
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.white))
            .padding()
            .foregroundColor(.white)
            .fontWeight(.bold)
            .font(text.isEmpty ? .caption : .headline)
            .frame(width: 280, height: 30)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.white, lineWidth: 2)
            }
    }
}




struct PasswordMatchIndicator: View {
    let password: String
    let confirmPassword: String
    
    var body: some View {
        Group {
            if !password.isEmpty && !confirmPassword.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(password == confirmPassword ? .green : .red)
                        .font(.caption)
                    
                    Text(password == confirmPassword ? "Passwords match" : "Passwords don't match")
                        .foregroundColor(password == confirmPassword ? .green : .red)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .frame(width: 280, alignment: .leading)
            }
        }
    }
}

struct MessageSection: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                    .frame(width: 280)
            }
            
            if viewModel.isRegistrationSuccessful {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                    
                    Text(viewModel.registrationMessage)
                        .foregroundColor(.green)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 1)
                        )
                )
                .frame(width: 280)
            }
        }
    }
}

struct RegisterButton: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        Button {
            Task {
                await viewModel.register()
            }
        } label: {
            HStack {
               
                    Image(systemName: "person.badge.plus")
                        .font(.subheadline)
                
                
        
            }
            .fontWeight(.semibold)
            .foregroundColor(Color("blue1"))
            .frame(width: 280, height: 35)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        
    }
    
    private func isFormValid() -> Bool {
        return !viewModel.name.isEmpty &&
               !viewModel.email.isEmpty &&
               !viewModel.phoneNumber.isEmpty &&
               !viewModel.branch.isEmpty &&
               !viewModel.password.isEmpty &&
               !viewModel.confirmPassword.isEmpty &&
               viewModel.password == viewModel.confirmPassword &&
               viewModel.password.count >= 6 &&
               viewModel.phoneNumber.count == 10
    }
}




#Preview {
    RegisterView()
}
