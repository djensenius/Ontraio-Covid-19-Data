//
//  Summary.swift
//  COVID Data Ontario
//
//  Created by David Jensenius on 2021-01-02.
//

import Foundation
import SwiftCSV

// MARK: - Summary
struct Summary: Codable {
    let help: String
    let result: Result
    let success: Bool
}

// MARK: - Result
struct Result: Codable {
    let resultPrivate: Bool
    let metadataModified, authorEmail: String
    let keywords: Keywords
    let resources: [Resource]
    let groups: [Group]
    let title: String
    let relationshipsAsObject: [JSONAny]
    let revisionID: String
    let numResources: Int
    let maintainerEmail: String
    let organization: Organization
    let maintainerTranslated: AccessInstructions
    let type: String
    let notesTranslated: AccessInstructions
    let maintainer: JSONNull?
    let name, openedDate, accessLevel, metadataCreated: String
    let isopen: Bool
    let exemptionRationale, maintainerBranch: AccessInstructions
    let notes: String
    let geographicCoverageTranslated: AccessInstructions
    let licenseURL: String
    let numTags: Int
    let accessInstructions: AccessInstructions
    let author, currentAsOf: String
    let relationshipsAsSubject: [JSONAny]
    let updateFrequency, state: String
    let url: String
    let licenseID, ownerOrg: String
    let version: JSONNull?
    let licenseTitle, id: String
    let titleTranslated: AccessInstructions
    let tags: [Tag]
    let assetType, geographicGranularity, exemption, creatorUserID: String

    enum CodingKeys: String, CodingKey {
        case resultPrivate = "private"
        case metadataModified = "metadata_modified"
        case authorEmail = "author_email"
        case keywords, resources, groups, title
        case relationshipsAsObject = "relationships_as_object"
        case revisionID = "revision_id"
        case numResources = "num_resources"
        case maintainerEmail = "maintainer_email"
        case organization
        case maintainerTranslated = "maintainer_translated"
        case type
        case notesTranslated = "notes_translated"
        case maintainer, name
        case openedDate = "opened_date"
        case accessLevel = "access_level"
        case metadataCreated = "metadata_created"
        case isopen
        case exemptionRationale = "exemption_rationale"
        case maintainerBranch = "maintainer_branch"
        case notes
        case geographicCoverageTranslated = "geographic_coverage_translated"
        case licenseURL = "license_url"
        case numTags = "num_tags"
        case accessInstructions = "access_instructions"
        case author
        case currentAsOf = "current_as_of"
        case relationshipsAsSubject = "relationships_as_subject"
        case updateFrequency = "update_frequency"
        case state, url
        case licenseID = "license_id"
        case ownerOrg = "owner_org"
        case version
        case licenseTitle = "license_title"
        case id
        case titleTranslated = "title_translated"
        case tags
        case assetType = "asset_type"
        case geographicGranularity = "geographic_granularity"
        case exemption
        case creatorUserID = "creator_user_id"
    }
}

// MARK: - AccessInstructions
struct AccessInstructions: Codable {
    let fr, en: String
}

// MARK: - Group
struct Group: Codable {
    let groupDescription, displayName, title, name: String
    let id, imageDisplayURL: String

    enum CodingKeys: String, CodingKey {
        case groupDescription = "description"
        case displayName = "display_name"
        case title, name, id
        case imageDisplayURL = "image_display_url"
    }
}

// MARK: - Keywords
struct Keywords: Codable {
    let en, fr: [String]
}

// MARK: - Organization
struct Organization: Codable {
    let organizationDescription: String
    let isOrganization: Bool
    let id, imageURL, revisionID, state: String
    let created, title, approvalStatus, name: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case organizationDescription = "description"
        case isOrganization = "is_organization"
        case id
        case imageURL = "image_url"
        case revisionID = "revision_id"
        case state, created, title
        case approvalStatus = "approval_status"
        case name, type
    }
}

// MARK: - Resource
struct Resource: Codable {
    let type: String
    let resourceType: JSONNull?
    let created: String
    let size: Int?
    let datastoreActive: Bool
    let name: String
    let cacheLastUpdated: JSONNull?
    let format, version, revisionID, hash: String
    let id: String
    let lastModified, urlType: String?
    let descriptionTranslated: AccessInstructions
    let cacheURL: JSONNull?
    let mimetype: String?
    let language, packageID, state: String
    let position: Int
    let url: String
    let dataRangeEnd, dataRangeStart: String?
    let containsGeographicMarkers: Bool
    let dataLastUpdated: String?
    let resourceDescription: String
    let mimetypeInner: JSONNull?
    let dataBirthDate, publicallyAvailableDate: String?

