/*
    SPDX-FileCopyrightText: 2023 Fushan Wen <qydwhotmail@gmail.com>

    SPDX-License-Identifier: LGPL-2.1-or-later
*/

#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QSignalSpy>
#include <QStandardPaths>
#include <QTest>

#ifdef Q_OS_UNIX
#include <KConfigGroup>
#include <KSharedConfig>
#endif

#ifdef Q_OS_WIN
#include <Windows.h>
#endif

using namespace Qt::StringLiterals;

class IntegrationTest : public QObject
{
    Q_OBJECT

private Q_SLOTS:
    void initTestCase();
    void cleanupTestCase();

#ifdef Q_OS_UNIX
    void testAnimationSpeedModifier_kconfig();
#endif
#ifdef Q_OS_WIN
    void testAnimationSpeedModifier_windows();
#endif

private:
    QQmlApplicationEngine engine;
};

void IntegrationTest::initTestCase()
{
    const QString libraryPath = QLatin1String(qgetenv("CMAKE_BINARY_DIR")) + QDir::separator() + "bin"_L1 + QDir::separator() + "org.kde.desktop"_L1
        + QLatin1String(qgetenv("CMAKE_SHARED_LIBRARY_SUFFIX"));
    QVERIFY2(QFileInfo::exists(libraryPath), qUtf8Printable(libraryPath));
    QDir libraryDir = QFileInfo(libraryPath).dir();
    const QString kirigamiFolder(libraryDir.absolutePath() + QDir::separator() + u"kf6"_s + QDir::separator() + u"kirigami" + QDir::separator()
                                 + u"platform"_s);
    QVERIFY2(libraryDir.mkpath(kirigamiFolder), qUtf8Printable(kirigamiFolder));
    QVERIFY(QFile(libraryPath).copy(kirigamiFolder + QDir::separator() + QFileInfo(libraryPath).fileName()));
    QQuickStyle::setStyle(u"org.kde.desktop"_s);
    QCoreApplication::addLibraryPath(QString::fromLatin1(qgetenv("CMAKE_BINARY_DIR")));

    QStandardPaths::setTestModeEnabled(true);

    QSignalSpy objectCreatedSpy(&engine, &QQmlApplicationEngine::objectCreated);
    engine.load(QFINDTESTDATA(u"animationspeedmodifiertest.qml"_s));
    if (objectCreatedSpy.empty()) {
        QVERIFY(objectCreatedSpy.wait());
    }
    QCOMPARE(engine.rootObjects().size(), 1);
}

void IntegrationTest::cleanupTestCase()
{
}

#ifdef Q_OS_UNIX
void IntegrationTest::testAnimationSpeedModifier_kconfig()
{
    QObject *rootObject = engine.rootObjects().constFirst();
    const double defaultLongDuration = rootObject->property("longDuration").toDouble();
    QSignalSpy longDurationSpy(rootObject, SIGNAL(longDurationChanged()));

    KConfigGroup kdeGroup(KSharedConfig::openConfig(u"kdeglobals"_s, KConfig::SimpleConfig), u"KDE"_s);
    QVERIFY(kdeGroup.isValid());
    kdeGroup.writeEntry("AnimationDurationFactor", 0.5, KConfig::Notify);
    QVERIFY(kdeGroup.sync());

    if (longDurationSpy.empty()) {
        QVERIFY(longDurationSpy.wait());
    }
    QCOMPARE(rootObject->property("longDuration").toDouble(), defaultLongDuration * 0.5);
}
#endif

#ifdef Q_OS_WIN
void IntegrationTest::testAnimationSpeedModifier_windows()
{
    bool isAnimated = true;
    QVERIFY(SystemParametersInfoW(SPI_GETCLIENTAREAANIMATION, 0, &isAnimated, 0));

    QObject *rootObject = engine.rootObjects().constFirst();
    const double defaultLongDuration = rootObject->property("longDuration").toDouble();
    QSignalSpy longDurationSpy(rootObject, SIGNAL(longDurationChanged()));

    if (isAnimated) {
        QVERIFY(defaultLongDuration > 0);
    } else {
        QCOMPARE(defaultLongDuration, 0);
    }
    isAnimated = !isAnimated;
    SystemParametersInfoW(SPI_SETCLIENTAREAANIMATION, 0, &isAnimated, SPIF_SENDCHANGE);
    if (GetLastError() == 1459) {
        return;
    }

    if (longDurationSpy.empty()) {
        QVERIFY(longDurationSpy.wait());
    }

    if (isAnimated) {
        QVERIFY(defaultLongDuration > 0);
    } else {
        QCOMPARE(defaultLongDuration, 0);
    }
}
#endif

QTEST_MAIN(IntegrationTest)

#include "animationspeedmodifiertest.moc"
