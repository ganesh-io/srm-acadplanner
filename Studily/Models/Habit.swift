import Foundation

struct Habit: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let icon: String
    let color: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), name: String, icon: String, color: String, isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.isCompleted = isCompleted
    }
    
    static let defaultHabits: [Habit] = [
        Habit(name: "Morning Revision", icon: "sun.max.fill", color: "FBBF24"),
        Habit(name: "Solve Problems", icon: "pencil.and.outline", color: "6366F1"),
        Habit(name: "Read Textbook", icon: "book.fill", color: "8B5CF6"),
        Habit(name: "Watch Lectures", icon: "play.rectangle.fill", color: "06B6D4"),
        Habit(name: "Practice Coding", icon: "chevron.left.forwardslash.chevron.right", color: "10B981"),
        Habit(name: "Review Notes", icon: "note.text", color: "F43F5E"),
        Habit(name: "Mock Test", icon: "checkmark.seal.fill", color: "F97316"),
        Habit(name: "Sleep 7+ Hours", icon: "moon.fill", color: "818CF8"),
    ]
}