    enum CodingKeys: String, CodingKey {
        case type
        case resourceType = "resource_type"
        case created, size
        case datastoreActive = "datastore_active"
        case name
        case cacheLastUpdated = "cache_last_updated"
        case format, version
        case revisionID = "revision_id"
        case hash, id
        case lastModified = "last_modified"
        case urlType = "url_type"
        case descriptionTranslated = "description_translated"
        case cacheURL = "cache_url"
        case mimetype, language
        case packageID = "package_id"
        case state, position, url
        case dataRangeEnd = "data_range_end"
        case dataRangeStart = "data_range_start"
        case containsGeographicMarkers = "contains_geographic_markers"
        case dataLastUpdated = "data_last_updated"
        case resourceDescription = "description"
        case mimetypeInner = "mimetype_inner"
        case dataBirthDate = "data_birth_date"
        case publicallyAvailableDate = "publically_available_date"
    }
}

// MARK: - Tag
struct Tag: Codable {
    let state, id: String
    let vocabularyID: JSONNull?
    let name, displayName: String

    enum CodingKeys: String, CodingKey {
        case state, id
        case vocabularyID = "vocabulary_id"
        case name
        case displayName = "display_name"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

struct SummaryDay {
    let ventelator: Int?
    let ltcHcwDeaths: Int?
    let confimedPositive: Int?
    let totalLTCResidentDeaths: Int?
    let deaths: Int?
    let confirmedNegative: Int?
    let totalPositiveLTCHCWCases: Int?
    let totalPositiveLTCResidentCases: Int?
    let reportedDate: Date
    let presumptiveNegative: Int?
    let percentPositiveTestsInLastDay: Int?
    let numberOfPatientsHospitalized: Int?
    let presumptivePositive: Int?
    let totalTestsCompletedInTheLastDay: Int?
    let totalPatientsApprovedForTestingAsOfReportingDate: Int?
    let numberOfPatientsInICU: Int?
    let totalCases: Int?
    let underInvestigation: Int?
    let resolved: Int?
}

struct SummaryHighlight {
    let name: String;
    let value: Int?;
    let change: Int?;
}

struct SummaryHighlightOverview {
    let date: Date?
    let highlights: [SummaryHighlight]
}

struct ChartDatas {
    let number: Int?
    let date: Date?
}

struct Chart {
    let name: String
    let data: [(String, Double)]
}

class SummaryData: ObservableObject {
    @Published var summaryData: Summary?
    @Published var today: SummaryDay?
    @Published var yesterday: SummaryDay?
    @Published var highlights: [SummaryHighlight]?
    @Published var lastChecked: Date?
    @Published var lastUpdated: Date?
    @Published var daily: [SummaryHighlightOverview]?
    @Published var dataForCharts: [Chart]?

