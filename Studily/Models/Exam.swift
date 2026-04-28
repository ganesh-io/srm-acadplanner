import Foundation

struct Exam: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let subject: String
    let date: Date
    let color: String
    let icon: String
    
    var daysLeft: Int {
        DateHelper.daysLeft(to: date)
    }
    
    var isPast: Bool { daysLeft < 0 }
    
    static let sampleExams: [Exam] = [
        Exam(name: "Engineering Mathematics", subject: "MA2101",
             date: DateHelper.date(year: 2026, month: 5, day: 24),
             color: "6366F1", icon: "function"),
        Exam(name: "Data Structures & Algorithms", subject: "CS2201",
             date: DateHelper.date(year: 2026, month: 5, day: 27),
             color: "8B5CF6", icon: "list.bullet.rectangle"),
        Exam(name: "Digital Electronics", subject: "EC2301",
             date: DateHelper.date(year: 2026, month: 5, day: 30),
             color: "06B6D4", icon: "cpu"),
        Exam(name: "Operating Systems", subject: "CS3301",
             date: DateHelper.date(year: 2026, month: 6, day: 2),
             color: "F43F5E", icon: "gearshape.2"),
        Exam(name: "Computer Networks", subject: "CS4401",
             date: DateHelper.date(year: 2026, month: 6, day: 5),
             color: "F97316", icon: "network"),
        Exam(name: "Database Systems", subject: "CS2202",
             date: DateHelper.date(year: 2026, month: 6, day: 8),
             color: "10B981", icon: "cylinder"),
    ]
}
