/*
 *   Copyright 2017 by Marco Martin <mart@kde.org>

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

#include "qqc2desktopstyleplugin.h"
#include "kquickstyleitem_p.h"

#include <QQmlEngine>
#include <QQmlContext>
#include <QQuickItem>

#ifdef QQC2_BUILD_TYPE_STATIC
 #include <qrc_style.cpp>
#endif

void QQc2DesktopStylePlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.kde.qqc2desktopstyle.private"));

    qmlRegisterType<KQuickStyleItem>(uri, 1, 0, "StyleItem");

#ifdef QQC2_BUILD_TYPE_STATIC
    qmlRegisterType(QStringLiteral("qrc:/org.kde.desktop/priavte/DefaultListItemBackground.qml"), uri, 2, 0, "DefaultListItemBackground");
#endif

    qmlProtectModule(uri, 2);
}

#include "moc_qqc2desktopstyleplugin.cpp"

