import QtQuick 2.0
import "../modules"
Item {
    id: wrapper
    property bool autoComplete: false
    property bool byArtist: false
    property int count: 300
    property ListModel model: ListModel{}
    function search(query) {
        var request = new XMLHttpRequest, url='';
        model.clear();
        request.open('GET',
            'https://api.vk.com/method/audio.search?&access_token='
                + Settings.accessToken
                + '&q=' + query
                + '&auto_complete=' + String(autoComplete? 1:0)
                + '&performer_only=' + String(byArtist? 1:0)
                + '&count=' + String(count)
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
