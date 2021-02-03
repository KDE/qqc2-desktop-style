/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#ifndef KIRIGAMIPLASMATHEME_H
#define KIRIGAMIPLASMATHEME_H

#include <Kirigami2/PlatformTheme>
#include <QObject>
#include <QQuickItem>
#include <QColor>
#include <QPointer>
#include <QIcon>

class PlasmaDesktopTheme;
class KIconLoader;
class StyleSingleton;

class PlasmaDesktopTheme : public Kirigami::PlatformTheme
{
    Q_OBJECT

public:
    explicit PlasmaDesktopTheme(QObject *parent = nullptr);
    ~PlasmaDesktopTheme() override;

    Q_INVOKABLE QIcon iconFromTheme(const QString &name, const QColor &customColor = Qt::transparent) override;

    void syncWindow();
    void syncColors();

protected Q_SLOTS:
    void configurationChanged();

private:
    friend class StyleSingleton;
    QPointer<QWindow> m_window;
};

#endif // KIRIGAMIPLASMATHEME_H
