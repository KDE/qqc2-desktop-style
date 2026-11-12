/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include <KConfigWatcher>
#include <Kirigami/Platform/StyleHints>

#include "kirigamiplasmafactory.h"

#include "plasmadesktoptheme.h"
#include "plasmadesktopunits.h"

class KirigamiStyleHints : public Kirigami::Platform::StyleHints
{
public:
    KirigamiStyleHints(QObject *parent = nullptr)
        : Kirigami::Platform::StyleHints(parent)
        , m_kdeGlobalsWatcher(KConfigWatcher::create(KSharedConfig::openConfig()))
    {
        KConfigGroup generalCfg = KConfigGroup(KSharedConfig::openConfig(), QLatin1String("KDE"));
        setScrollingModifiesControls(generalCfg.readEntry(QLatin1String("ScrollingModifiesControls"), false));

        connect(m_kdeGlobalsWatcher.data(), &KConfigWatcher::configChanged, this, [this](const KConfigGroup &group, const QByteArrayList &names) {
            if (group.name() == QLatin1String("KDE") && names.contains(QByteArray("ScrollingModifiesControls"))) {
                setScrollingModifiesControls(group.readEntry(QLatin1String("ScrollingModifiesControls"), false));
            }
        });
    }

private:
    KConfigWatcher::Ptr m_kdeGlobalsWatcher;
};

KirigamiPlasmaFactory::KirigamiPlasmaFactory(QObject *parent)
    : Kirigami::Platform::PlatformPluginFactory(parent)
{
    Kirigami::Platform::StyleHints::setMakeStyleHintsFunction([](QObject *object) {
        return new KirigamiStyleHints(object);
    });
}

KirigamiPlasmaFactory::~KirigamiPlasmaFactory() = default;

Kirigami::Platform::PlatformTheme *KirigamiPlasmaFactory::createPlatformTheme(QObject *parent)
{
    Q_ASSERT(parent);
    return new PlasmaDesktopTheme(parent);
}

Kirigami::Platform::Units *KirigamiPlasmaFactory::createUnits(QObject *parent)
{
    Q_ASSERT(parent);
    return new PlasmaDesktopUnits(parent);
}

#include "moc_kirigamiplasmafactory.cpp"
