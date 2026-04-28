import Foundation

struct Subject: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let code: String
    let icon: String
    let color: String
    var progress: Double
    let totalChapters: Int
    var completedChapters: Int
    let credits: Int
    
    static let sampleSubjects: [Subject] = [
        Subject(name: "Engineering Mathematics", code: "MA2101", icon: "function",
                color: "6366F1", progress: 0.72, totalChapters: 12, completedChapters: 9, credits: 4),
        Subject(name: "Data Structures & Algorithms", code: "CS2201", icon: "list.bullet.rectangle",
                color: "8B5CF6", progress: 0.85, totalChapters: 10, completedChapters: 9, credits: 4),
        Subject(name: "Digital Electronics", code: "EC2301", icon: "cpu",
                color: "06B6D4", progress: 0.45, totalChapters: 8, completedChapters: 4, credits: 3),
        Subject(name: "Operating Systems", code: "CS3301", icon: "gearshape.2",
                color: "F43F5E", progress: 0.60, totalChapters: 10, completedChapters: 6, credits: 4),
        Subject(name: "Computer Networks", code: "CS4401", icon: "network",
                color: "F97316", progress: 0.30, totalChapters: 8, completedChapters: 2, credits: 3),
        Subject(name: "Database Systems", code: "CS2202", icon: "cylinder",
                color: "10B981", progress: 0.55, totalChapters: 9, completedChapters: 5, credits: 3),
    ]
}
