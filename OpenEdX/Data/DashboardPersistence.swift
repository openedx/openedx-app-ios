//
//  DashboardPersistence.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 25.07.2023.
//

import Dashboard
import Core
import Foundation
import CoreData

public class DashboardPersistence: DashboardPersistenceProtocol {
    
    private var context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func loadMyCourses() throws -> [CourseItem] {
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
                              progressEarned: 0,
                              progressPossible: 0)}
        if let result, !result.isEmpty {
            return result
        } else {
            throw NoCachedDataError()
        }
    }
    
    public func saveMyCourses(items: [CourseItem]) {
        for item in items {
            context.performAndWait {
                let newItem = CDDashboardCourse(context: self.context)
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
                
                do {
                    try context.save()
                } catch {
                    print("⛔️⛔️⛔️⛔️⛔️", error)
                }
            }
        }
    }

    public func loadMyEnrollments() throws -> PrimaryEnrollment {
        let request = CDMyEnrollments.fetchRequest()
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
    
    // swiftlint:disable function_body_length
    public func saveMyEnrollments(enrollments: PrimaryEnrollment) {
        context.performAndWait {
            let request: NSFetchRequest<CDMyEnrollments> = CDMyEnrollments.fetchRequest()
            
            let existingEnrollment: CDMyEnrollments?
            do {
                existingEnrollment = try context.fetch(request).first
            } catch {
                existingEnrollment = nil
            }
            
            let newEnrollment: CDMyEnrollments
            if let existingEnrollment {
                newEnrollment = existingEnrollment
            } else {
                newEnrollment = CDMyEnrollments(context: context)
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            }

            // saving PrimaryCourse
            if let primaryCourse = enrollments.primaryCourse {
                let cdPrimaryCourse: CDPrimaryCourse
                if let existingPrimaryCourse = newEnrollment.primaryCourse {
                    cdPrimaryCourse = existingPrimaryCourse
                } else {
                    cdPrimaryCourse = CDPrimaryCourse(context: context)
                }
                
                let futureAssignments = primaryCourse.futureAssignments
                    let uniqueFutureAssignments = Set(futureAssignments.map { assignment in
                        let assignmentRequest: NSFetchRequest<CDAssignment> = CDAssignment.fetchRequest()
                        assignmentRequest.predicate = NSPredicate(format: "title == %@", assignment.title)
                        let existingAssignment = try? self.context.fetch(assignmentRequest).first
                        
                        let cdAssignment: CDAssignment
                        if let existingAssignment {
                            cdAssignment = existingAssignment
                        } else {
                            cdAssignment = CDAssignment(context: self.context)
                        }

                        cdAssignment.type = assignment.type
                        cdAssignment.title = assignment.title
                        cdAssignment.descript = assignment.description
                        cdAssignment.date = assignment.date
                        cdAssignment.complete = assignment.complete
                        cdAssignment.firstComponentBlockId = assignment.firstComponentBlockId
                        return cdAssignment
                    })
                
                cdPrimaryCourse.futureAssignments = NSSet(array: Array(uniqueFutureAssignments))

                let pastAssignments = primaryCourse.pastAssignments
                    let uniqueAssignments = Set(pastAssignments.map { assignment in
                        let assignmentRequest: NSFetchRequest<CDAssignment> = CDAssignment.fetchRequest()
                        assignmentRequest.predicate = NSPredicate(format: "title == %@", assignment.title)
                        let existingAssignment = try? self.context.fetch(assignmentRequest).first
                        
                        let cdAssignment: CDAssignment
                        if let existingAssignment {
                            cdAssignment = existingAssignment
                        } else {
                            cdAssignment = CDAssignment(context: self.context)
                        }

                        cdAssignment.type = assignment.type
                        cdAssignment.title = assignment.title
                        cdAssignment.descript = assignment.description
                        cdAssignment.date = assignment.date
                        cdAssignment.complete = assignment.complete
                        cdAssignment.firstComponentBlockId = assignment.firstComponentBlockId
                        return cdAssignment
                    })

                    cdPrimaryCourse.pastAssignments = NSSet(array: Array(uniqueAssignments))
                
                // saving PrimaryCourse
                cdPrimaryCourse.name = primaryCourse.name
                cdPrimaryCourse.org = primaryCourse.org
                cdPrimaryCourse.courseID = primaryCourse.courseID
                cdPrimaryCourse.hasAccess = primaryCourse.hasAccess
                cdPrimaryCourse.courseStart = primaryCourse.courseStart
                cdPrimaryCourse.courseEnd = primaryCourse.courseEnd
                cdPrimaryCourse.courseBanner = primaryCourse.courseBanner
                cdPrimaryCourse.progressEarned = Int32(primaryCourse.progressEarned ?? 0)
                cdPrimaryCourse.progressPossible = Int32(primaryCourse.progressPossible ?? 0)
                cdPrimaryCourse.lastVisitedBlockID = primaryCourse.lastVisitedBlockID
                cdPrimaryCourse.resumeTitle = primaryCourse.resumeTitle

                newEnrollment.primaryCourse = cdPrimaryCourse
            }

            // saving courses
            if let existingCourses = newEnrollment.courses {
                for course in existingCourses {
                    context.delete(course as! CDDashboardCourse)
                }
            }

            newEnrollment.courses = NSSet(array: enrollments.courses.map { course in
                let cdCourse = CDDashboardCourse(context: self.context)
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
                return cdCourse
            })

            newEnrollment.totalPages = Int32(enrollments.totalPages)
            newEnrollment.count = Int32(enrollments.count)

            do {
                try context.save()
            } catch {
                print("Ошибка при сохранении MyEnrollments:", error)
            }
        }
    }
    // swiftlint:enable function_body_length
}
