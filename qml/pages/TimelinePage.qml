import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4



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
        source: dataModel.launches // show launches from data model
        keyField: "id"
        fields: ["id", "mission_name", "launch_date_utc", "rocket", "launch_site", "flight_number"]
    }

    // show sorted/filterd launches of data model
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
            property bool isLastItem: index === dataModel.launches.length - 1

            width: parent.width - dp(20); height: dp(500)
            // anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: false
                onClicked: !isLastItem ? page.navigationStack.popAllExceptFirstAndPush(detailPageComponent, { launchId: flight_number, launchName: mission_name }): !dataModel.finalResults ? logic.fetchLaunches(null): null
            }


            // Timeline on the right side
            Rectangle {
                visible: !dataModel.finalResults || !isLastItem
                color: "white"
                width: dp(5)
                height: index === 0 ? dp(100): parent.height
                anchors.bottom: parent.bottom
                anchors.right: parent.right


                Rectangle {
                    width: dp(40)
                    height: dp(40)
                    color: "white"
                    border.color: "black"
                    border.width: dp(2)
                    radius: 100
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: dp(75)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        height: 30
                        source: "../../assets/rocket_icon.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent



                    }

                }
            }

            Row {
                spacing: -20
                anchors.fill: parent
                anchors.rightMargin: dp(30)
                Rectangle {
                    color: "white"
                    anchors.fill: parent
                    anchors.margins: dp(20)
                    radius: 10

                    Text {
                        visible: isLastItem
                        anchors.centerIn: parent
                        text: dataModel.finalResults ? "No more results": "Load more"
                        font.weight: Font.Bold
                        font.pixelSize: sp(24)
                        font.family: "Helvetica"


                    }

                    GridLayout {
                        visible: !isLastItem
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
                                        width: parent.width
                                        text: mission_name
                                        font.weight: Font.Bold
                                        font.pixelSize: sp(20)
                                        font.family: "Helvetica"
                                        wrapMode: Text.WordWrap

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
                            width: parent.width
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
                    visible: !dataModel.finalResults || !isLastItem
                    anchors.right: parent.right
                    anchors.rightMargin: dp(10)
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: dp(80)
                    rotation: 45
                    color: "white"
                    width: dp(30)
                    height: dp(30)
                }


            }


        }

    }

    //Filter options
    Item {
        // property bool filtersOpen: false

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: dp(10)

        GridLayout {
            id: filtersItem
            columns: 1
            columnSpacing: dp(50)
            rowSpacing: dp(10)
            visible: opacity != 0
            opacity: 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: dp(8)

             Behavior on opacity {
         NumberAnimation { duration: 100 } // ... animate to reach new value within 500ms
       }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -dp(10)
                color: "white"
                border.color: black
                border.width: dp(0)
                radius: 30
            }

            Column {
                // remove focus from textedit if background is clicked
                MouseArea {
                    anchors.fill: parent
                    onClicked: textEdit.focus = false
                }

                // input
                AppTextInput {
                    id: textEdit
                    width: dp(200)
                    placeholderText: "Search for..."
                }
            }

            Column {
                ComboBox {
                    id: filterComboBox
                    currentIndex: 0
                    model: ListModel {
                        id: cbItems
                        ListElement {
                            text: "Launch Year"; value: "launch_year"
                        }
                        ListElement {
                            text: "Mission Name"; value: "mission_name"
                        }
                        ListElement {
                            text: "Rocket"; value: "rocket_id"
                        }
                        ListElement {
                            text: "Payload"; value: "payload_type"
                        }
                    }
                    width: 250
                }
            }

            AppButton {
                text: "Search"
                flat: false
                onClicked: filterLaunches()
                anchors.bottom: parent.bottom
                anchors.right: parent.right
            }

        }

        // Filter button
        Item {
            width: dp(50)
            height: dp(50)
            Rectangle {
                anchors.fill: parent
                color: "white"
                radius: 100

                Image {
                    source: "../../assets/filter_icon.png"
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit

                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: false
                onClicked: filtersItem.opacity = filtersItem.visible ? 0 : 1
            }
        }

        
    }


    Component {
        id: detailPageComponent
        LaunchDetailPage { }
    }

    Component {
        id: filterSearchComponent
        FilterPage { }
    }

    function parseDate(date)
    {
        const data = new Date(date)
        return data.toString('YYYY-MM-dd')
    }

    function filterLaunches()
    {
        const filter = cbItems.get(filterComboBox.currentIndex).value + ", " + textEdit.text
        logic.fetchLaunches(filter)
        filtersItem.opacity = 0
    }

}
