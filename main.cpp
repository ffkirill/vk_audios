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

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:///");
    qmlRegisterSingletonType<AudioGrabber>("org.ffkirill.audiograbber", 1, 0,
                                           "AudioGrabber",
                                           audiograbber_singletontype_provider);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

