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

#ifndef KIRIGAMIPLASMAFACTORY_H
#define KIRIGAMIPLASMAFACTORY_H

#include <Kirigami2/KirigamiPluginFactory>
#include <QObject>

class KirigamiPlasmaFactory : public Kirigami::KirigamiPluginFactory
{
    Q_OBJECT

    Q_PLUGIN_METADATA(IID "org.kde.kirigami.KirigamiPluginFactory" FILE "kirigamiplasmaintegration.json")

    Q_INTERFACES(Kirigami::KirigamiPluginFactory)

public:
    explicit KirigamiPlasmaFactory(QObject *parent = nullptr);
    ~KirigamiPlasmaFactory() override;

    Kirigami::PlatformTheme *createPlatformTheme(QObject *parent) override;
};



#endif // KIRIGAMIPLASMAFACTORY_H
