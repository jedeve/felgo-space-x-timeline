import Felgo 3.0
import QtQuick 2.0
import "pages"
import "model"
import "logic"

App {
    // You get free licenseKeys from https: //felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https: //felgo.com/licenseKey>"

    // app initialization
    Component.onCompleted: {
        // if device has network connection, clear cache at startup
        // you'll probably implement a more intelligent cache cleanup for your app
        // e.g. to only clear the items that aren't required regularly
        if(isOnline)
        {
            logic.clearCache()
        }

        // fetch todo list data
        logic.fetchLaunches()
    }

    Navigation {
        id: navigation

        // first tab
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
