import QtQuick 2.0
import QtQuick.Layouts 1.1
import Material 0.1
import "ui" as Ui
import "modules"

ApplicationWindow {
    visible: true
    id: ui
    width: Units.dp(480)
    height: Units.dp(425)
    title: "MediaPlayer"

    theme {
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["blue"]["700"]
        accentColor: Palette.colors["red"]["A200"]
        tabHighlightColor: "white"
    }

    initialPage: loginPage

    Page {
        id: loginPage
        title: "Login"
        actionBar {
            hidden: true
        }
        Ui.LoginPage {
            id: loginControl
            anchors.fill: parent
            onAuthDone: {
                Settings.accessToken = loginControl.accessToken;
                Settings.currentUserId = loginControl.userId;
                Settings.hasAuth = true;
                ui.pageStack.push({
                    item:ownAudiosPage,
                    replace: true});
                ownAudiosPage.reload();
            }
        }
    }

    Ui.MyAudiosPage {
        visible: false
        id: ownAudiosPage
    }

    statusBar: View {
        visible: AudioPlayer.url
        elevation: 1
        height: Units.dp(80)
        anchors.right: parent.right
        anchors.left: parent.left
        backgroundColor: Theme.primaryColor
        Ui.PlayerControl {
            id: nowPlay
        }
    }

}

