#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include "des_source.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<CMyDES>("qt.DES.component", 1, 0, "MyDES");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
