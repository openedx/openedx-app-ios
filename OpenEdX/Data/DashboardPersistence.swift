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
    
    public func loadEnrollments() throws -> [CourseItem] {
        let result = try? context.fetch(CDDashboardCourse.fetchRequest())
            .map {
                var coursewareAccess: CoursewareAccess?
                if let access = $0.coursewareAccess {
                    var coursewareError: CourseAccessError?
                    if let error = access.errorCode {
                        coursewareError = CourseAccessError(rawValue: error) ?? .unknown
                    }
                    
                    coursewareAccess = CoursewareAccess(
                        hasAccess: access.hasAccess,
                        errorCode: coursewareError,
                        developerMessage: access.developerMessage,
                        userMessage: access.userMessage,
                        additionalContextUserMessage: access.additionalContextUserMessage,
                        userFragment: access.userFragment
                    )
                }
                return CourseItem(name: $0.name ?? "",
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
                                  sku: $0.courseSku ?? "",
                                  dynamicUpgradeDeadline: $0.dynamicUpgradeDeadline,
                                  mode: DataLayer.Mode(rawValue: $0.mode ?? "") ?? .unknown,
                                  isSelfPaced: $0.isSelfPaced,
                                  courseRawImage: $0.courseRawImage,
                                  coursewareAccess: coursewareAccess,
                                  progressEarned: 0,
                                  progressPossible: 0)}
        if let result, !result.isEmpty {
            return result
        } else {
            throw NoCachedDataError()
        }
    }
    
    public func saveEnrollments(items: [CourseItem]) {
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
                newItem.courseSku = item.sku
                newItem.dynamicUpgradeDeadline = item.dynamicUpgradeDeadline
                newItem.mode = item.mode.rawValue
                newItem.courseRawImage = item.courseRawImage
                
                if let access = item.coursewareAccess {
                    let newAccess = CDDashboardCoursewareAccess(context: self.context)
                    newAccess.hasAccess = access.hasAccess
                    newAccess.errorCode = access.errorCode?.rawValue
                    newAccess.developerMessage = access.developerMessage
                    newAccess.userMessage = access.userMessage
                    newAccess.additionalContextUserMessage = access.additionalContextUserMessage
                    newAccess.userFragment = access.userFragment
                    newItem.coursewareAccess = newAccess
                }
                newItem.isSelfPaced = item.isSelfPaced ?? false
                do {
                    try context.save()
                } catch {
                    print("⛔️⛔️⛔️⛔️⛔️", error)
                }
            }
        }
    }
    
    // swiftlint:disable function_body_length
    public func loadPrimaryEnrollment() throws -> PrimaryEnrollment {
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
                    var coursewareAccess: CoursewareAccess?
                    if let access = cdCourse.coursewareAccess {
                        var coursewareError: CourseAccessError?
                        if let error = access.errorCode {
                            coursewareError = CourseAccessError(rawValue: error) ?? .unknown
                        }
                        
                        coursewareAccess = CoursewareAccess(
                            hasAccess: access.hasAccess,
                            errorCode: coursewareError,
                            developerMessage: access.developerMessage,
                            userMessage: access.userMessage,
                            additionalContextUserMessage: access.additionalContextUserMessage,
                            userFragment: access.userFragment
                        )
                    }
                    
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
                        sku: cdCourse.courseSku ?? "",
                        dynamicUpgradeDeadline: cdCourse.dynamicUpgradeDeadline,
                        mode: DataLayer.Mode(rawValue: cdCourse.mode ?? "") ?? .unknown,
                        isSelfPaced: cdCourse.isSelfPaced,
                        courseRawImage: cdCourse.courseRawImage,
                        coursewareAccess: coursewareAccess,
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
    
    public func savePrimaryEnrollment(enrollments: PrimaryEnrollment) {
        context.performAndWait {
            // Deleting all old data before saving new ones
            clearOldEnrollmentsData()
            
            let newEnrollment = CDMyEnrollments(context: self.context)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            // Saving new courses
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
                cdCourse.hasAccess = course.hasAccess
                cdCourse.courseSku = course.sku
                cdCourse.dynamicUpgradeDeadline = course.dynamicUpgradeDeadline
                cdCourse.mode = course.mode.rawValue
                cdCourse.isSelfPaced = course.isSelfPaced ?? false
                cdCourse.progressEarned = Int32(course.progressEarned)
                cdCourse.progressPossible = Int32(course.progressPossible)
                return cdCourse
            })
            
            // Saving PrimaryCourse
            if let primaryCourse = enrollments.primaryCourse {
                let cdPrimaryCourse = CDPrimaryCourse(context: self.context)
                
                let futureAssignments = primaryCourse.futureAssignments.map { assignment in
                    let cdAssignment = CDAssignment(context: self.context)
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
                    let cdAssignment = CDAssignment(context: self.context)
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
    // swiftlint:enable function_body_length
    
    func clearOldEnrollmentsData() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = CDDashboardCourse.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = CDPrimaryCourse.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        
        let fetchRequest3: NSFetchRequest<NSFetchRequestResult> = CDMyEnrollments.fetchRequest()
        let batchDeleteRequest3 = NSBatchDeleteRequest(fetchRequest: fetchRequest3)
        
        do {
            try context.execute(batchDeleteRequest1)
            try context.execute(batchDeleteRequest2)
            try context.execute(batchDeleteRequest3)
        } catch {
            print("Error when deleting old data:", error)
        }
    }
    
    public func saveServerConfig(configs: DataLayer.ServerConfigs) {
        context.performAndWait {
            let result = try? context.fetch(CDServerConfigs.fetchRequest())
            var item: CDServerConfigs?
            
            if let result, !result.isEmpty {
                item = result.first
                item?.config = configs.config
            } else {
                item = CDServerConfigs(context: context)
            }
            
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            item?.config = configs.config
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
    
    public func loadServerConfig() throws -> DataLayer.ServerConfigs? {
        let result = try? context.fetch(CDServerConfigs.fetchRequest())
            .map { DataLayer.ServerConfigs(config: $0.config ?? "")}
        
        if let result, !result.isEmpty {
            return result.first
            
        } else {
            throw NoCachedDataError()
        }
    }
}
