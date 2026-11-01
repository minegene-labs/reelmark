import XCTest

@testable import FilmfoldCore

final class SidebarFilterTests: XCTestCase {

    private typealias Subject = SidebarFilter.Subject

    private let movie = Subject(isEpisode: false, state: .ready)
    private let unmatchedEpisode = Subject(isEpisode: true, season: 1, state: .needsAttention)
    private let severance1 = Subject(
        isEpisode: true, showID: 95396, showName: "Severance", season: 1, state: .inLibrary)
    private let severance2 = Subject(
        isEpisode: true, showID: 95396, showName: "Severance", season: 2, state: .ready)
    private let andor = Subject(
        isEpisode: true, showID: 83867, showName: "Andor", season: 1, state: .lookingUp)

    private var all: [Subject] { [movie, unmatchedEpisode, severance1, severance2, andor] }

    func testKindsSplitMoviesFromEpisodes() {
        XCTAssertTrue(SidebarFilter.movies.includes(movie))
        XCTAssertFalse(SidebarFilter.movies.includes(severance1))
        XCTAssertTrue(SidebarFilter.shows.includes(unmatchedEpisode))
        XCTAssertFalse(SidebarFilter.shows.includes(movie))
    }

    func testShowAndSeasonNeedAMatchedShow() {
        XCTAssertTrue(SidebarFilter.show(id: 95396).includes(severance2))
        XCTAssertFalse(SidebarFilter.show(id: 95396).includes(andor))
        XCTAssertFalse(SidebarFilter.show(id: 95396).includes(unmatchedEpisode))
        XCTAssertTrue(SidebarFilter.season(showID: 95396, season: 1).includes(severance1))
        XCTAssertFalse(SidebarFilter.season(showID: 95396, season: 1).includes(severance2))
    }

    func testStatusesLeaveOutItemsStillBeingLookedUp() {
        XCTAssertEqual(all.filter(SidebarFilter.needsAttention.includes).count, 1)
        XCTAssertEqual(all.filter(SidebarFilter.ready.includes).count, 2)
        XCTAssertEqual(all.filter(SidebarFilter.inLibrary.includes).count, 1)
    }

    func testSummaryCountsEveryEntryTheSameAsItsFilter() {
        let summary = SidebarSummary(all)
        var filters: [SidebarFilter] = [.all, .movies, .shows, .needsAttention, .ready, .inLibrary]
        for show in summary.shows {
            filters.append(.show(id: show.id))
            filters += show.seasons.map { .season(showID: show.id, season: $0) }
        }
        for filter in filters {
            XCTAssertEqual(summary.count(filter), all.filter(filter.includes).count, "\(filter)")
        }
    }

    func testShowsAreSortedByNameWithTheirSeasonsInOrder() {
        let summary = SidebarSummary([severance2, andor, severance1])
        XCTAssertEqual(
            summary.shows,
            [
                SidebarShow(id: 83867, name: "Andor", seasons: [1]),
                SidebarShow(id: 95396, name: "Severance", seasons: [1, 2]),
            ])
    }

    func testAnEmptyListCountsNothing() {
        let summary = SidebarSummary([Subject]())
        XCTAssertEqual(summary.count(.all), 0)
        XCTAssertTrue(summary.shows.isEmpty)
    }
}