    func fetchData() {
        print("Fetching data");
        guard let url = URL(
                string:"https://data.ontario.ca/api/3/action/package_show?id=status-of-covid-19-cases-in-ontario"
        ) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    if let decodedResponse = try? JSONDecoder().decode(Summary.self, from: data) {
                        self.summaryData = decodedResponse
                        self.grabCSVs(summary: decodedResponse)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        self.lastUpdated = dateFormatter.date(from: decodedResponse.result.resources[0].dataLastUpdated ?? "2021-01-01")
                        self.lastChecked = Date()
                    }
                }
            }
        }.resume()
    }

    func grabCSVs(summary: Summary) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for resource in summary.result.resources {
            if resource.type == "data" && resource.format == "CSV" {
                if resource.name == "Status of COVID-19 cases in Ontario" {
                    if let url = URL(string: resource.url) {
                        downloadCSV(with: url) { (data, error) in
                            if let data = data {
                                do {
                                    let s = String(data: data, encoding: .utf8)
                                    let csv: CSV = try CSV(string: s!)
                                    var dailySummary: [SummaryHighlightOverview] = []
                                    var allTheCharts: [Chart] = []
                                    for c in csv.namedRows {
                                        let day = self.parseCSVDay(csv: c)
                                        let sum = SummaryHighlightOverview(date: day.reportedDate, highlights: self.generateHighlights(today: day, yesterday: day))
                                        dailySummary.append(sum)
                                    }

                                    for c in csv.namedColumns {
                                        var numberArray: [(String, Double)] = []
                                        for (i, e) in c.value.enumerated() {
                                            if e != "" {
                                                let lData = (csv.namedColumns["Reported Date"]![i] , Double(e) ?? 0)
                                                numberArray.append(lData)
                                            }
                                        }
                                        allTheCharts.append(Chart(name: c.key, data: numberArray))
                                    }
                                    DispatchQueue.main.async {
                                        let today = self.parseCSVDay(csv: csv.namedRows.last!)
                                        let yesterday = self.parseCSVDay(csv: csv.namedRows[csv.namedRows.count - 2])
                                        self.today = today
                                        self.yesterday = yesterday
                                        self.highlights = self.generateHighlights(today: today, yesterday: yesterday)
                                        self.daily = dailySummary
                                        self.dataForCharts = allTheCharts
                                    }
                                } catch {
                                    print("Parse error")
                                }
                            }
                        }
                    }
                } else if resource.name == "Daily change in cases by PHU" {

                }
            }
        }
    }

    func parseCSVDay(csv: [String: String]) -> SummaryDay {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let day = SummaryDay(
            ventelator: Int((csv["Number of patients in ICU on a ventilator with COVID-19"]! as NSString).intValue),
            ltcHcwDeaths: Int((csv["Total LTC HCW Deaths"]! as NSString).intValue),
            confimedPositive: Int((csv["Confirmed Positive"]! as NSString).intValue),
            totalLTCResidentDeaths: Int((csv["Total LTC Resident Deaths"]! as NSString).intValue),
            deaths: Int((csv["Deaths"]! as NSString).intValue),
            confirmedNegative: Int((csv["Confirmed Negative"]! as NSString).intValue),
            totalPositiveLTCHCWCases: Int((csv["Total Positive LTC HCW Cases"]! as NSString).intValue),
            totalPositiveLTCResidentCases: Int((csv["Total Positive LTC Resident Cases"]! as NSString).intValue),
            reportedDate: dateFormatter.date(from: csv["Reported Date"]!)!,
            presumptiveNegative: Int((csv["Presumptive Negative"]! as NSString).intValue),
            percentPositiveTestsInLastDay: Int((csv["Percent positive tests in last day"]! as NSString).intValue),
            numberOfPatientsHospitalized: Int((csv["Number of patients hospitalized with COVID-19"]! as NSString).intValue),
            presumptivePositive: Int((csv["Presumptive Positive"]! as NSString).intValue),
            totalTestsCompletedInTheLastDay: Int((csv["Total tests completed in the last day"]! as NSString).intValue),
            totalPatientsApprovedForTestingAsOfReportingDate: Int((csv["Total patients approved for testing as of Reporting Date"]! as NSString).intValue),
            numberOfPatientsInICU: Int((csv["Number of patients in ICU with COVID-19"]! as NSString).intValue),
            totalCases: Int((csv["Total Cases"]! as NSString).intValue),
            underInvestigation: Int((csv["Under Investigation"]! as NSString).intValue),
            resolved: Int((csv["Resolved"]! as NSString).intValue)
        )
        return day
    }

    func generateHighlights(today: SummaryDay, yesterday: SummaryDay) -> [SummaryHighlight] {
        return [
            SummaryHighlight(name: "Total Cases", value: today.totalCases ?? nil, change: ((today.totalCases ?? 0) - (yesterday.totalCases ?? 0))),
            SummaryHighlight(name: "Cases Today", value: today.confimedPositive ?? nil, change: ((today.confimedPositive ?? 0) - (yesterday.confimedPositive ?? 0))),
            SummaryHighlight(name: "Hospitalizations", value: today.numberOfPatientsHospitalized ?? nil, change: ((today.numberOfPatientsHospitalized ?? 0) - (yesterday.numberOfPatientsHospitalized ?? 0))),
            SummaryHighlight(name: "Long Term Care", value: today.totalPositiveLTCResidentCases ?? nil, change: ((today.totalPositiveLTCResidentCases ?? 0) - (yesterday.totalPositiveLTCResidentCases ?? 0))),
            SummaryHighlight(name: "Deaths", value: today.deaths ?? nil, change: ((today.deaths ?? 0) - (yesterday.deaths ?? 0))),
            SummaryHighlight(name: "Resolved", value: today.resolved ?? nil, change: ((today.resolved ?? 0) - (yesterday.resolved ?? 0)))
        ]
    }

    func downloadCSV(with url: URL, complete: @escaping (_ result: Data?, _ error: Error?) -> Void) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            complete(data, error)
        }.resume()
    }
}


