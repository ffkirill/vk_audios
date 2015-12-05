import QtQuick 2.0
import QtQuick.Layouts 1.1
import Material 0.1
import Material.ListItems 0.1 as ListItem

import '../modules'

ColumnLayout {
    anchors.fill: parent
    spacing: 0
    RowLayout {
        spacing: Units.dp(2)
        Item {
            height: Units.dp(40)
            width: Units.dp(40)
            ActionButton {
                anchors.centerIn: parent
                height: Units.dp(30)
                width: Units.dp(30)
                elevation: 0
                backgroundColor: 'white'
                iconName: 'av/fast_rewind'
                action: Action {
                    onTriggered: AudioPlayer.playPrev();
                }

           }
        }
        Item {
            height: Units.dp(40)
            width: Units.dp(40)
            ActionButton {
                anchors.centerIn: parent
                height: Units.dp(35)
                width: Units.dp(35)
                elevation: 0
                backgroundColor: 'white'
                iconName: AudioPlayer.playing ? "av/pause" : "av/play_arrow"
                action: Action {
                    onTriggered: AudioPlayer.playPause(AudioPlayer.url,
                                                       AudioPlayer.model,
                                                       AudioPlayer.index);
                }
            }
        }
        Item {
            height: Units.dp(40)
            width: Units.dp(40)
            ActionButton {
                anchors.centerIn: parent
                height: Units.dp(30)
                width: Units.dp(30)
                elevation: 0
                backgroundColor: 'white'
                iconName: 'av/fast_forward'
                action: Action {
                    onTriggered: AudioPlayer.playNext();
                }
           }
        }
        Item {
            height: Units.dp(40)
            width: Units.dp(40)
            ActionButton {
                anchors.centerIn: parent
                height: Units.dp(30)
                width: Units.dp(30)
                elevation: 0
                backgroundColor: 'white'
                iconName: 'file/cloud_download'
                action: Action {
                    onTriggered: AudioPlayer.enqueueAll();
                }
           }
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            ListItem.Subtitled {
                anchors.fill: parent
                text: (AudioPlayer.item && AudioPlayer.item.title) || ''
                subText: (AudioPlayer.item && AudioPlayer.item.artist) || ''
                valueText: Math.floor(
                    Math.floor(AudioPlayer.player.position / 60000)) + ':'
                    + String(
                        '0' +
                        (Math.floor(AudioPlayer.player.position /1000) % 60))
                        .slice(-2);
                maximumLineCount: 2
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignBottom
        height: Units.dp(20)
        ProgressBar {
            anchors.fill: parent
            height: Units.dp(30)
            color: Theme.accentColor
            minimumValue: 0
            maximumValue: 1000
            value: AudioPlayer.ratio
        }
        MouseArea {
            anchors.fill: parent
            onPressed: {
                var percent = mouse.x / width;
                AudioPlayer.goToRatio(percent)
            }
            cursorShape: Qt.PointingHandCursor
        }
    }

}
