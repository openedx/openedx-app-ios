//
//  CoursePersistence.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 25.07.2023.
//

import Foundation
import CoreData
import Course
import Core

public class CoursePersistence: CoursePersistenceProtocol {
    
    private var context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func loadCourseDetails(courseID: String) throws -> CourseDetails {
        let request = CDCourseDetails.fetchRequest()
        request.predicate = NSPredicate(format: "courseID = %@", courseID)
        guard let courseDetails = try? context.fetch(request).first else { throw NoCachedDataError() }
        return CourseDetails(courseID: courseDetails.courseID ?? "",
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
                             courseVideoURL: nil)
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
            
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
    
    public func loadEnrollments() throws -> [CourseItem] {
        let result = try? context.fetch(CDCourseItem.fetchRequest())
            .map {
                CourseItem(name: $0.name ?? "",
                           org: $0.org ?? "",
                           shortDescription: $0.desc ?? "",
                           imageURL: $0.imageURL ?? "",
                           isActive: $0.isActive,
                           courseStart: $0.courseStart,
                           courseEnd: $0.courseEnd,
                           enrollmentStart: $0.enrollmentStart,
                           enrollmentEnd: $0.enrollmentEnd,
                           courseID: $0.courseID ?? "",
                           numPages: Int($0.numPages),
                           coursesCount: Int($0.courseCount))}
        if let result, !result.isEmpty {
            return result
        } else {
            throw NoCachedDataError()
        }
    }
    
    public func saveEnrollments(items: [CourseItem]) {
        context.performAndWait {
            for item in items {
                let newItem = CDCourseItem(context: context)
                newItem.name = item.name
                newItem.org = item.org
                newItem.desc = item.shortDescription
                newItem.imageURL = item.imageURL
                if let isActive = item.isActive {
                    newItem.isActive = isActive
                }
                newItem.courseStart = item.courseStart
                newItem.courseEnd = item.courseEnd
                newItem.enrollmentStart = item.enrollmentStart
                newItem.enrollmentEnd = item.enrollmentEnd
                newItem.numPages = Int32(item.numPages)
                newItem.courseID = item.courseID
                newItem.courseCount = Int32(item.coursesCount)
                
                do {
                    try context.save()
                } catch {
                    print("⛔️⛔️⛔️⛔️⛔️", error)
                }
            }
        }
    }
    
    public func loadCourseStructure(courseID: String) throws -> DataLayer.CourseStructure {
        let request = CDCourseStructure.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", courseID)
        guard let structure = try? context.fetch(request).first else { throw NoCachedDataError() }
        
        let requestBlocks = CDCourseBlock.fetchRequest()
        requestBlocks.predicate = NSPredicate(format: "courseID = %@", courseID)
        
        let blocks = try? context.fetch(requestBlocks).map {
            let userViewData = DataLayer.CourseDetailUserViewData(
                transcripts: nil,
                encodedVideo: DataLayer.CourseDetailEncodedVideoData(
                    youTube: DataLayer.CourseDetailYouTubeData(url: $0.youTubeUrl),
                    fallback: DataLayer.CourseDetailYouTubeData(url: $0.fallbackUrl)
                ), topicID: "")
            return DataLayer.CourseBlock(blockId: $0.blockId ?? "",
                                          id: $0.id ?? "",
                                          graded: $0.graded,
                                          completion: $0.completion,
                                          studentUrl: $0.studentUrl ?? "",
                                          type: $0.type ?? "",
                                          displayName: $0.displayName ?? "",
                                          descendants: $0.descendants,
                                          allSources: $0.allSources,
                                          userViewData: userViewData)
        }
        
        let dictionary = blocks?.reduce(into: [:]) { result, block in
            result[block.id] = block
        } ?? [:]
        
        return DataLayer.CourseStructure(
            rootItem: structure.rootItem ?? "",
            dict: dictionary,
            id: structure.id ?? "",
            media: DataLayer.CourseMedia(
                image: DataLayer.Image(
                    raw: structure.mediaRaw ?? "",
                    small: structure.mediaSmall ?? "",
                    large: structure.mediaLarge ?? ""
                )
            ),
            certificate: DataLayer.Certificate(url: structure.certificate)
        )
    }
    
    public func saveCourseStructure(structure: DataLayer.CourseStructure) {
        context.performAndWait {
            let newStructure = CDCourseStructure(context: self.context)
            newStructure.certificate = structure.certificate?.url
            newStructure.mediaSmall = structure.media.image.small
            newStructure.mediaLarge = structure.media.image.large
            newStructure.mediaRaw = structure.media.image.raw
            newStructure.id = structure.id
            newStructure.rootItem = structure.rootItem
            
            for block in Array(structure.dict.values) {
                let courseDetail = CDCourseBlock(context: self.context)
                courseDetail.allSources = block.allSources
                courseDetail.descendants = block.descendants
                courseDetail.graded = block.graded
                courseDetail.blockId = block.blockId
                courseDetail.courseID = structure.id
                courseDetail.displayName = block.displayName
                courseDetail.id = block.id
                courseDetail.studentUrl = block.studentUrl
                courseDetail.type = block.type
                courseDetail.youTubeUrl = block.userViewData?.encodedVideo?.youTube?.url
                courseDetail.fallbackUrl = block.userViewData?.encodedVideo?.fallback?.url
                courseDetail.completion = block.completion ?? 0
                
                do {
                    try context.save()
                } catch {
                    print("⛔️⛔️⛔️⛔️⛔️", error)
                }
            }
        }
    }
    
    public func saveSubtitles(url: String, subtitlesString: String) {
        context.performAndWait {
            let newSubtitle = CDSubtitle(context: context)
            newSubtitle.url = url
            newSubtitle.subtitle = subtitlesString
            newSubtitle.uploadedAt = Date()
            
            do {
                try context.save()
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
    }
    
    public func loadSubtitles(url: String) -> String? {
        let request = CDSubtitle.fetchRequest()
        request.predicate = NSPredicate(format: "url = %@", url)
        
        guard let subtitle = try? context.fetch(request).first,
              let loaded = subtitle.uploadedAt else { return nil }
        if Date().timeIntervalSince1970 - loaded.timeIntervalSince1970 < 5 * 3600 {
            return subtitle.subtitle ?? ""
        }
        return nil
    }
    
    public func saveCourseDates(courseID: String, courseDates: CourseDates) {
        
    }
    
    public func loadCourseDates(courseID: String) throws -> CourseDates {
        throw NoCachedDataError()
    }
}
