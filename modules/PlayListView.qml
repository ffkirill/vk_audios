import QtQuick 2.0
import Material 0.1
import Material.ListItems 0.1 as ListItem
import '../modules'

ListView {
    id: listView
    delegate: ListItem.Subtitled {
        id: listItem
        text: title
        interactive: true
        content: Label {
            id: artistLink
            textFormat: Text.StyledText
            linkColor: (artistLink.hoveredLink?
                            Theme.primaryColor : Qt.darker(Theme.primaryColor))
            text: '<a href="#search_artist"> ' + artist + '</a>'
            onLinkActivated: artistSearch(artist)
        }
        valueText: Math.floor(duration / 60) + ':'
                   + String('0'+(duration % 60)).slice(-2);
        maximumLineCount: 2
        backgroundColor: (
            AudioPlayer.url == url
            && AudioPlayer.playing
        ) ? "white" : "transparent"
        action: ActionButton {
            id: playPauseBtn
            elevation: 0
            backgroundColor: 'white'
            anchors.fill: parent
            iconName: (
                AudioPlayer.url == url
                && AudioPlayer.playing
            ) ? "av/pause" : "av/play_arrow"
            action: Action {
                onTriggered: AudioPlayer.playPause(url,
                                                   listView.model,
                                                   index);
            }
        }
        Component.onCompleted: {
            artistLink.parent.visible = true;

        }
    }
    signal artistSearch(string artist)
}

