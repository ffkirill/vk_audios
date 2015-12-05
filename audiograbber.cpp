#include "audiograbber.h"
#include <QFile>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDir>
#include <QStandardPaths>
#include <QDebug>

AudioGrabber::AudioGrabber(QObject *parent) : QObject(parent)
{
    connect(&m_networkManager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(replyFinished(QNetworkReply*)));
    pathToSave = QDir(
        QDir(QStandardPaths::writableLocation(QStandardPaths::MusicLocation))
                .filePath("vk_audios"));
    if (!pathToSave.exists()) {
        pathToSave.mkpath(".");
    }
}

void AudioGrabber::enqueueUrl(const QString &url)
{
    m_networkManager.get(QNetworkRequest(url));
}

void AudioGrabber::replyFinished(QNetworkReply *reply)
{
    QFile file;
    file.setFileName(pathToSave
                     .filePath(reply->request().url().fileName()));
    file.open(QIODevice::WriteOnly);
    if (file.isOpen() && file.isWritable()) {
        file.write(reply->readAll());
        file.close();
    }
}

