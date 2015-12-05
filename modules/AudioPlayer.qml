pragma Singleton
import QtQuick 2.0
import QtMultimedia 5.5
import org.ffkirill.audiograbber 1.0

QtObject {
    id: wrapper
    property Audio player: Audio {
        id: player
        onPlaybackStateChanged: {
            wrapper.playing = player.playbackState === Audio.PlayingState;

            if (wrapper.playing) {
                AudioGrabber.enqueueUrl(wrapper.url);
            }

            if (player.playbackState === Audio.StoppedState
                && !_stopedByUser
                && model !== null) {
                playNext();
            }
        }
        onSourceChanged: wrapper.url = String(player.source)
        onPositionChanged: {
            var _ratio = Math.floor(player.position / player.duration * 1000);
            if (_ratio >=0 && ratio <=1000) { //avoid progressbar breaking
                ratio = _ratio;
            }
        }
    }
    property bool playing: false
    property bool _stopedByUser: false
    property string url: ""
    property ListModel model: ListModel{}
    property string title: ""
    property string artist: ""
    property int index: 0
    property int ratio: 0

    function playPause(_url, _model, _index) {
        _stopedByUser = true;
        if (String(player.source) === _url
                && player.playbackState === Audio.PlayingState) {
            player.pause()
        } else {
            player.source = _url;
            player.play();
            if (_model) {
                model.clear();
                for (var i=0; i<_model.count; ++i) {
                    model.append(_model.get(i));
                }
            }
            index = _index;
            _stopedByUser = false;
        }
        var item = model.get(_index);
        if (item) {
            artist = item.artist;
            title = item.title;
        }
    }

    function playNext() {
        if (index < model.count - 2) {
            playPause(model.get(index + 1).url, null, index + 1);
        } else {
            _stopedByUser = true;
        }
    }

    function playPrev() {
        if (index > 0 && model.count) {
            playPause(model.get(index - 1).url, null, index - 1);
        }
    }


    function goToRatio(val) {
        player.seek(val * player.duration);
    }

    function enqueueAll() {
        for (var i=0; i<model.count; ++i) {
            AudioGrabber.enqueueUrl(model.get(i).url);
        }
    }

}
