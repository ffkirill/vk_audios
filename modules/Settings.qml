pragma Singleton
import QtQml 2.0

QtObject {
    signal authRevoked
    property string accessToken
    property string currentUserId
    property string apiVersion: '5.40'

    function revokeAuth() {
        hasAuth = true;
        authRevoked();
    }
    property bool hasAuth: false
}
