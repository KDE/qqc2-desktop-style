/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "qqc2desktopstyleplugin.h"
#include "kpropertywriter_p.h"
#include "kquickstyleitem_p.h"
#include "textrenderer_p.h"

#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickItem>

void QQc2DesktopStylePlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1String(uri) == QLatin1String("org.kde.qqc2desktopstyle.private"));

    qmlRegisterType<KQuickStyleItem>(uri, 1, 0, "StyleItem");
    qmlRegisterType<KPropertyWriter>(uri, 1, 0, "PropertyWriter");
    qmlRegisterAnonymousType<KQuickPadding>(uri, 1);
    qmlRegisterUncreatableType<TextRenderer>(uri, 1, 0, "TextRenderer", QStringLiteral("Use Attached"));
    qmlProtectModule(uri, 2);
}

#include "moc_qqc2desktopstyleplugin.cpp"
