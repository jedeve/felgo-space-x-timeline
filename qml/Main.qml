import Felgo 3.0
import QtQuick 2.0
import "pages"
import "model"
import "logic"

App {
    // app initialization
    Component.onCompleted: {
        // fetch todo list data
        logic.fetchLaunches(null)
    }

    Navigation {
        id: navigation

        NavigationItem {
            title: qsTr("Timeline")
            icon: IconType.list

            NavigationStack {
                initialPage: TimelinePage { }
            }
        }
    }

    Logic {
        id: logic
    }

    // model
    DataModel {
        id: dataModel
        dispatcher: logic // data model handles actions sent by logic

        // global error handling
        onFetchLaunchesFailed: nativeUtils.displayMessageBox("Unable to load Launches", error, 1)
        onFetchLaunchDetailsFailed: nativeUtils.displayMessageBox("Unable to load launch "+id, error, 1)
    }

}
