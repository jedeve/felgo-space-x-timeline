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

    Flickable {
        anchors.fill: parent
        contentHeight: grid.height
        contentWidth: parent.width
        anchors.margins: dp(20)
        flickableDirection:  Flickable.VerticalFlick

    GridLayout {
        width: parent.width
        columns: 2

        id: grid

        Repeater {
        // the model specifies the data for the list view
        model: dataListModel

        // the delegate is the template item for each entry of the list
        delegate: dataAttributeComponent
        //flow: GridView.FlowTopToBottom
        }
    }
}
    Component {
        id: dataAttributeComponent
        Item {
           Layout.columnSpan: launchData[index][0] === "Details" || isImage(launchData[index][1]) ? 2 : 1
            Layout.fillWidth: true
            implicitHeight: key.implicitHeight + value.implicitHeight + image.implicitHeight + dp(20)

            Column {
                anchors.fill: parent
                Text {
                    visible: !isImage(launchData[index][1])
                    id: key
                    width: parent.width
                    text: launchData[index][0]
                    font.weight: Font.Bold
                    font.pixelSize: sp(16)
                    font.family: "Helvetica"
                    wrapMode: Text.Wrap
                }
                Text {
                    visible: !isImage(launchData[index][1])
                    id: value
                    width: parent.width - dp(40)
                    text: launchData[index][1]
                    font.pixelSize: sp(12)
                    font.family: "Helvetica"
                    wrapMode: Text.Wrap
                }
                Image {
                    id: image
                    visible: isImage(launchData[index][1])
                    width: parent.width - dp(40)
                    source: launchData[index][1]
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

    }

    function getAllKeys(data)
    {
        const dataObjects = extractKeys(data)
        return dataObjects
    }

    function extractKeys(data, keyName)
    {
        let parsedData = []
        const objectData = Object.entries(data)
        objectData.forEach(object => {
        if(!object[1] || !isNaN(object[1])) return

        if (typeof object[1] === "object")
        {
            parsedData.push(...extractKeys(object[1], object[0]))
            return
        }

        let name = `${object[0]}` === "0" ? keyName : `${object[0]}`

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

        function isImage(text) {
            return text.endsWith(".png") || text.endsWith(".jpg")
        }

}
