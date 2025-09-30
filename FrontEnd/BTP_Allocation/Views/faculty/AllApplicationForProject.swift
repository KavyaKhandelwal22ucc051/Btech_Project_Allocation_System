//
//  AllApplicationForProject.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 30/09/25.
//

import SwiftUI

struct AllApplicationForProject: View {
    let applications : [Application]
  
    var body: some View {
        List(applications,id: \.self){
            application in
            NavigationLink{
                ApproveAndDeleteView(application: application)
            }label: {
                VStack{
                    Text(application.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("CGPA : \(application.cgpa)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

