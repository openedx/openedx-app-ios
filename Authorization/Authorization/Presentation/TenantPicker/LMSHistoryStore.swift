import CoreData
import Foundation

protocol LMSHistoryStoreProtocol: Sendable {
    func fetchHistory(limit: Int) -> [LMSHistoryItem]
    func save(detail: LMSDetail, payload: Data, pinned: Bool) throws
    func clearHistory() throws
    func deleteAllOverrides() throws
    func unpinAll() throws
    func pinnedItem() -> LMSHistoryItem?
}

final class LMSHistoryStore: LMSHistoryStoreProtocol {
    private enum Constants {
        static let entityName = "LMSHistoryEntry"
        static let storeName = "lmsDirectory_lms_history"
        static let maxEntries = 10
    }

    private let container: NSPersistentContainer
    private let queue = DispatchQueue(label: "com.lmsDirectory.lmsHistoryStore", qos: .userInitiated)

    init() {
        let model = Self.makeModel()
        container = NSPersistentContainer(name: Constants.storeName, managedObjectModel: model)
        if let description = container.persistentStoreDescriptions.first {
            let url = Self.storeURL()
            description.url = url
        }
        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure("Failed to load LMS history store: \(error)")
            }
        }
        container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func fetchHistory(limit: Int = Constants.maxEntries) -> [LMSHistoryItem] {
        queue.sync {
            let context = container.newBackgroundContext()
            return context.performAndWait {
                let request = NSFetchRequest<LMSHistoryEntry>(entityName: Constants.entityName)
                request.fetchLimit = limit
                request.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(LMSHistoryEntry.pinned), ascending: false),
                    NSSortDescriptor(key: #keyPath(LMSHistoryEntry.lastOpenedAt), ascending: false)
                ]
                do {
                    return try context.fetch(request).compactMap { $0.toDomain() }
                } catch {
                    return []
                }
            }
        }
    }

    func save(detail: LMSDetail, payload: Data, pinned: Bool) throws {
        try queue.sync {
            let context = container.newBackgroundContext()
            try context.performAndWait {
                let request = NSFetchRequest<LMSHistoryEntry>(entityName: Constants.entityName)
                request.predicate = NSPredicate(format: "id == %@", detail.id)
                let entry = try context.fetch(request).first ?? LMSHistoryEntry(context: context)
                entry.id = detail.id
                entry.title = detail.title
                entry.shortDescription = detail.shortDescription
                entry.baseURL = detail.baseURL.absoluteString
                entry.logoURL = detail.logoURL?.absoluteString
                entry.payload = payload
                entry.lastOpenedAt = Date()
                entry.pinned = pinned
                try context.save()
                try trimIfNeeded(context: context)
            }
        }
    }

    func clearHistory() throws {
        try queue.sync {
            let context = container.newBackgroundContext()
            try context.performAndWait {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
                let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
                try context.execute(batchDelete)
                try context.save()
            }
        }
    }

    func deleteAllOverrides() throws {
        try queue.sync {
            let context = container.newBackgroundContext()
            try context.performAndWait {
                let request = NSFetchRequest<LMSHistoryEntry>(entityName: Constants.entityName)
                request.predicate = NSPredicate(format: "pinned == YES")
                let pinnedItems = try context.fetch(request)
                pinnedItems.forEach { $0.pinned = false }
                try context.save()
            }
        }
    }

    func unpinAll() throws {
        try queue.sync {
            let context = container.newBackgroundContext()
            try context.performAndWait {
                let request = NSFetchRequest<LMSHistoryEntry>(entityName: Constants.entityName)
                request.predicate = NSPredicate(format: "pinned == YES")
                let entries = try context.fetch(request)
                entries.forEach { $0.pinned = false }
                try context.save()
            }
        }
    }

    func pinnedItem() -> LMSHistoryItem? {
        queue.sync {
            let context = container.newBackgroundContext()
            return context.performAndWait {
                let request = NSFetchRequest<LMSHistoryEntry>(entityName: Constants.entityName)
                request.predicate = NSPredicate(format: "pinned == YES")
                request.fetchLimit = 1
                request.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(LMSHistoryEntry.lastOpenedAt), ascending: false)
                ]
                return try? context.fetch(request).first?.toDomain()
            }
        }
    }

    // MARK: - Private

    private func trimIfNeeded(context: NSManagedObjectContext) throws {
        try context.performAndWait {
            let request = NSFetchRequest<LMSHistoryEntry>(entityName: Constants.entityName)
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(LMSHistoryEntry.lastOpenedAt), ascending: false)]
            let entries = try context.fetch(request)
            guard entries.count > Constants.maxEntries else { return }
            entries
                .suffix(from: Constants.maxEntries)
                .forEach { context.delete($0) }
            try context.save()
        }
    }

    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = Constants.entityName
        entity.managedObjectClassName = NSStringFromClass(LMSHistoryEntry.self)

        entity.properties = [
            attribute(name: "id", type: .stringAttributeType, isOptional: false, indexed: true),
            attribute(name: "title", type: .stringAttributeType),
            attribute(name: "shortDescription", type: .stringAttributeType),
            attribute(name: "baseURL", type: .stringAttributeType),
            attribute(name: "logoURL", type: .stringAttributeType),
            attribute(name: "lastOpenedAt", type: .dateAttributeType),
            attribute(name: "payload", type: .binaryDataAttributeType),
            attribute(name: "pinned", type: .booleanAttributeType)
        ]

        model.entities = [entity]
        return model
    }

    private static func attribute(
        name: String,
        type: NSAttributeType,
        isOptional: Bool = true,
        indexed: Bool = false
    ) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = type
        attribute.isOptional = isOptional
        return attribute
    }

    private static func storeURL() -> URL {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let base = urls.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
        let directory = base.appendingPathComponent("LMSDirectory", isDirectory: true)
        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        return directory.appendingPathComponent("\(Constants.storeName).sqlite")
    }
}

@objc(LMSHistoryEntry)
private final class LMSHistoryEntry: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var shortDescription: String
    @NSManaged var baseURL: String
    @NSManaged var logoURL: String?
    @NSManaged var lastOpenedAt: Date
    @NSManaged var payload: Data
    @NSManaged var pinned: Bool

    func toDomain() -> LMSHistoryItem? {
        guard let baseURL = URL(string: baseURL) else {
            return nil
        }
        return LMSHistoryItem(
            id: id,
            title: title,
            shortDescription: shortDescription,
            baseURL: baseURL,
            logoURL: logoURL.flatMap(URL.init(string:)),
            lastOpenedAt: lastOpenedAt,
            payloadData: payload,
            isPinned: pinned
        )
    }
}
