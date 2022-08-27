import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.1

Page {
    id: page
    title: qsTr(launchName)

    // target id
    property int launchId: 0

    property string launchName: ""

    // data property for page
    property var launchData: dataModel.launchDetails[launchId]

    // load data initially or when id changes
    onLaunchIdChanged: {
        logic.fetchLaunchDetails(launchId)
    }

    GridLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        columns: 2
        columnSpacing: dp(50)
        rowSpacing: dp(50)

        Loader {
            property string objectTitle: "Customer"
            property string objectValue: launchData ? launchData.rocket.second_stage.payloads[0].customers[0]: ""
            sourceComponent: dataAttributeComponent
        }
        Loader {
            property string objectTitle: "Nationality"
            property string objectValue: launchData ? launchData.rocket.second_stage.payloads[0].nationality: ""
            sourceComponent: dataAttributeComponent
        }
        Loader {
            property string objectTitle: "Manufacturer"
            property string objectValue: launchData ? launchData.rocket.second_stage.payloads[0].manufacturer: ""
            sourceComponent: dataAttributeComponent
        }
        Loader {
            property string objectTitle: "Lifespan"
            property string objectValue: launchData ? launchData.rocket.second_stage.payloads[0].orbit_params.lifespan_years ?? "Uknown" : ""
            sourceComponent: dataAttributeComponent
        }
        Loader {
            property string objectTitle: "Flight Number"
            property string objectValue: launchData ? launchData.flight_number: ""
            sourceComponent: dataAttributeComponent
        }
        Loader {
            property string objectTitle: "Re-used"
            property string objectValue: launchData ? launchData.rocket.second_stage.payloads[0].reused ? "yes" : "no" : ""
            sourceComponent: dataAttributeComponent
        }

    }

    Component {
        id: dataAttributeComponent
        Column {
            Text {
                text: objectTitle
                font.weight: Font.Bold
                font.pixelSize: sp(24)
                font.family: "Helvetica"
            }
            Text {
                text: objectValue
                font.pixelSize: sp(20)
                font.family: "Helvetica"
            }
        }

    }
}