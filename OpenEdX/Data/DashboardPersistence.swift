//
//  DashboardPersistence.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 25.07.2023.
//

import Dashboard
import Core
import Foundation
@preconcurrency import CoreData

public final class DashboardPersistence: DashboardPersistenceProtocol {
    
    private let container: NSPersistentContainer
    
    public init(container: NSPersistentContainer) {
        self.container = container
    }
    
    public func loadEnrollments() async throws -> [CourseItem] {
        return try await container.performBackgroundTask { context in
            let result = try? context.fetch(CDDashboardCourse.fetchRequest())
                .map { CourseItem(name: $0.name ?? "",
                                  org: $0.org ?? "",
                                  shortDescription: $0.desc ?? "",
                                  imageURL: $0.imageURL ?? "",
                                  hasAccess: $0.hasAccess,
                                  courseStart: $0.courseStart,
                                  courseEnd: $0.courseEnd,
                                  enrollmentStart: $0.enrollmentStart,
                                  enrollmentEnd: $0.enrollmentEnd,
                                  courseID: $0.courseID ?? "",
                                  numPages: Int($0.numPages),
                                  coursesCount: Int($0.courseCount),
                                  courseRawImage: $0.courseRawImage,
                                  progressEarned: 0,
                                  progressPossible: 0)}
            if let result, !result.isEmpty {
                return result
            } else {
                throw NoCachedDataError()
            }
        }
    }
    
