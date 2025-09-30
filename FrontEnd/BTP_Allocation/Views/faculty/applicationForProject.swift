//
//  applicationForProject.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 29/09/25.
//
import SwiftUI

struct applicationForProject: View {
    @ObservedObject var projectViewModel: ProjectViewModel
    
    var body: some View {
        NavigationStack {
            List(projectViewModel.myProjects, id: \.self) { project in
                NavigationLink {
                    projectApplicationView()
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(project.title)
                            .font(.headline)
                        Text(project.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("My Projects")
            .onAppear {
                Task {
                    await projectViewModel.fetchMyProjects()
                }
            }
        }
    }
}

#Preview {
    // Create a mock ProjectViewModel with sample data
    let viewwModel = ProjectViewModel()
    
    // Create sample projects
    viewwModel.myProjects = [
        Project(
            id: "1",
            title: "AI-Powered Chat Application",
            description: "Develop an AI chatbot using machine learning",
            category: "AI/ML",
            country: "USA",
            duration: 6,
            cgpa: 8.5,
            salaryFrom: 50000,
            salaryTo: 70000,
            postedBy: "hello",
            facultyName: "faculty1",
            facultyDepartment: "Dr. John Smith", projectPostedOn: "hello",
            expired: false
            
        ),
        Project(
            id: "2",
            title: "E-commerce Mobile App",
            description: "Build a full-featured shopping app",
            category: "Mobile Development",
            country: "India",
            duration: 4,
            cgpa: 7.0,
            salaryFrom: 30000,
            salaryTo: 45000,
            postedBy:"hello",
            facultyName: "faculty2",
            facultyDepartment: "Dr. Sarah Johnson",
            projectPostedOn: "Information Technology", expired: false
           
        ),
        Project(
            id: "3",
            title: "Blockchain Supply Chain",
            description: "Implement blockchain for supply chain tracking",
            category: "Blockchain",
            country: "Canada",
            duration: 8,
            cgpa: 9.0,
            salaryFrom: 60000,
            salaryTo: 80000,
            postedBy: "hello",
            facultyName: "faculty3",
            facultyDepartment: "Prof. Michael Chen",
            projectPostedOn: "Blockchain Technology", expired: false
            
        )
    ]
    
     return applicationForProject(projectViewModel: viewwModel)
}
