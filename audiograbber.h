#ifndef AUDIOGRABBER_H
#define AUDIOGRABBER_H

#include <QObject>
#include <QNetworkAccessManager>

class AudioGrabber : public QObject
{
    Q_OBJECT
public:
    explicit AudioGrabber(QObject *parent = 0);
    Q_INVOKABLE void enqueueUrl(const QString &url);
signals:

public slots:
private:
    QNetworkAccessManager m_networkManager;
private slots:
    void replyFinished(QNetworkReply *reply);
};

#endif // AUDIOGRABBER_H
