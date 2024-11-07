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
    
    public func loadDiscovery() async throws -> [CourseItem] {
        try await context.perform {[context] in
            let result = try? context.fetch(CDDiscoveryCourse.fetchRequest())
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
    
    public func saveDiscovery(items: [CourseItem]) {
        for item in items {
            context.perform {[context] in
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
                
                do {
                    try context.save()
                } catch {
                    print("⛔️⛔️⛔️⛔️⛔️", error)
                }
            }
        }
    }
    
    public func loadCourseDetails(courseID: String) async throws -> CourseDetails {
        try await context.perform {[context] in
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
                courseVideoURL: nil,
                courseRawImage: courseDetails.courseRawImage
            )
        }
    }
    
    public func saveCourseDetails(course: CourseDetails) {
        context.perform {[context] in
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
            newCourseDetails.courseRawImage = course.courseRawImage
            
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
}
