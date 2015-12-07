#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "audiograbber.h"

// define the singleton type provider function (callback).
static QObject *audiograbber_singletontype_provider(QQmlEngine *engine,
                                                    QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    AudioGrabber *obj = new AudioGrabber();
    return obj;
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
#ifdef Q_OS_OSX
    // On OS X, correct WebView / QtQuick compositing and stacking requires running
    // Qt in layer-backed mode, which again resuires rendering on the Gui thread.
    qWarning("Setting QT_MAC_WANTS_LAYER=1 and QSG_RENDER_LOOP=basic");
    qputenv("QT_MAC_WANTS_LAYER", "1");
    qputenv("QSG_RENDER_LOOP", "basic");
#endif


    QQmlApplicationEngine engine;

    qmlRegisterSingletonType<AudioGrabber>("org.ffkirill.audiograbber", 1, 0,
                                           "AudioGrabber",
                                           audiograbber_singletontype_provider);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

