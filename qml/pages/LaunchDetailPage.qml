import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQml.Models 2.11

Page {
    id: page
    title: qsTr(launchName)

    // target id
    property int launchId: 0

    property string launchName: ""

    // data property for page
    property var launchData: getAllKeys(dataModel.launchDetails[launchId])

    // load data initially or when id changes
    onLaunchIdChanged: {
        logic.fetchLaunchDetails(launchId)
    }

    JsonListModel {
        id: dataListModel
        source: launchData
    }


    GridView {
        anchors.fill: parent
        anchors.margins: dp(20)
        cellWidth: parent.width / 2 - dp(40); cellHeight: 80

        id: grid

        // the model specifies the data for the list view
        model: dataListModel

        // the delegate is the template item for each entry of the list
        delegate: dataAttributeComponent
    }


    // Loader {
    //     property string objectTitle: "Customer"
    //     property string objectValue: launchData ? launchData.rocket.second_stage.payloads[0].customers[0]: ""
    //     sourceComponent: dataAttributeComponent
    // }
    // Loader {
    //     property string objectTitle: "Nationality"
    //     property string objectValue: launchData ? launchData.rocket.second_stage.payloads[0].nationality: ""
    //     sourceComponent: dataAttributeComponent
    // }
    // Loader {
    //     property string objectTitle: "Manufacturer"
    //     property string objectValue: launchData ? launchData.rocket.second_stage.payloads[0].manufacturer: ""
    //     sourceComponent: dataAttributeComponent
    // }
    // Loader {
    //     property string objectTitle: "Lifespan"
    //     property string objectValue: launchData ? launchData.rocket.second_stage.payloads[0].orbit_params.lifespan_years ?? "Uknown": ""
    //     sourceComponent: dataAttributeComponent
    // }
    // Loader {
    //     property string objectTitle: "Flight Number"
    //     property string objectValue: launchData ? launchData.flight_number: ""
    //     sourceComponent: dataAttributeComponent
    // }
    // Loader {
    //     property string objectTitle: "Re-used"
    //     property string objectValue: launchData ? launchData.rocket.second_stage.payloads[0].reused ? "yes": "no": ""
    //     sourceComponent: dataAttributeComponent
    // }



    Component {
        id: dataAttributeComponent
        Item {
            width: grid.cellWidth; height: grid.cellHeight
            Column {
                // anchors.fill: parent
                Text {
                    text: launchData[index][0]
                    font.weight: Font.Bold
                    font.pixelSize: sp(16)
                    font.family: "Helvetica"
                    wrapMode: Text.WordWrap
                }
                Text {
                    text: launchData[index][1]
                    font.pixelSize: sp(12)
                    font.family: "Helvetica"
                    wrapMode: Text.WordWrap
                }
            }
        }

    }

    function getAllKeys(data)
    {
        const dataObjects = extractKeys(data)
        return dataObjects
    }

    function extractKeys(data)
    {
        let parsedData = []
        const objectData = Object.entries(data)
        objectData.forEach(object => {
        if(!object[1]) return

        if (typeof object[1] === "object")
        {
            parsedData.push(...extractKeys(object[1]))
            return
        }

        let name = `${object[0]}`

        name = name.split("_")
        name = name.join(" ")
        name = name.charAt(0).toUpperCase() + name.slice(1);

        let value = `${object[1]}`
        value = value.replace('false', 'no')
        value = value.replace('true', 'yes')

        parsedData.push([name, value])

    })
    return parsedData
}


}