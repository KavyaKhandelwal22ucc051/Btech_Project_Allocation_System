//
//  ApproveAndDeleteView.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 30/09/25.
//

import SwiftUI

struct ApproveAndDeleteView: View {
    let application : Application

    var body: some View {
        VStack{
            Text("Application")
                .font(.system(size: 40))
                .fontWeight(.bold)
            
            VStack(spacing : 10){
                
                DetailRow(label: "Name", value: application.name)
                DetailRow(label: "CGPA", value: "\(application.cgpa)")
                DetailRow(label: "Cover Letter", value: application.coverLetter)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.gray).opacity(0.2))
            )
            
            Spacer().frame(height: 30)
            
            HStack{
                Button{
                    
                }label: {
                    Text("Approv")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("blue1"))
                        )
                }
                
                Spacer().frame(width: 30)
                
                Button{
                    
                }label: {
                    Text("Reject")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.red))
                        )
                }
            }
            
            
            Spacer()
            
        }.padding()
    }
}

#Preview {
    ApproveAndDeleteView(
        application: Application(
            id: "12345",
            name: "John Doe",
            email: "john.doe@example.com",
            coverLetter: "I am passionate about this project and believe my skills make me a strong fit.",
            phone: 9876543210,
            address: "123 Main Street, Springfield",
            applicantID: ApplicantID(user: "a1", role: "John Doe"),   // adjust fields to match your actual struct
            facultyID: FacultyID(user: "f1", role: "Prof. Smith"),   // adjust fields to match your actual struct
            projectId: "p123",
            branch: "Computer Science",
            cgpa: 8.75
        )
    )
}

