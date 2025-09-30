//
//  projectApplicationView.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 30/09/25.
//

import SwiftUI

struct projectApplicationView: View {
    @StateObject var projectViewModel = ProjectViewModel()
    @StateObject var applicationViewModel = ApplicationViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                if projectViewModel.myProjects.isEmpty {
                    VStack(alignment: .center, spacing: 20){
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 40))
                        Text("No Projects Yet")
                            .fontWeight(.bold)
                    }
                }else{
                    List(projectViewModel.myProjects , id: \.self){
                        project  in
                        NavigationLink{
                            AllApplicationForProject(applications: getAllApplicationsForAProject(for: project))
                        }label: {
                            VStack(alignment: .leading){
                                Text(project.title)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text(project.category)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }.padding()
                        }
                    }
                }
            }.navigationTitle("My Projects")
                .task {
                    await projectViewModel.fetchMyProjects()
                    await applicationViewModel.fetchAllApplications()
                }
                .refreshable {
                    await projectViewModel.fetchMyProjects()
                    await applicationViewModel.fetchAllApplications()
                }
        }
    }
    
    func getAllApplicationsForAProject(for project: Project) -> [Application] {
        applicationViewModel.getAllApplications.filter { $0.projectId == project.id }
    }
}

#Preview {
    projectApplicationView()
}
