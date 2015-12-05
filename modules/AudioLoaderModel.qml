import QtQuick 2.0
import "../modules"
Item {
    id: wrapper
    property string userId: ""
    property bool fromWall: false
    property ListModel model: ListModel{}
    function reload() {
        var request = new XMLHttpRequest;
        model.clear();
        if (!fromWall) {
            request.open('GET',
                'https://api.vk.com/method/audio.get?&access_token='
                    + Settings.accessToken
                    + '&owner_id=' + (userId || Settings.currentUserId)
                    + '&v=' + Settings.apiVersion);
        } else {
            request.open('GET',
                'https://api.vk.com/method/wall.get?&access_token='
                    + Settings.accessToken
                    + '&owner_id=' + (userId || Settings.currentUserId)
                    + '&count=100'
                    + '&v=' + Settings.apiVersion);
        }
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(request.responseText);
                if (jsonResponse.response && jsonResponse.response.items) {
                    var items = jsonResponse.response.items;
                    for (var i=0; i<items.length; ++i) {
                        var item = items[i];
                        if (!fromWall) {
                            model.append(item);
                        } else if (item.attachments) {
                            for (var j=0; j<item.attachments.length; ++j) {
                                if (item.attachments[j].type === 'audio') {
                                    model.append(item.attachments[j].audio);
                                }
                            }

                        }
                    }
                }
            }
        }
        request.send();
    }
}
