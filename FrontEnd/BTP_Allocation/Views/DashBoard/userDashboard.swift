//
//  userDashboard.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 23/09/25.
//

import SwiftUI

struct userDashboard: View {
//    @ObservedObject var viewModel: LoginViewModel
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab){
            
            
            AllProjectsView()
                .tabItem{
                    Image(systemName: "folder.badge.gearshape")
                                       Text("All Projects")
                }.tag(0)
            
            
            SubmittedFormView()
                .tabItem{
                    Image(systemName: "doc.text.fill")
                    Text("My Applications")
                }.tag(1)
            
            allFacultyStatusView()
                .tabItem{
                    Image(systemName: "person.3.fill")
                    Text("Faculty Status")
                }.tag(2)
            
            
        }.navigationBarBackButtonHidden(true)
            
    }
}

#Preview {
    userDashboard()
}
