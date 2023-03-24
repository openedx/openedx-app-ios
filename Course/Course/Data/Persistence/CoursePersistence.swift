//
//  CoursePersistence.swift
//  Course
//
//  Created by  Stepanok Ivan on 15.12.2022.
//

import CoreData
import Core

public protocol CoursePersistenceProtocol {
    func loadCourseDetails(courseID: String) throws -> CourseDetails
    func saveCourseDetails(course: CourseDetails)
    func loadEnrollments() throws -> [Core.CourseItem]
    func saveEnrollments(items: [Core.CourseItem])
    func loadCourseStructure() throws -> BECourseDetailBlocks
    func saveCourseStructure(structure: BECourseDetailBlocks)
    func clear()
}

public class CoursePersistence: CoursePersistenceProtocol {
    
    public init() {}
    
    private let model = "CourseCoreModel"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        return createContainer()
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return createContext()
    }()
    
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
                             courseBannerURL: courseDetails.courseBannerURL ?? "")
    }
    
    public func saveCourseDetails(course: CourseDetails) {
        context.performAndWait {
            let newCourseDetails = CDCourseDetails(context: context)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
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
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
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
    
    public func loadCourseStructure() throws -> BECourseDetailBlocks {
        
        let structure = try? context.fetch(CDCourseStructure.fetchRequest()).first
        
            let blocks = try? context.fetch(CDCourseDetailIncoming.fetchRequest())
                .map({
                    let userViewData = BECourseDetailUserViewData(encodedVideo: BECourseDetailEncodedVideoData(
                        youTube: BECourseDetailYouTubeData(url: $0.youTubeUrl),
                        fallback: BECourseDetailYouTubeData(url: $0.fallbackUrl)
                    ), topicID: "")
                    return BECourseDetailIncoming(blockId: $0.blockId ?? "",
                                                  id: $0.id ?? "",
                                                  graded: $0.graded,
                                                  completion: $0.completion,
                                                  studentUrl: $0.studentUrl ?? "",
                                                  type: $0.type ?? "",
                                                  displayName: $0.displayName ?? "",
                                                  descendants: $0.descendants,
                                                  allSources: $0.allSources,
                                                  userViewData: userViewData)
                })
        
        let dictionary = blocks?.reduce(into: [:]) { result, block in
            result[block.id] = block
        } ?? [:]
        
        return BECourseDetailBlocks(rootItem: structure?.rootItem ?? "",
                                    dict: dictionary,
                                    id: structure?.id ?? "",
                                    media: DataLayer.CourseMedia(image:
                                                                    DataLayer.Image(raw: structure?.mediaRaw ?? "",
                                                                                    small: structure?.mediaSmall ?? "",
                                                                                    large: structure?.mediaLarge ?? "")),
                                    certificate: Certificate(url: structure?.certificate))
    }
    
    public func saveCourseStructure(structure: BECourseDetailBlocks) {
        
        context.performAndWait {
            let newStructure = CDCourseStructure(context: context)
            newStructure.certificate = structure.certificate?.url
            newStructure.mediaSmall = structure.media.image.small
            newStructure.mediaLarge = structure.media.image.large
            newStructure.mediaRaw = structure.media.image.raw
            newStructure.id = structure.id
            newStructure.rootItem = structure.rootItem
            
            for block in Array(structure.dict.values) {
                let courseDetail = CDCourseDetailIncoming(context: context)
                courseDetail.allSources = block.allSources
                courseDetail.descendants = block.descendants
                courseDetail.graded = block.graded
                courseDetail.blockId = block.blockId
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
    
    public func clear() {
        let storeContainer = persistentContainer.persistentStoreCoordinator
        for store in storeContainer.persistentStores {
            do {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            } catch {
                print("⛔️⛔️⛔️⛔️⛔️", error)
            }
        }
        
        // Re-create the persistent container
        persistentContainer = createContainer()
        context = createContext()
    }
    
    private func createContainer() -> NSPersistentContainer {
        let bundle = Bundle(for: Self.self)
        let url = bundle.url(forResource: model, withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel(contentsOf: url!)
        let container = NSPersistentContainer(name: model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        return container
    }
    
    private func createContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}
