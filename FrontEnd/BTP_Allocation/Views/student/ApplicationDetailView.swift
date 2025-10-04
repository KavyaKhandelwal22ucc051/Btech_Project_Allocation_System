//
//  ApplicationDetailView.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 30/09/25.
//

import SwiftUI


struct ApplicationDetailView: View {
    let application: Application
    let project: Project?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Project Information
                if let project = project {
                    GroupBox(label: Label("Project Details", systemImage: "briefcase.fill")) {
                        VStack(alignment: .leading, spacing: 12) {
                            DetailRow(label: "Title", value: project.title)
                            DetailRow(label: "Category", value: project.category)
                            DetailRow(label: "Country", value: project.country)
                            DetailRow(label: "Duration", value: "\(project.duration) months")
                            DetailRow(label: "Required CGPA", value: String(format: "%.2f", project.cgpa))
                            
                            if let salaryFrom = project.salaryFrom, let salaryTo = project.salaryTo {
                                DetailRow(label: "Salary", value: "₹\(salaryFrom) - ₹\(salaryTo)")
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Description")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(project.description)
                                    .font(.body)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Applicant Information
                GroupBox(label: Label("Your Information", systemImage: "person.text.rectangle.fill")) {
                    VStack(alignment: .leading, spacing: 12) {
                        DetailRow(label: "Name", value: application.name)
                        DetailRow(label: "Email", value: application.email)
                        DetailRow(label: "Phone", value: String(application.phone))
                        DetailRow(label: "CGPA", value: String(format: "%.2f", application.cgpa))
                        DetailRow(label: "Branch", value: application.branch)
                        DetailRow(label: "Address", value: application.address)
                        DetailRow(label: "Status", value: application.status)
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Cover Letter")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(application.coverLetter)
                                .font(.body)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Faculty Information
                if let project = project {
                    GroupBox(label: Label("Faculty Information", systemImage: "person.badge.key.fill")) {
                        VStack(alignment: .leading, spacing: 12) {
                            DetailRow(label: "Name", value: project.facultyName)
                            DetailRow(label: "Department", value: project.facultyDepartment)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Application Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


