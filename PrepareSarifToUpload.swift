import Foundation

let fileName = "swiftlint.report.sarif"
let errorLevel = "error"
let warningThresholdRuleId = "warning_threshold"

let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let fileURL = currentDirectoryURL.appendingPathComponent(fileName)

do {
    // Load the file data
    let data = try Data(contentsOf: fileURL)
    
    // Decode JSON data
    if var jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
       var runs = jsonObject["runs"] as? [[String: Any]],
       !runs.isEmpty {
        
        if var results = runs[0]["results"] as? [[String: Any]], !results.isEmpty {
            // Filter out results based on the condition
            results = results.filter { result in
                let level = result["level"] as? String
                let ruleId = result["ruleId"] as? String
                // Keep results that don't match the deletion condition
                return !(level == errorLevel && ruleId == warningThresholdRuleId)
            }
            
            // Update the modified results array back into the runs structure
            runs[0]["results"] = results
            jsonObject["runs"] = runs
            
            // Encode the updated JSON data back to Data
            let updatedData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            
            // Write the updated data back to the file
            try updatedData.write(to: fileURL)
            print("Filtered JSON file updated successfully.")
        } else {
            print("No results found to filter.")
        }
    } else {
        print("The JSON structure is not in the expected format.")
    }
} catch {
    print("Error reading or writing JSON file: \(error.localizedDescription)")
}

exit(0)
