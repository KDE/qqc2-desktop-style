/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include <KConfigWatcher>
#include <Kirigami/Platform/StyleHints>

#include "kirigamiplasmafactory.h"

#include "plasmadesktoptheme.h"
#include "plasmadesktopunits.h"

using namespace Qt::StringLiterals;

class KirigamiStyleHints : public Kirigami::Platform::StyleHints
{
public:
    KirigamiStyleHints(QObject *parent = nullptr)
        : Kirigami::Platform::StyleHints(parent)
        , m_kdeGlobalsWatcher(KConfigWatcher::create(KSharedConfig::openConfig()))
    {
        KConfigGroup generalCfg = KConfigGroup(KSharedConfig::openConfig(), "KDE"_L1);
        setScrollingModifiesControls(generalCfg.readEntry("ScrollingModifiesControls"_L1, false));

        connect(m_kdeGlobalsWatcher.data(), &KConfigWatcher::configChanged, this, [this](const KConfigGroup &group, const QByteArrayList &names) {
            if (group.name() == "KDE"_L1 && names.contains("ScrollingModifiesControls"_ba)) {
                setScrollingModifiesControls(group.readEntry("ScrollingModifiesControls"_L1, false));
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
