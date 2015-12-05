import QtQuick 2.0
import QtWebKit 3.0

Item {
    id: authControl
    signal authDone
    property string accessToken: ""
    property string userId: ""
    WebView {
        id: webView
        property string _redirectUrl: 'https://oauth.vk.com/blank.html'
        url: 'https://oauth.vk.com/authorize?client_id=5171360&display=mobile'
            + '&redirect_uri=' + _redirectUrl
            + '&scope=friends,groups,audio,wall&response_type=token&v=5.40'
            + '&state=login_succeed'
        anchors.fill: parent
        onNavigationRequested: {
            var url = String(request.url);
            request.action = WebView.AcceptRequest;
            if (url.indexOf(_redirectUrl) === 0) {
                var params = {},
                    paramsUnparsed = url.substring(
                        url.indexOf('#') + 1).split('&');
                for (var i=0; i<paramsUnparsed.length; ++i) {
                    var paramParsed = paramsUnparsed[i].split('=');
                    params[paramParsed[0]] = paramParsed[1];
                }
                if (params['state'] === 'login_succeed') {
                    authControl.accessToken = params['access_token'];
                    authControl.userId = params['user_id'];
                    webView.stop();
                    authDone(params);
                }
            }
        }
    }
}
