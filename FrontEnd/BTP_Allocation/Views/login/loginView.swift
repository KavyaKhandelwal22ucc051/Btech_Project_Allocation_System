//
//  loginView.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 05/09/25.
//

import SwiftUI

struct loginView: View {
    @StateObject var viewModel = LoginViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                Color.white.ignoresSafeArea()
                
                circleView()
                
                VStack(spacing: 20){
                    
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    TextField("", text: $viewModel.role,prompt: Text("Role").foregroundColor(.white))
                        .padding()
                        .foregroundColor(.white).fontWeight(.bold)
                    
                        .font(viewModel.role.isEmpty ? .caption : .headline)
                        .frame(width: 250,height: 30)
                        .overlay{
                            RoundedRectangle(cornerRadius: 6).stroke(.white,lineWidth: 2)
                        }
                    
                    
                    TextField("", text: $viewModel.email,prompt: Text("Email").foregroundColor(.white))
                        .padding()
                        .foregroundColor(.white).fontWeight(.bold)
                    
                        .font(viewModel.email.isEmpty ? .caption : .headline)
                        .frame(width: 250,height: 30)
                        .overlay{
                            RoundedRectangle(cornerRadius: 6).stroke(.white,lineWidth: 2)
                        }
                    
                    
                    SecureField("", text: $viewModel.password,prompt: Text("Password").foregroundColor(.white))
                        .padding()
                        .foregroundColor(.white).fontWeight(.bold)
                    
                        .font(viewModel.password.isEmpty ? .caption : .headline)
                        .frame(width: 250,height: 30)
                        .overlay{
                            RoundedRectangle(cornerRadius: 6).stroke(.white,lineWidth: 2)
                        }
                    
                    
                    Button{
                        Task{
                            await viewModel.loginFuntion()
                        }
                    }label: {
                        Text("Login")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("blue1"))
                            .frame(width: 250,height: 35)
                            .background(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                            
                    }
                    
                    NavigationLink(destination: userDashboard(), isActive: $viewModel.isLoggedIn){
                        EmptyView()
                    }
                    
                    Button{
                         
                    }label: {
                        Text("Register New User!")
                            .font(.callout)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    
                   
                        
                }.padding(.horizontal, 40)
                    .padding(.top, 250)
            }
        }
    }
}

#Preview {
    loginView()
}