    public func saveEnrollments(items: [CourseItem]) async {
        await container.performBackgroundTask { context in
            for item in items {
                let newItem = CDDashboardCourse(context: context)
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                newItem.name = item.name
                newItem.org = item.org
                newItem.desc = item.shortDescription
                newItem.imageURL = item.imageURL
                newItem.hasAccess = item.hasAccess
                newItem.courseStart = item.courseStart
                newItem.courseEnd = item.courseEnd
                newItem.enrollmentStart = item.enrollmentStart
                newItem.enrollmentEnd = item.enrollmentEnd
                newItem.numPages = Int32(item.numPages)
                newItem.courseID = item.courseID
                newItem.courseRawImage = item.courseRawImage
            }
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }

    public func loadPrimaryEnrollment() async throws -> PrimaryEnrollment {
        let request = CDMyEnrollments.fetchRequest()
        return try await container.performBackgroundTask { context in
            if let result = try context.fetch(request).first {
                let primaryCourse = result.primaryCourse.flatMap { cdPrimaryCourse -> PrimaryCourse? in
                    
                    let futureAssignments = (cdPrimaryCourse.futureAssignments as? Set<CDAssignment> ?? [])
                        .map { future in
                            return Assignment(
                                type: future.type ?? "",
                                title: future.title ?? "",
                                description: future.descript ?? "",
                                date: future.date ?? Date(),
                                complete: future.complete,
                                firstComponentBlockId: future.firstComponentBlockId
                            )
                        }
                    
                    let pastAssignments = (cdPrimaryCourse.pastAssignments as? Set<CDAssignment> ?? [])
                        .map { past in
                            return Assignment(
                                type: past.type ?? "",
                                title: past.title ?? "",
                                description: past.descript ?? "",
                                date: past.date ?? Date(),
                                complete: past.complete,
                                firstComponentBlockId: past.firstComponentBlockId
                            )
                        }
                    
                    return PrimaryCourse(
                        name: cdPrimaryCourse.name ?? "",
                        org: cdPrimaryCourse.org ?? "",
                        courseID: cdPrimaryCourse.courseID ?? "",
                        hasAccess: cdPrimaryCourse.hasAccess,
                        courseStart: cdPrimaryCourse.courseStart,
                        courseEnd: cdPrimaryCourse.courseEnd,
                        courseBanner: cdPrimaryCourse.courseBanner ?? "",
                        futureAssignments: futureAssignments,
                        pastAssignments: pastAssignments,
                        progressEarned: Int(cdPrimaryCourse.progressEarned),
                        progressPossible: Int(cdPrimaryCourse.progressPossible),
                        lastVisitedBlockID: cdPrimaryCourse.lastVisitedBlockID ?? "",
                        resumeTitle: cdPrimaryCourse.resumeTitle
                    )
                }
                
                let courses = (result.courses as? Set<CDDashboardCourse> ?? [])
                    .map { cdCourse in
                        return CourseItem(
                            name: cdCourse.name ?? "",
                            org: cdCourse.org ?? "",
                            shortDescription: cdCourse.desc ?? "",
                            imageURL: cdCourse.imageURL ?? "",
                            hasAccess: cdCourse.hasAccess,
                            courseStart: cdCourse.courseStart,
                            courseEnd: cdCourse.courseEnd,
                            enrollmentStart: cdCourse.enrollmentStart,
                            enrollmentEnd: cdCourse.enrollmentEnd,
                            courseID: cdCourse.courseID ?? "",
                            numPages: Int(cdCourse.numPages),
                            coursesCount: Int(cdCourse.courseCount),
                            courseRawImage: cdCourse.courseRawImage,
                            progressEarned: Int(cdCourse.progressEarned),
                            progressPossible: Int(cdCourse.progressPossible)
                        )
                    }
                
                return PrimaryEnrollment(
                    primaryCourse: primaryCourse,
                    courses: courses,
                    totalPages: Int(result.totalPages),
                    count: Int(result.count)
                )
            } else {
                throw NoCachedDataError()
            }
        }
    }
    
    public func savePrimaryEnrollment(enrollments: PrimaryEnrollment) async {
        // Deleting all old data before saving new ones
        await clearOldEnrollmentsData()
        await container.performBackgroundTask { context in
            let newEnrollment = CDMyEnrollments(context: context)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            // Saving new courses
            newEnrollment.courses = NSSet(array: enrollments.courses.map { course in
                let cdCourse = CDDashboardCourse(context: context)
                cdCourse.name = course.name
                cdCourse.org = course.org
                cdCourse.desc = course.shortDescription
                cdCourse.imageURL = course.imageURL
                cdCourse.courseStart = course.courseStart
                cdCourse.courseEnd = course.courseEnd
                cdCourse.enrollmentStart = course.enrollmentStart
                cdCourse.enrollmentEnd = course.enrollmentEnd
                cdCourse.courseID = course.courseID
                cdCourse.numPages = Int32(course.numPages)
                cdCourse.hasAccess = course.hasAccess
                cdCourse.progressEarned = Int32(course.progressEarned)
                cdCourse.progressPossible = Int32(course.progressPossible)
                return cdCourse
            })
            
            // Saving PrimaryCourse
            if let primaryCourse = enrollments.primaryCourse {
                let cdPrimaryCourse = CDPrimaryCourse(context: context)
                
                let futureAssignments = primaryCourse.futureAssignments.map { assignment in
                    let cdAssignment = CDAssignment(context: context)
                    cdAssignment.type = assignment.type
                    cdAssignment.title = assignment.title
                    cdAssignment.descript = assignment.description
                    cdAssignment.date = assignment.date
                    cdAssignment.complete = assignment.complete
                    cdAssignment.firstComponentBlockId = assignment.firstComponentBlockId
                    return cdAssignment
                }
                cdPrimaryCourse.futureAssignments = NSSet(array: futureAssignments)
                
                let pastAssignments = primaryCourse.pastAssignments.map { assignment in
                    let cdAssignment = CDAssignment(context: context)
                    cdAssignment.type = assignment.type
                    cdAssignment.title = assignment.title
                    cdAssignment.descript = assignment.description
                    cdAssignment.date = assignment.date
                    cdAssignment.complete = assignment.complete
                    cdAssignment.firstComponentBlockId = assignment.firstComponentBlockId
                    return cdAssignment
                }
                cdPrimaryCourse.pastAssignments = NSSet(array: pastAssignments)
                
                cdPrimaryCourse.name = primaryCourse.name
                cdPrimaryCourse.org = primaryCourse.org
                cdPrimaryCourse.courseID = primaryCourse.courseID
                cdPrimaryCourse.hasAccess = primaryCourse.hasAccess
                cdPrimaryCourse.courseStart = primaryCourse.courseStart
                cdPrimaryCourse.courseEnd = primaryCourse.courseEnd
                cdPrimaryCourse.courseBanner = primaryCourse.courseBanner
                cdPrimaryCourse.progressEarned = Int32(primaryCourse.progressEarned)
                cdPrimaryCourse.progressPossible = Int32(primaryCourse.progressPossible)
                cdPrimaryCourse.lastVisitedBlockID = primaryCourse.lastVisitedBlockID
                cdPrimaryCourse.resumeTitle = primaryCourse.resumeTitle
                
                newEnrollment.primaryCourse = cdPrimaryCourse
            }
            
            newEnrollment.totalPages = Int32(enrollments.totalPages)
            newEnrollment.count = Int32(enrollments.count)
            
            do {
                try context.save()
            } catch {
                print("Error when saving MyEnrollments:", error)
            }
        }
    }
    
    func clearOldEnrollmentsData() async {
        await container.performBackgroundTask { context in
            let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = CDDashboardCourse.fetchRequest()
            let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
            
            let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = CDMyEnrollments.fetchRequest()
            let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
            
            do {
                try context.execute(batchDeleteRequest1)
                try context.execute(batchDeleteRequest2)
            } catch {
                print("Error when deleting old data:", error)
            }
        }
    }
}
