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
                color: Theme.lightDark(actionBar.backgroundColor,
                                       Theme.light.textColor,
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
                    onAccepted: {
                        audiosSearcher.byArtist = false;
                        tabBar.selectedIndex = tabs.count - 1;
                        audiosSearcher.search(text);
                    }
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

    AudioSearchModel {
        id: audiosSearcher
    }

    Tab {
       title: "My"
       id: myAudiosTab
       PlayListView {
           id: listView
           anchors.fill: parent
           model: ownAudiosLoader.model
           onArtistSearch: searchByArtist(artist)
       }
       function reload() {
           ownAudiosLoader.reload()
       }
    }

    Tab {
        id: groupAudiosTab
        title: "Groups"

        property int selectedGroup
        property bool fromWall

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
                            text: '<a href="#group_own">'
                                  + ((item && item.name) || '') + '</a>'
                            itemLabel {
                                style: 'body1'
                                textFormat: Text.StyledText
                                linkColor: (itemLabel.hoveredLink?
                                                Theme.primaryColor : Qt.darker(Theme.primaryColor))
                                text: '<a href="#search_artist">Wall</a>'
                                onLinkActivated: {
                                    groupAudiosTab.selectedGroup = item.id;
                                    groupAudiosLoader.fromWall = false;
                                    groupAudiosLoader.userId = '-' + item.id;
                                    groupAudiosLoader.reload();
                                }
                            }
                            secondaryItem:  Label {
                                id: artistLink
                                anchors.verticalCenter: parent.verticalCenter
                                textFormat: Text.StyledText
                                linkColor: (artistLink.hoveredLink?
                                                Theme.primaryColor : Qt.darker(Theme.primaryColor))
                                text: '<a href="#search_artist">Wall</a>'
                                onLinkActivated: {
                                    groupAudiosTab.selectedGroup = item.id;
                                    groupAudiosLoader.fromWall = true;
                                    groupAudiosLoader.userId = '-' + item.id;
                                    groupAudiosLoader.reload();
                                }
                            }
                            selected: (
                                item
                                && item.id === groupAudiosTab.selectedGroup)
                                || false
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
                onArtistSearch: searchByArtist(artist)
                model: groupAudiosLoader.model
            }
        }
        function reload() {
            groupsLoader.reload()
        }
    }

    Tab {
        title: "Search"
        id: searchAudiosTab
        PlayListView {
            anchors.fill: parent
            model: audiosSearcher.model
            onArtistSearch: searchByArtist(artist)
        }
        function reload() {}
    }

    onSelectedTabChanged: {
        tabs.getTab(selectedTab).reload()

    }

    function reload() {
        tabs.getTab(selectedTab).reload()
    }

    function searchByArtist(query) {
        audiosSearcher.byArtist = true;
        audiosSearcher.search(query);
        tabBar.selectedIndex = tabs.count - 1;
    }
}
