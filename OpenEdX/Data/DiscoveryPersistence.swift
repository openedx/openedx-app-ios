//
//  DiscoveryPersistence.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 25.07.2023.
//

import Foundation
import Discovery
import CoreData
import Core

public class DiscoveryPersistence: DiscoveryPersistenceProtocol {
    
    private var context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func loadDiscovery() throws -> [CourseItem] {
        let result = try? context.fetch(CDDiscoveryCourse.fetchRequest())
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
                
                return CourseItem(
                    name: $0.name ?? "",
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
                    isSelfPaced: $0.isSelfPaced,
                    courseRawImage: $0.courseRawImage,
                    coursewareAccess: coursewareAccess,
                    progressEarned: 0,
                    progressPossible: 0
                )
            }
        if let result, !result.isEmpty {
            return result
        } else {
            throw NoCachedDataError()
        }
    }
    
    public func saveDiscovery(items: [CourseItem]) {
        for item in items {
            context.performAndWait {
                let newItem = CDDiscoveryCourse(context: context)
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
                
                if let access = item.coursewareAccess {
                    let newAccess = CDDiscoveryCoursewareAccess(context: self.context)
                    newAccess.hasAccess = access.hasAccess
                    newAccess.errorCode = access.errorCode?.rawValue
                    newAccess.developerMessage = access.developerMessage
                    newAccess.userMessage = access.userMessage
                    newAccess.additionalContextUserMessage = access.additionalContextUserMessage
                    newAccess.userFragment = access.userFragment
                    newItem.coursewareAccess = newAccess
                }
                do {
                    try context.save()
                } catch {
                    print("⛔️⛔️⛔️⛔️⛔️", error)
                }
            }
        }
    }
    
    public func loadCourseDetails(courseID: String) throws -> CourseDetails {
        let request = CDCourseDetails.fetchRequest()
        request.predicate = NSPredicate(format: "courseID = %@", courseID)
        guard let courseDetails = try? context.fetch(request).first else { throw NoCachedDataError() }
        return CourseDetails(
            courseID: courseDetails.courseID ?? "",
            org: courseDetails.org ?? "",
            courseTitle: courseDetails.courseTitle ?? "",
            courseDescription: courseDetails.courseDescription ?? "",
            courseStart: courseDetails.courseStart,
            courseEnd: courseDetails.courseEnd,
            enrollmentStart: courseDetails.enrollmentStart,
            enrollmentEnd: courseDetails.enrollmentEnd,
            isEnrolled: courseDetails.isEnrolled,
            overviewHTML: courseDetails.overviewHTML ?? "",
            courseBannerURL: courseDetails.courseBannerURL ?? "",
            courseVideoURL: courseDetails.courseVideoURL,
            courseRawImage: courseDetails.courseRawImage
        )
    }
    
    public func saveCourseDetails(course: CourseDetails) {
        context.performAndWait {
            let newCourseDetails = CDCourseDetails(context: self.context)
            newCourseDetails.courseID = course.courseID
            newCourseDetails.org = course.org
            newCourseDetails.courseTitle = course.courseTitle
            newCourseDetails.courseDescription = course.courseDescription
            newCourseDetails.courseStart = course.courseStart
            newCourseDetails.courseEnd = course.courseEnd
            newCourseDetails.enrollmentStart = course.enrollmentStart
            newCourseDetails.enrollmentEnd = course.enrollmentEnd
            newCourseDetails.isEnrolled = course.isEnrolled
            newCourseDetails.overviewHTML = course.overviewHTML
            newCourseDetails.courseBannerURL = course.courseBannerURL
            newCourseDetails.courseVideoURL = course.courseVideoURL
            newCourseDetails.courseRawImage = course.courseRawImage
            
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
}
