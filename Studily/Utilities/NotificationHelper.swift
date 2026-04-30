import UserNotifications

enum NotificationHelper {
    
    /// Request notification permission on first launch
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }
    
    /// Schedule a daily study reminder at 7:00 PM (repeating)
    static func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Time to Study 📚"
        content.body = "Your daily study session is waiting. Stay consistent!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyStudyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyStudyReminder"])
        UNUserNotificationCenter.current().add(request)
    }
    
    /// Cancel the daily 7PM reminder
    static func cancelDailyReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyStudyReminder"])
    }
    
    /// Schedule an exam alert 3 days before the user's exam date (one-time)
    static func scheduleExamAlert(for examDate: Date) {
        let alertDate = Calendar.current.date(byAdding: .day, value: -3, to: examDate)!
        
        // Don't schedule if the alert date is in the past
        guard alertDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Exam in 3 Days! 🔥"
        content.body = "Your exam is in 3 days. Time to intensify your revision."
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: alertDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "examAlert", content: content, trigger: trigger)
        
        // Cancel any existing exam alert and schedule new one
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["examAlert"])
        UNUserNotificationCenter.current().add(request)
    }
}
