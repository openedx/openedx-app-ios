//
//  CoursePersistence.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 25.07.2023.
//

import Foundation
import OEXFoundation
@preconcurrency import CoreData
import Course
import Core

public final class CoursePersistence: CoursePersistenceProtocol {
    
    private let container: NSPersistentContainer
    
    public init(container: NSPersistentContainer) {
        self.container = container
    }
    
    public func loadEnrollments() async throws -> [CourseItem] {
        return try await container.performBackgroundTask { context in
            let result = try? context.fetch(CDCourseItem.fetchRequest())
                .map {
                    CourseItem(name: $0.name ?? "",
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
                               progressPossible: 0)
                }
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
                let newItem = CDCourseItem(context: context)
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
                newItem.courseCount = Int32(item.coursesCount)
            }
            do {
                try context.save()
            } catch {
                debugLog(error)
            }
        }
    }
    
    public func loadCourseStructure(courseID: String) async throws -> DataLayer.CourseStructure {
        let request = CDCourseStructure.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", courseID)
        return try await container.performBackgroundTask { context in
            guard let structure = try? context.fetch(request).first else { throw NoCachedDataError() }
            
            let requestBlocks = CDCourseBlock.fetchRequest()
            requestBlocks.predicate = NSPredicate(format: "courseID = %@", courseID)
            
            let blocks = try? context.fetch(requestBlocks).map {
                let userViewData = DataLayer.CourseDetailUserViewData(
                    transcripts: $0.transcripts?.jsonStringToDictionary() as? [String: String],
                    encodedVideo: DataLayer.CourseDetailEncodedVideoData(
                        youTube: DataLayer.EncodedVideoData(
                            url: $0.youTube?.url,
                            fileSize: $0.youTube?.fileSize == nil ? nil : Int($0.youTube!.fileSize)
                        ),
                        fallback: DataLayer.EncodedVideoData(
                            url: $0.fallback?.url,
                            fileSize: $0.fallback?.fileSize == nil ? nil : Int($0.fallback!.fileSize)
                        ),
                        desktopMP4: DataLayer.EncodedVideoData(
                            url: $0.desktopMP4?.url,
                            fileSize: $0.desktopMP4?.fileSize == nil ? nil : Int($0.desktopMP4!.fileSize)
                        ),
                        mobileHigh: DataLayer.EncodedVideoData(
                            url: $0.mobileHigh?.url,
                            fileSize: $0.mobileHigh?.fileSize == nil ? nil : Int($0.mobileHigh!.fileSize)
                        ),
                        mobileLow: DataLayer.EncodedVideoData(
                            url: $0.mobileLow?.url,
                            fileSize: $0.mobileLow?.fileSize == nil ? nil : Int($0.mobileLow!.fileSize)
                        ),
                        hls: DataLayer.EncodedVideoData(
                            url: $0.hls?.url,
                            fileSize: $0.hls?.fileSize == nil ? nil : Int($0.hls!.fileSize)
                        )
                    ),
                    topicID: ""
                )
                return DataLayer.CourseBlock(
                    blockId: $0.blockId ?? "",
                    id: $0.id ?? "",
                    graded: $0.graded,
                    due: $0.due,
                    completion: $0.completion,
                    studentUrl: $0.studentUrl ?? "",
                    webUrl: $0.webUrl ?? "",
                    type: $0.type ?? "",
                    displayName: $0.displayName ?? "",
                    descendants: $0.descendants,
                    allSources: $0.allSources,
                    userViewData: userViewData,
                    multiDevice: $0.multiDevice,
                    assignmentProgress: DataLayer.AssignmentProgress(
                        assignmentType: $0.assignmentType,
                        numPointsEarned: $0.numPointsEarned,
                        numPointsPossible: $0.numPointsPossible
                    ),
                    offlineDownload: DataLayer.OfflineDownload(
                        fileUrl: $0.fileUrl,
                        lastModified: $0.lastModified,
                        fileSize: Int($0.fileSize)
                    )
                )
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
                certificate: DataLayer.Certificate(url: structure.certificate),
                org: structure.org ?? "",
                isSelfPaced: structure.isSelfPaced,
                courseProgress: DataLayer.CourseProgress(
                    assignmentsCompleted: Int(structure.assignmentsCompleted),
                    totalAssignmentsCount: Int(structure.totalAssignmentsCount)
                )
            )
        }
    }
        
    public func saveCourseStructure(structure: DataLayer.CourseStructure) async {
        await container.performBackgroundTask { context in
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            let newStructure = CDCourseStructure(context: context)
            newStructure.certificate = structure.certificate?.url
            newStructure.mediaSmall = structure.media.image.small
            newStructure.mediaLarge = structure.media.image.large
            newStructure.mediaRaw = structure.media.image.raw
            newStructure.id = structure.id
            newStructure.rootItem = structure.rootItem
            newStructure.isSelfPaced = structure.isSelfPaced
            newStructure.totalAssignmentsCount = Int32(structure.courseProgress?.totalAssignmentsCount ?? 0)
            newStructure.assignmentsCompleted = Int32(structure.courseProgress?.assignmentsCompleted ?? 0)
            for block in Array(structure.dict.values) {
                let courseDetail = CDCourseBlock(context: context)
                courseDetail.allSources = block.allSources
                courseDetail.descendants = block.descendants
                courseDetail.graded = block.graded
                courseDetail.blockId = block.blockId
                courseDetail.courseID = structure.id
                courseDetail.displayName = block.displayName
                courseDetail.id = block.id
                courseDetail.studentUrl = block.studentUrl
                courseDetail.type = block.type
                courseDetail.completion = block.completion ?? 0
                courseDetail.multiDevice = block.multiDevice ?? false
                if let numPointsEarned = block.assignmentProgress?.numPointsEarned {
                    courseDetail.numPointsEarned = numPointsEarned
                }
                if let numPointsPossible = block.assignmentProgress?.numPointsPossible {
                    courseDetail.numPointsPossible = numPointsPossible
                }
                if let assignmentType = block.assignmentProgress?.assignmentType {
                    courseDetail.assignmentType = assignmentType
                }
                if let due = block.due {
                    courseDetail.due = due
                }
                if let offlineDownload = block.offlineDownload,
                   let fileSize = offlineDownload.fileSize,
                   let fileUrl = offlineDownload.fileUrl,
                   let lastModified = offlineDownload.lastModified {
                    courseDetail.fileSize = Int64(fileSize)
                    courseDetail.fileUrl = fileUrl
                    courseDetail.lastModified = lastModified
                }
                if block.userViewData?.encodedVideo?.youTube != nil {
                    let youTube = CDCourseBlockVideo(context: context)
                    youTube.url = block.userViewData?.encodedVideo?.youTube?.url
                    youTube.fileSize = Int32(block.userViewData?.encodedVideo?.youTube?.fileSize ?? 0)
                    youTube.streamPriority = Int32(block.userViewData?.encodedVideo?.youTube?.streamPriority ?? 0)
                    courseDetail.youTube = youTube
                }
                if block.userViewData?.encodedVideo?.fallback != nil {
                    let fallback = CDCourseBlockVideo(context: context)
                    fallback.url = block.userViewData?.encodedVideo?.fallback?.url
                    fallback.fileSize = Int32(block.userViewData?.encodedVideo?.fallback?.fileSize ?? 0)
                    fallback.streamPriority = Int32(block.userViewData?.encodedVideo?.fallback?.streamPriority ?? 0)
                    courseDetail.fallback = fallback
                }
                if block.userViewData?.encodedVideo?.desktopMP4 != nil {
                    let desktopMP4 = CDCourseBlockVideo(context: context)
                    desktopMP4.url = block.userViewData?.encodedVideo?.desktopMP4?.url
                    desktopMP4.fileSize = Int32(block.userViewData?.encodedVideo?.desktopMP4?.fileSize ?? 0)
                    desktopMP4.streamPriority = Int32(block.userViewData?.encodedVideo?.desktopMP4?.streamPriority ?? 0)
                    courseDetail.desktopMP4 = desktopMP4
                }
                if block.userViewData?.encodedVideo?.mobileHigh != nil {
                    let mobileHigh = CDCourseBlockVideo(context: context)
                    mobileHigh.url = block.userViewData?.encodedVideo?.mobileHigh?.url
                    mobileHigh.fileSize = Int32(block.userViewData?.encodedVideo?.mobileHigh?.fileSize ?? 0)
                    mobileHigh.streamPriority = Int32(block.userViewData?.encodedVideo?.mobileHigh?.streamPriority ?? 0)
                    courseDetail.mobileHigh = mobileHigh
                }
                if block.userViewData?.encodedVideo?.mobileLow != nil {
                    let mobileLow = CDCourseBlockVideo(context: context)
                    mobileLow.url = block.userViewData?.encodedVideo?.mobileLow?.url
                    mobileLow.fileSize = Int32(block.userViewData?.encodedVideo?.mobileLow?.fileSize ?? 0)
                    mobileLow.streamPriority = Int32(block.userViewData?.encodedVideo?.mobileLow?.streamPriority ?? 0)
                    courseDetail.mobileLow = mobileLow
                }
                if block.userViewData?.encodedVideo?.hls != nil {
                    let hls = CDCourseBlockVideo(context: context)
                    hls.url = block.userViewData?.encodedVideo?.hls?.url
                    hls.fileSize = Int32(block.userViewData?.encodedVideo?.hls?.fileSize ?? 0)
                    hls.streamPriority = Int32(block.userViewData?.encodedVideo?.hls?.streamPriority ?? 0)
                    courseDetail.hls = hls
                }
                if let transcripts = block.userViewData?.transcripts {
                    courseDetail.transcripts = transcripts.toJson()
                }
            }
            do {
                try context.save()
            } catch {
                debugLog(error)
            }
        }
    }
    
    public func saveSubtitles(url: String, subtitlesString: String) async {
        await container.performBackgroundTask { context in
            let newSubtitle = CDSubtitle(context: context)
            newSubtitle.url = url
            newSubtitle.subtitle = subtitlesString
            newSubtitle.uploadedAt = Date()
            
            do {
                try context.save()
            } catch {
                debugLog(error)
            }
        }
    }
    
    public func loadSubtitles(url: String) async -> String? {
        let request = CDSubtitle.fetchRequest()
        request.predicate = NSPredicate(format: "url = %@", url)
        return await container.performBackgroundTask { context in
            guard let subtitle = try? context.fetch(request).first,
                  let loaded = subtitle.uploadedAt else { return nil }
            if Date().timeIntervalSince1970 - loaded.timeIntervalSince1970 < 5 * 3600 {
                return subtitle.subtitle ?? ""
            }
            return nil
        }
    }
    
    public func saveCourseDates(courseID: String, courseDates: CourseDates) async {
        
    }
    
    public func loadCourseDates(courseID: String) async throws -> CourseDates {
        throw NoCachedDataError()
    }
}
