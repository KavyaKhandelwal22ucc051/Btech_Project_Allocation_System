//
//  createProject.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 29/09/25.
//
import SwiftUI

struct createProject: View {
    @ObservedObject var projectViewModel: ProjectViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                VStack(alignment: .leading) {
                    Text("Project Title")
                    
                    TextField("Enter Project Title", text: $projectViewModel.title)
                        .textFieldStyle(.roundedBorder)
                    
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Description")
                    
                    TextField("Enter Project Description", text: $projectViewModel.description)
                        .textFieldStyle(.roundedBorder)
                    
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Category")
                    
                    Menu {
                        ForEach(projectViewModel.categories, id: \.self) { branch in
                            Button(branch) {
                                projectViewModel.category = branch
                            }
                        }
                    } label: {
                        HStack {
                            Text(projectViewModel.category.isEmpty ? "Choose Category" : projectViewModel.category)
                                .foregroundColor(projectViewModel.category.isEmpty ? .gray.opacity(0.7) : .black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                        .frame(height: 35)
                        .overlay {
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color(.gray).opacity(0.1), lineWidth: 2)
                        }
                    }
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Country")
                    
                    Menu {
                        ForEach(projectViewModel.countries, id: \.self) { country in
                            Button(country) {
                                projectViewModel.country = country
                            }
                        }
                    } label: {
                        HStack {
                            Text(projectViewModel.country.isEmpty ? "Choose Country" : projectViewModel.country)
                                .foregroundColor(projectViewModel.country.isEmpty ? .gray.opacity(0.7) : .black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                        .frame(height: 35)
                        .overlay {
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color(.gray).opacity(0.1), lineWidth: 2)
                        }
                    }
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Duration ( In Months)")
                    
                    TextField("Enter Duration", text: $projectViewModel.duration)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("CGPA")
                    
                    TextField("Enter CGPA", text: $projectViewModel.cgpa)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Salary From")
                    
                    TextField("Enter Starting Salary", text: $projectViewModel.salaryFrom)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Salary To")
                    
                    TextField("Enter Maximum Salary", text: $projectViewModel.salaryTo)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    
                }.padding()
                
                Button {
                    Task {
                        await projectViewModel.addProject()
                    }
                } label: {
                    Text("Add Project")
                        .foregroundColor(Color.white)
                        .padding()
                        .fontWeight(.bold)
                        .background(Color("blue1"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .navigationTitle("Add Project")
        .navigationBarTitleDisplayMode(.inline)
       
    }
}

#Preview {
    NavigationStack {
        createProject(projectViewModel: ProjectViewModel())
    }
}
