import QtQuick 2.0
import "../modules"
Item {
    id: wrapper
    property string userId: ""
    property ListModel model: ListModel{}
    function reload() {
        var request = new XMLHttpRequest;
        model.clear();
        request.open('GET',
            'https://api.vk.com/method/audio.get?&access_token='
                + Settings.accessToken
                + '&owner_id=' + (userId || Settings.currentUserId)
                + '&v=' + Settings.apiVersion);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(request.responseText);
                if (jsonResponse.response && jsonResponse.response.items) {
                    var items = jsonResponse.response.items;
                    for (var i=0; i<items.length; ++i) {
                        model.append(items[i]);
                    }
                }
            }
        }
        request.send();
    }
}
