//
//  userDashboard.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 23/09/25.
//

import SwiftUI

struct userDashboard: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var selectedTab = 0
    @Environment(\.dismiss) var dismiss
    var body: some View {
        TabView(selection: $selectedTab){
            
            
            AllProjectsView()
                .tabItem{
                    Image(systemName: "folder.badge.gearshape")
                                       Text("All Projects")
                }.tag(0)
            
            
            MyApplicationsView()
                .tabItem{
                    Image(systemName: "doc.text.fill")
                    Text("My Applications")
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

