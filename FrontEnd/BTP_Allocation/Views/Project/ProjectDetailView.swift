//
//  ProjectDetailView.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 25/09/25.
//
// MARK: - Project Detail View
import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    @Environment(\.dismiss) private var dismiss
    @State private var showingApplicationForm = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text(project.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text(project.category)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color("blue1").opacity(0.2))
                                .foregroundColor(Color("blue1"))
                                .clipShape(Capsule())
                            
                            Spacer()
                            
                            Text("CGPA: \(String(format: "%.1f", project.cgpa))")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                        }
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(project.description)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    
                    // Details Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                        DetailCard(icon: "person.fill", title: "Faculty", value: project.facultyName)
                        DetailCard(icon: "building.2.fill", title: "Department", value: project.facultyDepartment)
                        DetailCard(icon: "location.fill", title: "Location", value: project.country)
                        DetailCard(icon: "clock.fill", title: "Duration", value: "\(project.duration)")
                    }
                    
                    // Salary Information
                    if let salaryFrom = project.salaryFrom, let salaryTo = project.salaryTo {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Stipend Range")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("₹\(salaryFrom) - ₹\(salaryTo)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green.opacity(0.1))
                        )
                    }
                    
                    // Apply Button
                    Button {
                        showingApplicationForm = true
                    } label: {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Apply for this Project")
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("blue1"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingApplicationForm) {
                            ApplicationSubmissionView(project: project)
                        }
        }
    }
}


// MARK: - Detail Card Helper View
struct DetailCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color("blue1"))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 1)
        )
    }
}

