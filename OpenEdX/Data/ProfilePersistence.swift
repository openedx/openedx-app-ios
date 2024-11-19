//
//  ProfilePersistence.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 03.06.2024.
//

import Profile
import Core
import OEXFoundation
import Foundation
@preconcurrency import CoreData

public final class ProfilePersistence: ProfilePersistenceProtocol {
    
    private let container: NSPersistentContainer
    
    public init(container: NSPersistentContainer) {
        self.container = container
    }
    
    public func getCourseState(courseID: String) async -> CourseCalendarState? {
        return await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<CDCourseCalendarState> = CDCourseCalendarState.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "courseID == %@", courseID)
            do {
                if let result = try context.fetch(fetchRequest).first,
                   let courseID = result.courseID,
                   let checksum = result.checksum {
                    return CourseCalendarState(courseID: courseID, checksum: checksum)
                }
            } catch {
                debugLog("⛔️ Error fetching CourseCalendarEvents: \(error)")
            }
            return nil
        }
    }
    
    public func getAllCourseStates() async -> [CourseCalendarState] {
        return await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<CDCourseCalendarState> = CDCourseCalendarState.fetchRequest()
            do {
                let results = try context.fetch(fetchRequest)
                return results.compactMap { result in
                    if let courseID = result.courseID, let checksum = result.checksum {
                        return CourseCalendarState(courseID: courseID, checksum: checksum)
                    }
                    return nil
                }
            } catch {
                debugLog("⛔️ Error fetching CourseCalendarEvents: \(error)")
                return []
            }
        }
    }
    
    public func saveCourseState(state: CourseCalendarState) async {
        await container.performBackgroundTask { context in
            let newState = CDCourseCalendarState(context: context)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            newState.courseID = state.courseID
            newState.checksum = state.checksum
            do {
                try context.save()
            } catch {
                debugLog("⛔️ Error saving CourseCalendarEvent: \(error)")
            }
        }
    }
    
    public func removeCourseState(courseID: String) async {
        await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCourseCalendarState.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "courseID == %@", courseID)
            
            do {
                if let result = try context.fetch(fetchRequest).first {
                    if let object = result as? NSManagedObject {
                        context.delete(object)
                        try context.save()
                    }
                }
            } catch {
                debugLog("⛔️ Error removing CDCourseCalendarState: \(error)")
            }
        }
    }
    
    public func deleteAllCourseStatesAndEvents() async {
        await container.performBackgroundTask { context in
            let fetchRequestCalendarStates: NSFetchRequest<NSFetchRequestResult> = CDCourseCalendarState.fetchRequest()
            let deleteRequestCalendarStates = NSBatchDeleteRequest(fetchRequest: fetchRequestCalendarStates)
            let fetchRequestCalendarEvents: NSFetchRequest<NSFetchRequestResult> = CDCourseCalendarEvent.fetchRequest()
            let deleteRequestCalendarEvents = NSBatchDeleteRequest(fetchRequest: fetchRequestCalendarEvents)
            
            do {
                try context.execute(deleteRequestCalendarStates)
                try context.execute(deleteRequestCalendarEvents)
                try context.save()
            } catch {
                debugLog("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
    
    public func saveCourseCalendarEvent(_ event: CourseCalendarEvent) async {
        await container.performBackgroundTask { context in
            let newEvent = CDCourseCalendarEvent(context: context)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            newEvent.courseID = event.courseID
            newEvent.eventIdentifier = event.eventIdentifier
            do {
                try context.save()
            } catch {
                debugLog("⛔️ Error saving CourseCalendarEvent: \(error)")
            }
        }
    }
    
    public func removeCourseCalendarEvents(for courseId: String) async {
        await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCourseCalendarEvent.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "courseID == %@", courseId)
            do {
                let results = try context.fetch(fetchRequest)
                results.forEach { result in
                    if let object = result as? NSManagedObject {
                        context.delete(object)
                    }
                }
                try context.save()
            } catch {
                debugLog("⛔️ Error removing CourseCalendarEvents: \(error)")
            }
        }
    }
    
    public func removeAllCourseCalendarEvents() async {
        await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCourseCalendarEvent.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                debugLog("⛔️ Error removing CourseCalendarEvents: \(error)")
            }
        }
    }
    
    public func getCourseCalendarEvents(for courseId: String) async -> [CourseCalendarEvent] {
        return await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<CDCourseCalendarEvent> = CDCourseCalendarEvent.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "courseID == %@", courseId)
            do {
                let results = try context.fetch(fetchRequest)
                return results.compactMap { result in
                    if let courseID = result.courseID, let eventIdentifier = result.eventIdentifier {
                        return CourseCalendarEvent(courseID: courseID, eventIdentifier: eventIdentifier)
                    }
                    return nil
                }
            } catch {
                debugLog("⛔️ Error fetching CourseCalendarEvents: \(error)")
                return []
            }
        }
    }
}
