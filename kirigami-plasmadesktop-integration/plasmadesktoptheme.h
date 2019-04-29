/*
*   Copyright (C) 2017 by Marco Martin <mart@kde.org>
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU Library General Public License as
*   published by the Free Software Foundation; either version 2, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU Library General Public License for more details
*
*   You should have received a copy of the GNU Library General Public
*   License along with this program; if not, write to the
*   Free Software Foundation, Inc.,
*   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
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

class PlasmaDesktopTheme : public Kirigami::PlatformTheme
{
    Q_OBJECT

    // colors
    Q_PROPERTY(QColor buttonTextColor READ buttonTextColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor buttonBackgroundColor READ buttonBackgroundColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor buttonHoverColor READ buttonHoverColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor buttonFocusColor READ buttonFocusColor NOTIFY colorsChanged)

    Q_PROPERTY(QColor viewTextColor READ viewTextColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor viewBackgroundColor READ viewBackgroundColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor viewHoverColor READ viewHoverColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor viewFocusColor READ viewFocusColor NOTIFY colorsChanged)

public:
    explicit PlasmaDesktopTheme(QObject *parent = nullptr);
    ~PlasmaDesktopTheme() override;

    Q_INVOKABLE QIcon iconFromTheme(const QString &name, const QColor &customColor = Qt::transparent) override;

    void syncColors();

    QColor buttonTextColor() const;
    QColor buttonBackgroundColor() const;
    QColor buttonHoverColor() const;
    QColor buttonFocusColor() const;

    QColor viewTextColor() const;
    QColor viewBackgroundColor() const;
    QColor viewHoverColor() const;
    QColor viewFocusColor() const;

Q_SIGNALS:
    void colorsChanged();

private:
    QWindow *renderWindow();

    QPointer<QQuickItem> m_parentItem;
    QPointer<QWindow> m_window;
    //legacy colors
    QColor m_buttonTextColor;
    QColor m_buttonBackgroundColor;
    QColor m_buttonHoverColor;
    QColor m_buttonFocusColor;
    QColor m_viewTextColor;
    QColor m_viewBackgroundColor;
    QColor m_viewHoverColor;
    QColor m_viewFocusColor;
};


#endif // KIRIGAMIPLASMATHEME_H
