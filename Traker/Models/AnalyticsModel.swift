import Foundation

struct Analytics {
    struct Events {
        static let open = "open"
        static let close = "close"
        static let click = "click"
    }

    struct Screens {
        static let mainScreen = "Main"
        static let appDelegate = "AppDelegate"
        static let category = "CategoriesScreen"
        static let schedule = "ScheduleScreen"
    }

    struct Items {
        static let addTrack = "add_track"
        static let track = "track"
        static let filter = "filter"
        static let edit = "edit"
        static let delete = "delete"
    }
}
