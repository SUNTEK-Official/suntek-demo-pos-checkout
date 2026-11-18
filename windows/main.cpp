#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include "printermanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    QIcon appIcon;
 // SVG ( )
    appIcon.addFile(QStringLiteral("qrc:/printer/images/app_icon.svg"), QSize(), QIcon::Normal, QIcon::Off);
 // ICO ( )
    appIcon.addFile(QStringLiteral("qrc:/printer/images/app_icon.ico"), QSize(), QIcon::Normal, QIcon::Off);
    app.setWindowIcon(appIcon);


    PrinterManager printerManager;

    QQmlApplicationEngine engine;
    
 // QML
    engine.rootContext()->setContextProperty("printerManager", &printerManager);
    
    const QUrl url(QStringLiteral("qrc:/printer/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
