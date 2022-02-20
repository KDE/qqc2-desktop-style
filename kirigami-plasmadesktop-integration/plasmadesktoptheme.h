/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#ifndef KIRIGAMIPLASMATHEME_H
#define KIRIGAMIPLASMATHEME_H

#include <Kirigami/PlatformTheme>

#include <KColorScheme>
#include <QColor>
#include <QIcon>
#include <QObject>
#include <QPointer>
#include <QQuickItem>
#include <optional>

class PlasmaDesktopTheme;
class KIconLoader;
class StyleSingleton;

struct Colors {
    QPalette palette;
    KColorScheme selectionScheme;
    KColorScheme scheme;

    bool operator==(const Colors &other) const
    {
        return this == &other || (palette == other.palette && selectionScheme == other.selectionScheme & scheme == other.scheme);
    }
};

class PlasmaDesktopTheme : public Kirigami::PlatformTheme
{
    Q_OBJECT

public:
    explicit PlasmaDesktopTheme(QObject *parent = nullptr);
    ~PlasmaDesktopTheme() override;

    Q_INVOKABLE QIcon iconFromTheme(const QString &name, const QColor &customColor = Qt::transparent) override;

    void syncWindow();
    void syncColors();

protected:
    bool event(QEvent *event) override;

private:
    friend class StyleSingleton;
    QPointer<QWindow> m_window;

    std::optional<Colors> m_lastColors;
};

#endif // KIRIGAMIPLASMATHEME_H
