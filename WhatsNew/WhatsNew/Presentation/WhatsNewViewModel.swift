//
//  WhatsNewViewModel.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 18.10.2023.
//

import SwiftUI
import Core
import Swinject

@MainActor
public class WhatsNewViewModel: ObservableObject {
    @Published var index: Int = 0
    @Published var newItems: [WhatsNewPage] = []
    private let storage: WhatsNewStorage
    var sourceScreen: LogistrationSourceScreen
    let analytics: WhatsNewAnalytics
    
    public init(
        storage: WhatsNewStorage,
        sourceScreen: LogistrationSourceScreen = .default,
        analytics: WhatsNewAnalytics
    ) {
        self.storage = storage
        self.sourceScreen = sourceScreen
        self.analytics = analytics
        newItems = loadWhatsNew()
    }
    
    public func getVersion() -> String? {
        guard let model = loadWhatsNewModel() else { return nil }
        return model.first?.version
    }
    
    public func shouldShowWhatsNew() -> Bool {
        guard let currentVersion = getVersion() else { return false }
        
        // If there is no saved version in storage, we always show WhatsNew
        guard let savedVersion = storage.whatsNewVersion else { return true }
        
        // We break down the versions into components major, minor, patch
        let savedComponents = savedVersion.components(separatedBy: ".")
        let currentComponents = currentVersion.components(separatedBy: ".")
        
        // Checking major and minor components
        if savedComponents.count >= 2 && currentComponents.count >= 2 {
            let savedMajor = savedComponents[0]
            let savedMinor = savedComponents[1]
            
            let currentMajor = currentComponents[0]
            let currentMinor = currentComponents[1]
            
            // If major or minor are different, show WhatsNew
            if savedMajor != currentMajor || savedMinor != currentMinor {
                return true
            }
        }
        return false
    }
    
    func loadWhatsNew() -> [WhatsNewPage] {
        guard let domain = loadWhatsNewModel()?.domain else { return [] }
        return domain
    }
    
    private func loadWhatsNewModel() -> WhatsNewModel? {
        guard let fileUrl = Bundle(for: Self.self).url(forResource: "WhatsNew", withExtension: "json") else {
            print("Unable to locate WhatsNew.json")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            return try decoder.decode(WhatsNewModel.self, from: data)
        } catch {
            print("Error decoding WhatsNew.json: \(error)")
            return nil
        }
    }
    
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    func logWhatsNewPopup() {
        analytics.whatsnewPopup()
    }
    
    func logWhatsNewDone() {
        let total = newItems.count
        analytics.whatsnewDone(totalScreens: total)
    }
    
    func logWhatsNewClose() {
        let total = newItems.count
        
        analytics.whatsnewClose(totalScreens: total, currentScreen: index + 1)
    }
}
