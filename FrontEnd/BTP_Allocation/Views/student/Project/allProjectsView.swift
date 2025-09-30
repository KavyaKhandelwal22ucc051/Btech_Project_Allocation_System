//
//  allProjectsView.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 25/09/25.
//

import SwiftUI

struct AllProjectsView: View {
    @StateObject private var projectViewModel = ProjectViewModel()

    @State private var selectedProject: Project?
    @State private var showingProjectDetail = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Header with search and filters
                VStack(spacing: 15) {
                    HStack {
                        Text("All Projects")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await projectViewModel.refreshProjects()
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                                .foregroundColor(Color("blue1"))
                        }
                    }
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search projects, faculty...", text: $projectViewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: projectViewModel.searchText) { _ in
                                Task {
                                    await projectViewModel.fetchAllProjects()
                                }
                            }
                        
                    }
                    
                    // Quick stats
                    HStack {
                        Text("\(projectViewModel.filteredProjects.count) Projects")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        
                    }
                }
                .padding()
                
                // Loading State
                if projectViewModel.isLoading {
                    Spacer()
                    ProgressView("Loading projects...")
                        .scaleEffect(1.2)
                    Spacer()
                }
                // Error State
                else if !projectViewModel.errorMessage.isEmpty {
                    Spacer()
                    VStack(spacing: 15) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        
                        Text("Error")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(projectViewModel.errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button("Try Again") {
                            Task {
                                await projectViewModel.fetchAllProjects()
                            }
                        }
                        .padding()
                        .background(Color("blue1"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding()
                    Spacer()
                }
                // Projects List
                else if projectViewModel.filteredProjects.isEmpty && !projectViewModel.isLoading {
                    Spacer()
                    VStack(spacing: 15) {
                        Image(systemName: "folder")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        
                        Text("No Projects Found")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("Try adjusting your filters or search terms")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    // Projects ScrollView
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(projectViewModel.filteredProjects) { project in
                                ProjectCardView(project: project) {
                                    selectedProject = project
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        showingProjectDetail = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .background(Color.gray.opacity(0.1))
            .navigationBarHidden(true)
            
            .sheet(isPresented: $showingProjectDetail) {
                if let project = selectedProject {
                    ProjectDetailView(project: project)
                }
            }
            .onChange(of: showingProjectDetail) { isShowing in
                if !isShowing {
                    selectedProject = nil
                }
            }
            .task {
                await projectViewModel.fetchAllProjects()
            }
        }
    }
}

// MARK: - Project Card View
struct ProjectCardView: View {
    let project: Project
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Text(project.category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color("blue1").opacity(0.2))
                        .foregroundColor(Color("blue1"))
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("CGPA: \(String(format: "%.1f", project.cgpa))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    
                    Text(project.country)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Description
            Text(project.description)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(3)
            
            // Faculty Info
            HStack {
                Label(project.facultyName, systemImage: "person.fill")
                    .font(.caption)
                    .foregroundColor(Color("blue1"))
                
                Spacer()
                
                Text(project.facultyDepartment)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Duration and Salary
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text("\(project.duration)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.purple)
                
                Spacer()
                
                if let salaryFrom = project.salaryFrom, let salaryTo = project.salaryTo {
                    Text("₹\(salaryFrom) - ₹\(salaryTo)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                } else {
                    Text("Stipend: TBD")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Action Button
            Button {
                onTap()
            } label: {
                Text("View Details")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color("blue1"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        )
    }
}


#Preview {
    AllProjectsView()
}
