import Foundation
import PencilKit

struct Note: Identifiable, Codable {
    let id: UUID
    let templateId: String
    var title: String
    var textContents: [String: String]
    var drawingData: Data?
    let createdAt: Date
    var updatedAt: Date

    init(templateId: String, title: String = "") {
        self.id = UUID()
        self.templateId = templateId
        self.title = title
        self.textContents = [:]
        self.drawingData = nil
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    var templateName: String {
        Template.template(for: templateId)?.name ?? templateId
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: updatedAt)
    }
}
