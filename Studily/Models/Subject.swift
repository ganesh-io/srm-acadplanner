import Foundation

struct Subject: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var code: String
    var icon: String
    var color: String
    var progress: Double
    var totalChapters: Int
    var completedChapters: Int
    var credits: Int
    
    static let defaultSubjects: [Subject] = [
        Subject(name: "Physics", code: "PH1101", icon: "atom",
                color: "6366F1", progress: 0.0, totalChapters: 10, completedChapters: 0, credits: 4),
        Subject(name: "Chemistry", code: "CH1101", icon: "flask.fill",
                color: "8B5CF6", progress: 0.0, totalChapters: 10, completedChapters: 0, credits: 4),
        Subject(name: "Mathematics", code: "MA1101", icon: "function",
                color: "06B6D4", progress: 0.0, totalChapters: 12, completedChapters: 0, credits: 4),
        Subject(name: "English", code: "EN1101", icon: "text.book.closed.fill",
                color: "F43F5E", progress: 0.0, totalChapters: 8, completedChapters: 0, credits: 3),
        Subject(name: "Programming", code: "CS1101", icon: "chevron.left.forwardslash.chevron.right",
                color: "10B981", progress: 0.0, totalChapters: 10, completedChapters: 0, credits: 4),
        Subject(name: "Electronics", code: "EC1101", icon: "cpu",
                color: "F97316", progress: 0.0, totalChapters: 8, completedChapters: 0, credits: 3),
    ]
}
