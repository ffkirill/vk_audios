import QtQuick 2.0
import Material 0.1
import Material.ListItems 0.1 as ListItem
import '../modules'


TabbedPage {
    id: wrapper
    title: 'VK Audios'
    property alias query: queryTextField.text
    actionBar {
        customContent: Item {
            anchors.fill: parent
            anchors.topMargin: Units.dp(20)
            Label {
                id: titleLabel
                style: "title"
                text: "VK Audios"
                anchors.left: parent.left
                anchors.top: parent.top
                color: Theme.lightDark(actionBar.backgroundColor, Theme.light.textColor,
                                                                    Theme.dark.textColor)
                elide: Text.ElideRight

            }
            Item {
                anchors.right: parent.right
                anchors.top: parent.top
                width: Units.dp(190)
                height: Units.dp(28)

                Rectangle {
                    color: Theme.backgroundColor
                    anchors.fill: parent
                    radius: 2
                }

                TextField {
                    id: queryTextField
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Units.dp(4)
                    placeholderText: "Search..."
                }
            }
        }
    }
    AudioLoaderModel {
        id: ownAudiosLoader
    }

    GroupsLoaderModel {
        id: groupsLoader
    }

    AudioLoaderModel {
        id: groupAudiosLoader
        userId: '-' + groupAudiosTab.selectedGroup
    }

    Tab {
       title: "My"
       id: myAudiosTab
       PlayListView {
           id: listView
           anchors.fill: parent
           model: ownAudiosLoader.model
           onArtistSearch: console.log(artist)
       }
       function reload() {
           ownAudiosLoader.reload()
       }
    }
    Tab {
        id: groupAudiosTab
        title: "Groups"

        property int selectedGroup

        Item {
            id: groupAudiosTabWrapped
            anchors.fill: parent

            Sidebar {
                id: sidebar
                expanded: true
                mode: 'left'
                Column {
                    width: parent.width
                    Repeater {
                        model: groupsLoader.model
                        delegate: ListItem.Standard {
                            property var item: groupsLoader.model.get(index)
                            text: (item && item.name) || ''
                            selected: (
                                item
                                && item.id === groupAudiosTab.selectedGroup)
                                || false
                            onClicked: {
                                groupAudiosTab.selectedGroup = item.id;
                                groupAudiosLoader.userId = '-' + item.id;
                                groupAudiosLoader.reload();
                            }
                            action: Image {
                                source: (item && item.photo_50) || '';
                            }
                        }

                    }
                }
            }

            PlayListView {
                anchors {
                    left: sidebar.right
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                model: groupAudiosLoader.model
            }
        }
        function reload() {
            groupsLoader.reload()
        }


    }
    Tab {
       title: "Friends"
       Rectangle { color: "green" }
       function reload() {

       }

    }
    Tab {
       title: "Search"
       Rectangle { color: "green" }
       function reload() {

       }

    }

    onSelectedTabChanged: {
        tabs.getTab(selectedTab).reload()

    }

    function reload() {
        tabs.getTab(selectedTab).reload()
    }
}
