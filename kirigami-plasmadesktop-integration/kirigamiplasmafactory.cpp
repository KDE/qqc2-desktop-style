/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "kirigamiplasmafactory.h"
#include "plasmadesktoptheme.h"
#include "plasmadesktopunits.h"

KirigamiPlasmaFactory::KirigamiPlasmaFactory(QObject *parent)
    : Kirigami::KirigamiPluginFactory(parent)
{
}

KirigamiPlasmaFactory::~KirigamiPlasmaFactory() = default;

Kirigami::PlatformTheme *KirigamiPlasmaFactory::createPlatformTheme(QObject *parent)
{
    Q_ASSERT(parent);
    return new PlasmaDesktopTheme(parent);
}

Kirigami::Units *KirigamiPlasmaFactory::createUnits(QObject *parent)
{
    Q_ASSERT(parent);
    return new PlasmaDesktopUnits(parent);
}

#include "moc_kirigamiplasmafactory.cpp"
