//
//  ProjectViewModel.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 25/09/25.
//


import Foundation

// MARK: - Project Model
struct Project: Codable, Identifiable , Hashable{
    let id: String
    let title: String
    let description: String
    let category: String
    let country: String
    let duration: Int                    // Changed to Int (months)
    let cgpa: Double
    let salaryFrom: Int?
    let salaryTo: Int?
    let postedBy: String
    let facultyName: String
    let facultyDepartment: String
    let projectPostedOn: String          // Changed from createdAt
    let expired: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case category
        case country
        case duration
        case cgpa
        case salaryFrom
        case salaryTo
        case postedBy
        case facultyName
        case facultyDepartment
        case projectPostedOn
        case expired
    }
}

// MARK: - API Response Models
struct ProjectsResponse: Codable {
    let success: Bool
    let projects: [Project]
}

struct ProjectResponse : Codable {
    let success : Bool
    let message : String
    let project : Project?
}

struct MyProjectsResponse: Codable {
    let success: Bool
    let myProjects: [Project]
}

struct ErrorResponse: Codable {
    let success: Bool
    let message: String
}

// MARK: - ProjectViewModel
@MainActor
class ProjectViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var filteredProjects: [Project] = []
    @Published var myProjects : [Project] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var searchText = ""
    @Published var selectedCategory = "All"
    @Published var selectedCountry = "All"
    @Published var minCGPA: Double = 0.0
    @Published var maxCGPA: Double = 10.0
    @Published var successMessage = ""
    
    @Published var title = ""
    @Published var description = ""
    @Published var country = ""
    @Published var category = ""

    @Published var duration = ""
    @Published var cgpa = ""
    @Published var salaryFrom = ""
    @Published var salaryTo = ""
    @Published var isProjectSubmitted = false
    
    
    var isValidtitle : Bool {
        if title.isEmpty {
            return false
        }
        return true
    }
    
    var isValidDescription : Bool {
        if description.isEmpty {
            return false
        }
        return true
    }
    
    var isValidCountry : Bool {
        if country.isEmpty {
            return false
        }
        
        return true
    }
    
    var isValidCategory : Bool {
        if category.isEmpty{
            return false
        }
        
        return true
    }
    
    var isValidDuration : Bool {
        if duration.isEmpty {
            return false
        }
        
        return true
    }
    
    var isCGPAValid: Bool {
        if let cgpaValue = Double(cgpa) {
            return cgpaValue >= 4.0 && cgpaValue <= 10.0
        }
        return false
    }
    
    var isFormValid : Bool {
        isValidtitle && isCGPAValid && isValidCountry && isValidCategory && isValidDuration && isValidDescription
    }
    
    // Filter options
    let categories = ["All", "Web Development", "Mobile Development", "AI/ML", "Data Science", "IoT", "Blockchain", "Other"]
    let countries = ["All", "India", "USA", "UK", "Canada", "Germany", "Australia"]
    
    private let baseURL = "http://localhost:4000/api/v1/project/getAll" // Replace with your actual backend URL
    
    
    // MARK: - fetch all projects
    func fetchAllProjects() async {
        isLoading = true
        errorMessage = ""
        
        do {
            guard let url = URL(string: "http://localhost:4000/api/v1/project/getAll") else {
                throw ProjectError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Add authentication token if available
            if let token = UserDefaults.standard.string(forKey: "auth_token") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Debug: Print raw response
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw projects response: \(responseString)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ProjectError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    throw ProjectError.serverError(errorResponse.message)
                } else {
                    throw ProjectError.serverError("Server returned status code: \(httpResponse.statusCode)")
                }
            }
            
            let projectsResponse = try JSONDecoder().decode(ProjectsResponse.self, from: data)
            
            if projectsResponse.success {
                self.projects = projectsResponse.projects
                await filterProjects()
                print("Fetched \(self.projects.count) projects successfully")
            } else {
                self.errorMessage = "Failed to fetch projects"
            }
            
        } catch let decodingError as DecodingError {
            handleDecodingError(decodingError)
        } catch {
            if let projectError = error as? ProjectError {
                self.errorMessage = projectError.localizedDescription
            } else {
                self.errorMessage = "Failed to fetch projects: \(error.localizedDescription)"
            }
            print("Fetch projects error: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Add Project
    
    func addProject() async{
        
        guard isFormValid else{
            errorMessage = "Plese enter all the fields"
            return
        }
        
        guard let cgpaDouble = Double(cgpa) else {
            errorMessage = "Invalid CGPA value"
            return
        }
        
        guard let Doubleduration = Int(duration) else{
            errorMessage = "Invalid Duration"
            return
        }
        
        guard let DoubleSalaryto = Int(salaryTo), let DoubleSalaryFrom = Int(salaryFrom) else{
            errorMessage = "Invalid Salary"
            return
        }
        
        errorMessage = ""
        successMessage = ""
        
        do{
            guard let url = URL(string: "http://localhost:4000/api/v1/project/post")else{
                print("Invalid URL")
                return
            }
            
            
            
            var request = URLRequest(url:url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = UserDefaults.standard.string(forKey: "auth_token"){
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let payload : [String : Any] = [
                "title":title,
                "description":description,
                "category" : category,
                "country":country,
                "duration":Doubleduration,
                "cgpa":cgpaDouble,
                "salaryFrom":DoubleSalaryFrom,
                "salaryTo":DoubleSalaryto
            ]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
            
            let (data,response) = try await URLSession.shared.data(for: request)
            
            guard let httpresponse = response as? HTTPURLResponse else{
                print("error")
                return
            }
            
            
            if httpresponse.statusCode == 200{
                let projectResponse = try JSONDecoder().decode(ProjectResponse.self, from: data)
                
                if projectResponse.success {
                    isProjectSubmitted = true
                    successMessage = projectResponse.message
                    clearProjectFrom()
                }else{
                    errorMessage = projectResponse.message
                }
            }else{
                if let errorResponse = try? JSONDecoder().decode(ProjectResponse.self, from: data){
                    errorMessage = errorResponse.message
                }else{
                    errorMessage = "Server error \(httpresponse.statusCode)"
                }
            }
            
        }catch{
            print("error")
        }
        
    }
    
    func filterProjects() async {
        var filtered = projects
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { project in
                project.title.localizedCaseInsensitiveContains(searchText) ||
                project.description.localizedCaseInsensitiveContains(searchText) ||
                project.facultyName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by category
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Filter by country
        if selectedCountry != "All" {
            filtered = filtered.filter { $0.country == selectedCountry }
        }
        
        // Filter by CGPA range
        filtered = filtered.filter { project in
            project.cgpa >= minCGPA && project.cgpa <= maxCGPA
        }
        
        // Filter out expired projects
        filtered = filtered.filter { !$0.expired }
        
        self.filteredProjects = filtered
    }
    
    func refreshProjects() async {
        await fetchAllProjects()
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = "All"
        selectedCountry = "All"
        minCGPA = 0.0
        maxCGPA = 10.0
        
        Task {
            await filterProjects()
        }
    }
    
    //MARK: - fetch My projects
    
    func fetchMyProjects() async {
        errorMessage = ""
        
        do{
            guard let url = URL(string: "http://localhost:4000/api/v1/project/myprojects")else{
                print("Invalid URL")
                return
            }
            
            var request  = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let token = UserDefaults.standard.string(forKey: "auth_token")else{
                errorMessage = "Authentication required. Please log in."
                return
            }
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (data,response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else{
                print("http response error")
                return
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                print("error in status code")
                return
            }
           
            let projectResponse = try JSONDecoder().decode(MyProjectsResponse.self, from: data)
            
            self.myProjects = projectResponse.myProjects
            
        }catch{
            print("error in try")
        }
    }
    
    // MARK: - Clear from
    
    func clearProjectFrom() {
        title = ""
        description = ""
        country = ""
        category = ""
        cgpa = ""
        salaryTo = ""
        salaryFrom = ""
        duration = ""
        errorMessage = ""
        successMessage = ""
    }
    
    func getSingleProject(id: String) async -> Project? {
        do {
            guard let url = URL(string: "\(baseURL)/api/v1/project/\(id)") else {
                throw ProjectError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = UserDefaults.standard.string(forKey: "auth_token") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ProjectError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw ProjectError.serverError("Failed to fetch project details")
            }
            
            let projectResponse = try JSONDecoder().decode(SingleProjectResponse.self, from: data)
            return projectResponse.project
            
        } catch {
            print("Error fetching single project: \(error)")
            return nil
        }
    }
    
    private func handleDecodingError(_ error: DecodingError) {
        switch error {
        case .keyNotFound(let key, let context):
            self.errorMessage = "Missing key: \(key.stringValue). Context: \(context.debugDescription)"
        case .typeMismatch(let type, let context):
            self.errorMessage = "Type mismatch for type: \(type). Context: \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            self.errorMessage = "Value not found for type: \(type). Context: \(context.debugDescription)"
        case .dataCorrupted(let context):
            self.errorMessage = "Data corrupted. Context: \(context.debugDescription)"
        @unknown default:
            self.errorMessage = "Unknown decoding error: \(error.localizedDescription)"
        }
        print("Decoding error: \(error)")
    }
}

// MARK: - Single Project Response
struct SingleProjectResponse: Codable {
    let success: Bool
    let project: Project
}

// MARK: - Project Errors
enum ProjectError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid server URL"
        case .invalidResponse:
            return "Invalid server response"
        case .serverError(let message):
            return message
        }
    }
}
