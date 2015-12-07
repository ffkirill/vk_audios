TEMPLATE = app

QT += qml quick svg

CONFIG += c++11

SOURCES += main.cpp \
    audiograbber.cpp

RESOURCES += qml.qrc

ICON = vk.icns

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

QMAKE_INFO_PLIST = Info.plist

OTHER_FILES += \
    main.qml \
    ui/LoginPage.qml \
    modules/Settings.qml \
    modules/AudioLoaderModel.qml \
    modules/qmldir

DISTFILES += \
    ui/MyAudiosPage.qml \
    modules/Settings.qml \
    modules/AudioLoaderModel.qml \
    modules/AudioPlayer.qml \
    Info.plist \
    ui/PlayerControl.qml \
    modules/PlayListView.qml \
    modules/GroupsLoaderModel.qml \
    modules/AudioSearchModel.qml

HEADERS += \
    audiograbber.h

