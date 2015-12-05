#include "audiograbber.h"
#include <QFile>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDir>
#include <QDebug>

AudioGrabber::AudioGrabber(QObject *parent) : QObject(parent)
{
    connect(&m_networkManager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(replyFinished(QNetworkReply*)));
}

void AudioGrabber::enqueueUrl(const QString &url)
{
    m_networkManager.get(QNetworkRequest(url));
}

void AudioGrabber::replyFinished(QNetworkReply *reply)
{
    QFile file;
    file.setFileName(QDir("/Users/ffkirill/Music/vk_saved")
                     .filePath(reply->request().url().fileName()));
    file.open(QIODevice::WriteOnly);
    if (file.isOpen() && file.isWritable()) {
        file.write(reply->readAll());
        file.close();
        qDebug() << reply->request().url().fileName() << " succeed";
    }
}

