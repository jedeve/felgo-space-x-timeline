import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.1


Page {
    title: qsTr("Space X Timeline")

    Image {
        source: "../../assets/stars_sky.png"
        anchors.centerIn: parent
    }

    // JsonListModel
    // A ViewModel for JSON data that offers best integration and performance with list views
    JsonListModel {
        id: listModel
        source: dataModel.launches // show todos from data model
        keyField: "id"
        fields: ["id", "mission_name", "launch_date_utc", "rocket", "launch_site", "flight_number"]
    }

    // show sorted/filterd todos of data model
    AppListView {
        id: listView

        // the model specifies the data for the list view
        model: listModel

        // the delegate is the template item for each entry of the list
        delegate: dataCardComponent
    }

    Component {
        id: "dataCardComponent"
        Item {
            property int indexOfThisDelegate: index

            width: dp(440); height: dp(580)
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: false
                onClicked: { onSelected: page.navigationStack.popAllExceptFirstAndPush(detailPageComponent, { launchId: flight_number, launchName: mission_name })
                }
            }

            Row {
                spacing: -20
                Rectangle {
                    color: "white"
                    width: dp(380)
                    height: dp(540)
                    radius: 10

                    GridLayout {
                        width: parent.width
                        columns: 1

                        Column{
                            Layout.margins: dp(12)
                            Row {
                                spacing: 10
                                Image {
                                    height: 50
                                    source: "../../assets/rocket_icon.png"
                                    fillMode: Image.PreserveAspectFit
                                    anchors.verticalCenter: parent.verticalCenter


                                }
                                Column {
                                    Text {
                                        text: mission_name
                                        font.weight: Font.Bold
                                        font.pixelSize: sp(24)
                                        font.family: "Helvetica"


                                    }
                                    Text {
                                        text: parseDate(launch_date_utc)
                                        font.pixelSize: sp(12)
                                        font.family: "Helvetica"
                                    }

                                }
                            }
                        }
                        Column{
                            Layout.fillWidth: true
                            Rectangle {
                                width: parent.width
                                height: parent.width * (9/16)
                                color: "black"
                            }
                        }

                        Column {
                            Layout.margins: dp(12)

                            GridLayout {
                                columns: 2
                                columnSpacing: dp(100)
                                rowSpacing: dp(20)

                                Column {
                                    Layout.columnSpan: 2
                                    Text {
                                        text: rocket.rocket_name
                                        font.weight: Font.Bold
                                        font.pixelSize: sp(16)
                                        font.family: "Helvetica"
                                    }
                                }
                                Column {
                                    Layout.columnSpan: 2
                                    Text {
                                        text: "Launch Site"
                                        font.weight: Font.Bold
                                        font.pixelSize: sp(16)
                                        font.family: "Helvetica"
                                    }
                                    Text {
                                        text: launch_site.site_name_long
                                        font.pixelSize: sp(12)
                                        font.family: "Helvetica"
                                    }
                                }
                                Column {
                                    Text {
                                        text: "Payload"
                                        font.weight: Font.Bold
                                        font.pixelSize: sp(16)
                                        font.family: "Helvetica"
                                    }
                                    Text {
                                        text: rocket.second_stage.payloads[0].payload_type
                                        font.pixelSize: sp(12)
                                        font.family: "Helvetica"
                                    }
                                }
                                Column {
                                    Text {
                                        text: "Payload Mass"
                                        font.weight: Font.Bold
                                        font.pixelSize: sp(16)
                                        font.family: "Helvetica"
                                    }
                                    Text {
                                        text: rocket.second_stage.payloads[0].payload_mass_kg ? rocket.second_stage.payloads[0].payload_mass_kg + "KG": "unknown"
                                        font.pixelSize: sp(12)
                                        font.family: "Helvetica"
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 100
                    rotation: 45
                    color: "white"
                    width: dp(30)
                    height: dp(30)
                }


            }
            // Timeline on the right side
            Rectangle {
                color: "white"
                width: dp(5)
                height: index === 0 ? dp(150): dp(580)
                anchors.bottom: index === 0 ? parent.bottom: 0
                anchors.right: parent.right


                Rectangle {
                    width: 50
                    height: 50
                    color: "white"
                    border.color: "black"
                    border.width: 3
                    radius: 100
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 145
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        height: 30
                        source: "../../assets/rocket_icon.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter


                    }

                }
            }

        }
    }

    Component {
        id: detailPageComponent
        LaunchDetailPage { }
    }

    function parseDate(date)
    {
        const data = new Date(date)
        return data.toString('YYYY-MM-dd')
    }

}
