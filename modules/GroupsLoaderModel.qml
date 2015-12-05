import QtQuick 2.0
import "../modules"
Item {
    id: wrapper
    property string userId: ""
    property int count: 1000
    property int offset: 0
    property bool extended: true
    property var fields: ['name', 'id']
    property var filter: []
    property ListModel model: ListModel{}
    function reload() {
        var request = new XMLHttpRequest;
        model.clear();
        request.open('GET',
            'https://api.vk.com/method/groups.get?'
            + '&access_token=' + Settings.accessToken
            + '&user_id=' + String(userId || Settings.currentUserId)
            + '&extended=' + String(extended? 1 : 0)
            + '&v=' + Settings.apiVersion
        );
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(request.responseText)
                        .response.items;
                for (var i=0; i<jsonResponse.length; ++i) {
                    model.append(jsonResponse[i]);
                }
            }
        }
        request.send();
    }
}
