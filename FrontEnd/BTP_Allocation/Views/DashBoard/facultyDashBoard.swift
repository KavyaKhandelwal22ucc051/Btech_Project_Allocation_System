//
//  facultyDashBoard.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 29/09/25.
//

import SwiftUI

struct facultyDashBoard: View {
    @State private var selectedTab = 0
    @StateObject var projectViewModel  = ProjectViewModel()
    @ObservedObject var viewModel: LoginViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        TabView(selection: $selectedTab ){
            
            projectApplicationView()
                .tabItem{
                    Image(systemName: "doc")
                    Text("Applications")
                }.tag(0)
            
            createProject(projectViewModel: projectViewModel)
                .tabItem{
                    Image(systemName: "folder.badge.plus")
                    Text("Create Project")
                }.tag(1)
            
            
            
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: (
            Button{
                viewModel.logout()
                dismiss()
            }label: {
                Text("Sign Out")
                    .foregroundColor(Color("blue1"))
            }
            ))
    }
}


