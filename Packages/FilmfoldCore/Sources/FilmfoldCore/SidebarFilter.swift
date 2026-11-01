import Foundation

/// An entry in the window's sidebar, which narrows the list as Finder's
/// sidebar narrows a window: the whole list, one kind, one show or season,
/// or one status.
public enum SidebarFilter: Hashable, Sendable {
    case all, movies, shows
    case show(id: Int)
    case season(showID: Int, season: Int)
    case needsAttention, ready, inLibrary

    public enum State: Sendable {
        case lookingUp, needsAttention, ready, inLibrary
    }

    /// What the sidebar needs to know about one item.
    public struct Subject: Sendable {
        public var isEpisode: Bool
        /// The matched show's TMDB id and name, for an episode that has one.
        public var showID: Int?
        public var showName: String?
        public var season: Int?
        public var state: State

        public init(
            isEpisode: Bool, showID: Int? = nil, showName: String? = nil, season: Int? = nil, state: State
        ) {
            self.isEpisode = isEpisode
            self.showID = showID
            self.showName = showName
            self.season = season
            self.state = state
        }
    }

    public func includes(_ subject: Subject) -> Bool {
        switch self {
        case .all: true
        case .movies: !subject.isEpisode
        case .shows: subject.isEpisode
        case .show(let id): subject.isEpisode && subject.showID == id
        case .season(let id, let season):
            subject.isEpisode && subject.showID == id && subject.season == season
        case .needsAttention: subject.state == .needsAttention
        case .ready: subject.state == .ready
        case .inLibrary: subject.state == .inLibrary
        }
    }
}

/// A matched show in the sidebar, with the seasons of its episodes.
public struct SidebarShow: Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let seasons: [Int]
}

/// The sidebar's entries and their counts, worked out in one pass over the
/// list, so it stays quick with 100,000 items.
public struct SidebarSummary: Equatable, Sendable {
    public private(set) var counts: [SidebarFilter: Int] = [:]
    /// Sorted by name the way Finder sorts, seasons in order.
    public private(set) var shows: [SidebarShow] = []

    public init(_ subjects: some Sequence<SidebarFilter.Subject>) {
        var names: [Int: String] = [:]
        var seasons: [Int: Set<Int>] = [:]
        for subject in subjects {
            var matching: [SidebarFilter] = [.all, subject.isEpisode ? .shows : .movies]
            switch subject.state {
            case .needsAttention: matching.append(.needsAttention)
            case .ready: matching.append(.ready)
            case .inLibrary: matching.append(.inLibrary)
            case .lookingUp: break
            }
            if subject.isEpisode, let id = subject.showID {
                matching.append(.show(id: id))
                names[id] = names[id] ?? subject.showName ?? ""
                if let season = subject.season {
                    matching.append(.season(showID: id, season: season))
                    seasons[id, default: []].insert(season)
                }
            }
            for filter in matching { counts[filter, default: 0] += 1 }
        }
        shows = names.map { id, name in
            SidebarShow(id: id, name: name, seasons: seasons[id, default: []].sorted())
        }
        .sorted {
            switch $0.name.localizedStandardCompare($1.name) {
            case .orderedAscending: true
            case .orderedDescending: false
            case .orderedSame: $0.id < $1.id
            }
        }
    }

    public func count(_ filter: SidebarFilter) -> Int { counts[filter] ?? 0 }
}
