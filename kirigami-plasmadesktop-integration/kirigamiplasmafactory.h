/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#ifndef KIRIGAMIPLASMAFACTORY_H
#define KIRIGAMIPLASMAFACTORY_H

#include <Kirigami2/KirigamiPluginFactory>
#include <QObject>

class KirigamiPlasmaFactory : public Kirigami::KirigamiPluginFactoryV2
{
    Q_OBJECT

    Q_PLUGIN_METADATA(IID "org.kde.kirigami.KirigamiPluginFactory" FILE "kirigamiplasmaintegration.json")

    Q_INTERFACES(Kirigami::KirigamiPluginFactory)

public:
    explicit KirigamiPlasmaFactory(QObject *parent = nullptr);
    ~KirigamiPlasmaFactory() override;

    Kirigami::PlatformTheme *createPlatformTheme(QObject *parent) override;
    Kirigami::Units *createUnits(QObject *parent) override;
};

#endif // KIRIGAMIPLASMAFACTORY_H
