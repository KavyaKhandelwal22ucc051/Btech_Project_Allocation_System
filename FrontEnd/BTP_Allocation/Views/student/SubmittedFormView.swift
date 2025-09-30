//
//  SubmittedFormView.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 25/09/25.
//

import SwiftUI

struct MyApplicationsView: View {
    @StateObject private var applicationViewModel = ApplicationViewModel()
    @StateObject private var projectViewModel = ProjectViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if applicationViewModel.myApplications.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Applications Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Your submitted applications will appear here")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List(applicationViewModel.myApplications) { application in
                        NavigationLink(destination: ApplicationDetailView(
                            application: application,
                            project: getProject(for: application.projectId)
                        )) {
                            ApplicationRowView(
                                application: application,
                                project: getProject(for: application.projectId)
                            )
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My Applications")
            .task {
                await applicationViewModel.getMyApplications()
                await projectViewModel.fetchAllProjects()
            }
            .refreshable {
                await applicationViewModel.getMyApplications()
                await projectViewModel.fetchAllProjects()
            }
        }
    }
    
    private func getProject(for projectId: String) -> Project? {
        projectViewModel.projects.first { $0.id == projectId }
    }
}

struct ApplicationRowView: View {
    let application: Application
    let project: Project?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Project Title
            if let project = project {
                Text(project.title)
                    .font(.headline)
                    .foregroundColor(.primary)
            } else {
                Text("Project Not Found")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            // Application Info
            HStack {
                Label(application.name, systemImage: "person.fill")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label(String(format: "%.2f", application.cgpa), systemImage: "chart.bar.fill")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            // Project Details
            if let project = project {
                HStack(spacing: 16) {
                    Label(project.category, systemImage: "folder.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Label(project.country, systemImage: "location.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MyApplicationsView()
}
