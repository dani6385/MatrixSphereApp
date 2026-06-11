/matixsphere
    /apps
        /admin_app (Flutter)
        /client_app (Flutter)
            /lib
                /screens
                    login_screen.dart
                    test_page.dart
                    voucher_screen.dart
                main.dart
        /shop_app
    /packages
        /shared_assets
            /assets
                /fonts
                /icons
            /lib
                /src
                    /theme_conpfig.dart
            shrared_asset.dart
            pubspeck.yaml
        /shared_core
            /lib
                /mikrotik
                    akses_member.dart
                    akses_qris.dart
                    akses_voucher.dart
                    create_member.dart
                    create_qris.dart
                    create_voucher.dart
                    mikrotik_service.dart
                    monitoring_repository.dart
                /model
                    voucher_model.dart
                /services
                    database_service.dart
                    firebase_auth_service.dart
                    firebase_service.dart
                    firestore_service.dart
                shared_core.dart
            pubspeck.yaml
        /shared_logic
            /lib
            shared_logic.dart
        /shared_services
            /lib
                /di
                    service_locator.dart
                /src
                    /provider
                        app_provider.dart
                        realtime_provider.dart
                    shared_services.dart
                pubspeck.yaml
        /shared_ui
            /lib
                /src
                    /dialog
                        kuota_dialog.dart
                        member_form.dart
                        scanner_dialog.dart
                        trial_dialog.dart
                        voucher_dialog.dart
                    /widgets
                        bottem_navbar.dart
                        qr_scanner.dart
                    ui_service.dart
                shared_ui.dart
            pubspeck.yaml

    Directory: D:\MatrixSphereApp\apps\client_hotspot


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                .dart_tool
d-----        06/06/2026     14.23                .idea
d-----        06/06/2026     14.23                android
d-----        11/06/2026     18.15                build
d-----        06/06/2026     14.23                ios
d-----        11/06/2026     17.49                lib
d-----        06/06/2026     14.23                linux
d-----        06/06/2026     14.23                macos
d-----        06/06/2026     14.23                test
d-----        10/06/2026     00.30                web
d-----        06/06/2026     14.23                windows
-a----        11/06/2026     18.03          11125 .flutter-plugins-dependencies
-a----        06/06/2026     14.23            748 .gitignore
-a----        06/06/2026     14.23           1706 .metadata
-a----        10/06/2026     12.25           1532 analysis_options.yaml
-a----        05/06/2026     16.47             17 assets
-a----        06/06/2026     14.23            859 client_app.iml
-a----        09/06/2026     10.23            547 firebase.json
-a----        05/06/2026     16.47          38020 GEMINI.md
-a----        05/06/2026     16.49           1399 melos_client_app.iml
-a----        11/06/2026     01.11           1399 melos_mikrotik_web.iml
-a----        11/06/2026     18.14          18047 pubspec.lock
-a----        11/06/2026     18.14            540 pubspec.yaml
-a----        11/06/2026     01.10            267 pubspec_overrides.yaml
-a----        05/06/2026     16.47            564 README.md
-a----        06/06/2026     19.04            821 run_git.ps1


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                chrome-device
-a----        11/06/2026     18.14          16485 package_config.json
-a----        11/06/2026     18.14          14767 package_graph.json
-a----        11/06/2026     18.14              6 version


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.16                Default


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                Asset Store
d-----        11/06/2026     18.12                AutofillStrikeDatabase
d-----        11/06/2026     18.16                blob_storage
d-----        11/06/2026     18.12                BudgetDatabase
d-----        11/06/2026     18.12                ClientCertificates
d-----        11/06/2026     18.01                Collections
d-----        11/06/2026     18.12                commerce_subscription_db
d-----        11/06/2026     18.12                discounts_db
d-----        11/06/2026     18.12                discount_infos_db
d-----        11/06/2026     18.01                DualEngine
d-----        11/06/2026     18.01                EdgeCoupons
d-----        11/06/2026     18.01                EdgeEDrop
d-----        11/06/2026     18.01                EdgeHubAppUsage
d-----        11/06/2026     18.01                EdgeJourneys
d-----        11/06/2026     18.01                EdgePushStorageWithConnectTokenAndKey
d-----        11/06/2026     18.01                EdgeWallet
d-----        11/06/2026     18.01                EntityExtraction
d-----        11/06/2026     18.16                Extension Rules
d-----        11/06/2026     18.16                Extension Scripts
d-----        11/06/2026     18.12                Extension State
d-----        11/06/2026     18.01                Feature Engagement Tracker
d-----        11/06/2026     18.01                JumpListIconsRecentWorkspacesV2
d-----        11/06/2026     18.01                Local Extension Settings
d-----        11/06/2026     18.01                Local Storage
d-----        11/06/2026     18.01                Network
d-----        11/06/2026     18.01                Nurturing
d-----        11/06/2026     18.12                optimization_guide_hint_cache_store
d-----        11/06/2026     18.12                parcel_tracking_db
d-----        11/06/2026     18.01                Password_Diagnostics
d-----        11/06/2026     18.12                PersistentOriginTrials
d-----        11/06/2026     18.01                Safe Browsing Network
d-----        11/06/2026     18.01                Segmentation Platform
d-----        11/06/2026     18.12                Session Storage
d-----        11/06/2026     18.16                Sessions
d-----        11/06/2026     18.01                Shared Dictionary
d-----        11/06/2026     18.12                shared_proto_db
d-----        11/06/2026     18.12                Site Characteristics Database
d-----        11/06/2026     18.01                Storage
d-----        11/06/2026     18.01                Sync Data
d-----        11/06/2026     18.01                Sync Extension Settings
d-----        11/06/2026     18.01                Web Applications
d-----        11/06/2026     18.01                WebStorage
d-----        11/06/2026     18.01                Workspaces
-a----        11/06/2026     18.16          90112 Affiliation Database
-a----        11/06/2026     18.16              0 Affiliation Database-journal
-a----        11/06/2026     18.16          21093 arbitration_service_config.json
-a----        11/06/2026     18.16              6 BookmarkMergedSurfaceOrdering
-a----        11/06/2026     18.16          67195 Bookmarks
-a----        11/06/2026     18.16          67195 Bookmarks.bak
-a----        11/06/2026     18.16          28672 BrowsingTopicsSiteData
-a----        11/06/2026     18.16              0 BrowsingTopicsSiteData-journal
-a----        11/06/2026     18.16            414 BrowsingTopicsState
-a----        11/06/2026     18.16          36864 DIPS
-a----        11/06/2026     18.16        1663581 Edge Profile Picture.png
-a----        11/06/2026     18.16              0 ExtensionActivityComp
-a----        11/06/2026     18.16          32768 ExtensionActivityEdge
-a----        11/06/2026     18.16              0 ExtensionActivityEdge-journal
-a----        11/06/2026     18.16          67584 Favicons
-a----        11/06/2026     18.16              0 Favicons-journal
-a----        11/06/2026     18.16           7976 favorites_diagnostic.log
-a----        11/06/2026     18.16          16384 heavy_ad_intervention_opt_out.db
-a----        11/06/2026     18.16              0 heavy_ad_intervention_opt_out.db-journal
-a----        11/06/2026     18.16        6324224 History
-a----        11/06/2026     18.16              0 History-journal
-a----        11/06/2026     18.16         109027 HubApps
-a----        11/06/2026     18.16          28672 HubApps Icons
-a----        11/06/2026     18.16              0 HubApps Icons-journal
-a----        11/06/2026     18.16          45056 load_statistics.db
-a----        11/06/2026     18.16          32768 load_statistics.db-shm
-a----        11/06/2026     18.16          49472 load_statistics.db-wal
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old
-a----        11/06/2026     18.16         225280 Login Data
-a----        11/06/2026     18.16          51200 Login Data For Account
-a----        11/06/2026     18.16              0 Login Data For Account-journal
-a----        11/06/2026     18.16              0 Login Data-journal
-a----        11/06/2026     18.16          53248 Network Action Predictor
-a----        11/06/2026     18.16              0 Network Action Predictor-journal
-a----        11/06/2026     18.16          29968 Preferences
-a----        11/06/2026     18.16             33 PreferredApps
-a----        11/06/2026     18.16            182 README
-a----        11/06/2026     18.16          37144 Secure Preferences
-a----        11/06/2026     18.16          20480 ServerCertificate
-a----        11/06/2026     18.16              0 ServerCertificate-journal
-a----        11/06/2026     18.16          20480 Shortcuts
-a----        11/06/2026     18.16              0 Shortcuts-journal
-a----        11/06/2026     18.16          20480 Top Sites
-a----        11/06/2026     18.16              0 Top Sites-journal
-a----        11/06/2026     18.16            104 trusted_vault.pb
-a----        11/06/2026     18.16          28672 Vpn Tokens
-a----        11/06/2026     18.16              0 Vpn Tokens-journal
-a----        11/06/2026     18.16         559104 Web Data
-a----        11/06/2026     18.16              0 Web Data-journal


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Asset Store


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.12                assets.db


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Asset Store\assets.db


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16         338890 000003.ldb
-a----        11/06/2026     18.01        1036571 000003.log
-a----        11/06/2026     18.16              0 000004.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            464 LOG
-a----        11/06/2026     18.16            399 LOG.old
-a----        11/06/2026     18.16            158 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\AutofillStrikeDatabase


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\blob_storage


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                7871e48a-25aa-4e70-a7fc-d5f6d8465ca7
d-----        11/06/2026     18.16                900c1e67-d805-4758-9cca-80a1f57cc28b
d-----        11/06/2026     18.12                a8b62f04-e0f3-41ba-902c-b87b956949fe


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\BudgetDatabase


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\ClientCertificates


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Collections


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          73728 collectionsSQLite
-a----        11/06/2026     18.16              0 collectionsSQLite-journal


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\commerce_subscription_db


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\discounts_db


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\discount_infos_db


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\DualEngine


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              2 SiteList-Consumer.json
-a----        11/06/2026     18.16              2 SiteList-Enterprise.json


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\EdgeCoupons


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.12                coupons_data.db


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\EdgeCoupons\coupons_data.db


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16            192 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            430 LOG
-a----        11/06/2026     18.16            430 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\EdgeEDrop


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          32768 EdgeEDropSQLite.db
-a----        11/06/2026     18.16              0 EdgeEDropSQLite.db-journal


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\EdgeHubAppUsage


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          81920 EdgeHubAppUsageSQLite.db
-a----        11/06/2026     18.16              0 EdgeHubAppUsageSQLite.db-journal


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\EdgeJourneys


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16         114688 EdgeJourneys.db


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\EdgePushStorageWithConnectTokenA
    ndKey


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16           2116 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            450 LOG
-a----        11/06/2026     18.16            447 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\EntityExtraction


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                EntityExtractionAssetStore.db
-a----        11/06/2026     18.16         131562 domains_config.json


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\EntityExtraction\EntityExtractio
    nAssetStore.db


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16         152025 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            393 LOG
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Extension Rules


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16            342 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            406 LOG
-a----        11/06/2026     18.16            367 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Extension Scripts


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16            342 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            410 LOG
-a----        11/06/2026     18.16            371 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Extension State


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16           1026 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            406 LOG
-a----        11/06/2026     18.16            406 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Feature Engagement Tracker


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.12                AvailabilityDB
d-----        11/06/2026     18.12                EventDB


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Feature Engagement Tracker\Avail
    abilityDB


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Feature Engagement Tracker\Event
    DB


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Local Extension Settings


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.16                jdiccldimpdaibmpdkjnbmckianbfold


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Local Extension Settings\jdiccld
    impdaibmpdkjnbmckianbfold


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            487 LOG
-a----        11/06/2026     18.16            451 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Local Storage


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.12                leveldb


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Local Storage\leveldb


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16             49 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            418 LOG
-a----        11/06/2026     18.16            418 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Network


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          28672 Cookies
-a----        11/06/2026     18.16              0 Cookies-journal
-a----        11/06/2026     18.16          20480 Device Bound Sessions
-a----        11/06/2026     18.16              0 Device Bound Sessions-journal
-a----        11/06/2026     18.16           2126 Network Persistent State
-a----        11/06/2026     18.16              0 NetworkDataMigrated
-a----        11/06/2026     18.16          36864 Reporting and NEL
-a----        11/06/2026     18.16              0 Reporting and NEL-journal
-a----        11/06/2026     18.16              2 SCT Auditing Pending Reports
-a----        11/06/2026     18.16             40 Sdch Dictionaries
-a----        11/06/2026     18.16           1189 TransportSecurity
-a----        11/06/2026     18.16          36864 Trust Tokens
-a----        11/06/2026     18.16              0 Trust Tokens-journal


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Nurturing


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          20480 campaign_history
-a----        11/06/2026     18.16              0 campaign_history-journal


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\optimization_guide_hint_cache_st
    ore


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\parcel_tracking_db


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Password_Diagnostics


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          18415 PMLog_13425649197345737


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\PersistentOriginTrials


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Safe Browsing Network


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 NetworkDataMigrated
-a----        11/06/2026     18.16          20480 Safe Browsing Cookies
-a----        11/06/2026     18.16              0 Safe Browsing Cookies-journal


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Segmentation Platform


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.12                SegmentInfoDB
d-----        11/06/2026     18.12                SignalDB
d-----        11/06/2026     18.12                SignalStorageConfigDB


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Segmentation Platform\SegmentInf
    oDB


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Segmentation Platform\SignalDB


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Segmentation Platform\SignalStor
    ageConfigDB


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16              0 LOG
-a----        11/06/2026     18.16              0 LOG.old


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Session Storage


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16           1146 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            406 LOG
-a----        11/06/2026     18.16            406 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Sessions


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.12           8347 Session_13425649176031332
-a----        11/06/2026     18.16           2901 Session_13425649894943409
-a----        11/06/2026     18.16           2901 Session_13425650120058287
-a----        11/06/2026     18.12           2571 Tabs_13425649272824872
-a----        11/06/2026     18.12           4411 Tabs_13425649895307373
-a----        11/06/2026     18.16           6719 Tabs_13425650120433517


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Shared Dictionary


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                cache
-a----        11/06/2026     18.16          45056 db
-a----        11/06/2026     18.16              0 db-journal


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Shared Dictionary\cache


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                index-dir
-a----        11/06/2026     18.16             24 index


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Shared Dictionary\cache\index-di
    r


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16             48 the-real-index


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\shared_proto_db


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.12                metadata
-a----        11/06/2026     18.16          13637 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            406 LOG
-a----        11/06/2026     18.16            406 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\shared_proto_db\metadata


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16           1060 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            424 LOG
-a----        11/06/2026     18.16            424 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Site Characteristics Database


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          14926 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            431 LOG
-a----        11/06/2026     18.16            434 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Storage


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                ext


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Storage\ext


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                ihmafllikibpmigkcoadcmckbfhibefp


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Storage\ext\ihmafllikibpmigkcoad
    cmckbfhibefp


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                def


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Storage\ext\ihmafllikibpmigkcoad
    cmckbfhibefp\def


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                Local Storage
d-----        11/06/2026     18.01                Network
d-----        11/06/2026     18.16                Session Storage
d-----        11/06/2026     18.01                Shared Dictionary


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Storage\ext\ihmafllikibpmigkcoad
    cmckbfhibefp\def\Local Storage


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.16                leveldb


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Storage\ext\ihmafllikibpmigkcoad
    cmckbfhibefp\def\Local Storage\leveldb


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16             49 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            516 LOG
-a----        11/06/2026     18.16            477 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Storage\ext\ihmafllikibpmigkcoad
    cmckbfhibefp\def\Network


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          20480 Device Bound Sessions
-a----        11/06/2026     18.16              0 Device Bound Sessions-journal
-a----        11/06/2026     18.16            111 Network Persistent State
-a----        11/06/2026     18.16              0 NetworkDataMigrated
-a----        11/06/2026     18.16              2 SCT Auditing Pending Reports
-a----        11/06/2026     18.16             40 Sdch Dictionaries
-a----        11/06/2026     18.16          36864 Trust Tokens
-a----        11/06/2026     18.16              0 Trust Tokens-journal


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Storage\ext\ihmafllikibpmigkcoad
    cmckbfhibefp\def\Session Storage


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16             68 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            504 LOG
-a----        11/06/2026     18.16            465 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Storage\ext\ihmafllikibpmigkcoad
    cmckbfhibefp\def\Shared Dictionary


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                cache
-a----        11/06/2026     18.16          45056 db
-a----        11/06/2026     18.16              0 db-journal


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Storage\ext\ihmafllikibpmigkcoad
    cmckbfhibefp\def\Shared Dictionary\cache


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                index-dir
-a----        11/06/2026     18.16             24 index


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Storage\ext\ihmafllikibpmigkcoad
    cmckbfhibefp\def\Shared Dictionary\cache\index-dir


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16             48 the-real-index


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Sync Data


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.16                LevelDB
d-----        11/06/2026     18.01                Logs
-a----        11/06/2026     18.16           2185 Nigori.bin


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Sync Data\LevelDB


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.12         272576 000003.log
-a----        11/06/2026     18.16          58059 000004.log
-a----        11/06/2026     18.16         155677 000005.ldb
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            571 LOG
-a----        11/06/2026     18.16            410 LOG.old
-a----        11/06/2026     18.16            137 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Sync Data\Logs


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          96751 cv_debug.log
-a----        11/06/2026     18.16          39107 sync_diagnostic.log


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Sync Extension Settings


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.12                jdmmahggnlemcmcoljocaoejjlkjknld
d-----        11/06/2026     18.12                kohfgcgbkjodfcfkcackpagifgbcmimk


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Sync Extension Settings\jdmmahgg
    nlemcmcoljocaoejjlkjknld


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16             36 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            485 LOG
-a----        11/06/2026     18.16            488 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Sync Extension Settings\kohfgcgb
    kjodfcfkcackpagifgbcmimk


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16           1408 000003.log
-a----        11/06/2026     18.16             16 CURRENT
-a----        11/06/2026     18.16              0 LOCK
-a----        11/06/2026     18.16            485 LOG
-a----        11/06/2026     18.16            488 LOG.old
-a----        11/06/2026     18.16             41 MANIFEST-000001


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                Manifest Resources
d-----        11/06/2026     18.01                Temp


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                iclikhibdocjaealakcokkokdhfefmpf
d-----        11/06/2026     18.01                jneocipojkkahfcibhjaiilegofacenn
d-----        11/06/2026     18.01                mdpkiolbdkhdjpekfbkbmhigcaggjagi
d-----        11/06/2026     18.01                meihdkhojhiljhojijnohpgnjgpffcjg
d-----        11/06/2026     18.01                ndpfpfhffbnfffihoobfljfekcfnkflo


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\iclikhibdocjaealakcokkokdhfefmpf


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                Icons
d-----        11/06/2026     18.01                Icons Maskable
d-----        11/06/2026     18.01                Icons Monochrome


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\iclikhibdocjaealakcokkokdhfefmpf\Icons


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16           1766 128.png
-a----        11/06/2026     18.16            295 16.png
-a----        11/06/2026     18.16           2694 192.png
-a----        11/06/2026     18.16           6609 256.png
-a----        11/06/2026     18.16            908 32.png
-a----        11/06/2026     18.16            732 48.png
-a----        11/06/2026     18.16           7727 512.png
-a----        11/06/2026     18.16           1702 64.png
-a----        11/06/2026     18.16           2633 96.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\iclikhibdocjaealakcokkokdhfefmpf\Icons Maskable


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16           3938 192.png
-a----        11/06/2026     18.16          10986 512.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\jneocipojkkahfcibhjaiilegofacenn


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                Icons
d-----        11/06/2026     18.01                Icons Maskable
d-----        11/06/2026     18.01                Icons Monochrome
d-----        11/06/2026     18.01                Trusted Icons


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\jneocipojkkahfcibhjaiilegofacenn\Icons


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          13712 128.png
-a----        11/06/2026     18.16          10345 192.png
-a----        11/06/2026     18.16          28557 256.png
-a----        11/06/2026     18.16           2206 32.png
-a----        11/06/2026     18.16           3634 48.png
-a----        11/06/2026     18.16          28370 512.png
-a----        11/06/2026     18.16           5531 64.png
-a----        11/06/2026     18.16           9422 96.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\jneocipojkkahfcibhjaiilegofacenn\Trusted Icons


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                Icons
d-----        11/06/2026     18.01                Icons Maskable
d-----        11/06/2026     18.01                Icons Monochrome


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\jneocipojkkahfcibhjaiilegofacenn\Trusted Icons\Icons


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          13390 128.png
-a----        11/06/2026     18.16          28557 256.png
-a----        11/06/2026     18.16           2137 32.png
-a----        11/06/2026     18.16           3745 48.png
-a----        11/06/2026     18.16          28370 512.png
-a----        11/06/2026     18.16           5428 64.png
-a----        11/06/2026     18.16           9280 96.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\mdpkiolbdkhdjpekfbkbmhigcaggjagi


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                Icons
d-----        11/06/2026     18.01                Icons Maskable
d-----        11/06/2026     18.01                Icons Monochrome


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\mdpkiolbdkhdjpekfbkbmhigcaggjagi\Icons


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16           3464 128.png
-a----        11/06/2026     18.16            421 16.png
-a----        11/06/2026     18.16            557 24.png
-a----        11/06/2026     18.16           3221 256.png
-a----        11/06/2026     18.16            756 32.png
-a----        11/06/2026     18.16           1022 48.png
-a----        11/06/2026     18.16           1173 64.png
-a----        11/06/2026     18.16           2882 96.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\meihdkhojhiljhojijnohpgnjgpffcjg


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                Icons
d-----        11/06/2026     18.01                Icons Maskable
d-----        11/06/2026     18.01                Icons Monochrome


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\meihdkhojhiljhojijnohpgnjgpffcjg\Icons


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          20981 128.png
-a----        11/06/2026     18.16          14185 144.png
-a----        11/06/2026     18.16          19528 192.png
-a----        11/06/2026     18.16          50400 256.png
-a----        11/06/2026     18.16           2724 32.png
-a----        11/06/2026     18.16           4963 48.png
-a----        11/06/2026     18.16          61920 512.png
-a----        11/06/2026     18.16           7702 64.png
-a----        11/06/2026     18.16          13655 96.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\ndpfpfhffbnfffihoobfljfekcfnkflo


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                Icons
d-----        11/06/2026     18.01                Icons Maskable
d-----        11/06/2026     18.01                Icons Monochrome


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Web Applications\Manifest Resour
    ces\ndpfpfhffbnfffihoobfljfekcfnkflo\Icons


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          20981 128.png
-a----        11/06/2026     18.16          14185 144.png
-a----        11/06/2026     18.16          19528 192.png
-a----        11/06/2026     18.16          50400 256.png
-a----        11/06/2026     18.16           2724 32.png
-a----        11/06/2026     18.16           4963 48.png
-a----        11/06/2026     18.16          61920 512.png
-a----        11/06/2026     18.16           7702 64.png
-a----        11/06/2026     18.16          13655 96.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\WebStorage


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16          40960 QuotaManager
-a----        11/06/2026     18.16              0 QuotaManager-journal


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Workspaces


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.01                Logs


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.dart_tool\chrome-device\Default\Workspaces\Logs


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.16           1866 Workspaces Internals Logs


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.idea


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                libraries
d-----        06/06/2026     14.23                runConfigurations
-a----        06/06/2026     14.23            405 modules.xml
-a----        06/06/2026     14.23           1553 workspace.xml


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.idea\libraries


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        06/06/2026     14.23            926 Dart_SDK.xml
-a----        06/06/2026     14.23            614 KotlinJavaRuntime.xml


    Directory: D:\MatrixSphereApp\apps\client_hotspot\.idea\runConfigurations


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        06/06/2026     14.23            276 main_dart.xml


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        09/06/2026     10.23                app
d-----        05/06/2026     16.47                gradle
-a----        05/06/2026     16.47            267 .gitignore
-a----        09/06/2026     10.23            561 build.gradle.kts
-a----        06/06/2026     14.23           1630 client_app_android.iml
-a----        05/06/2026     16.47            231 gradle.properties
-a----        06/06/2026     14.23           4971 gradlew
-a----        06/06/2026     14.23           2404 gradlew.bat
-a----        05/06/2026     16.49             23 local.properties
-a----        09/06/2026     10.23            945 settings.gradle.kts


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        05/06/2026     16.47                src
-a----        09/06/2026     10.23           1545 build.gradle.kts
-a----        09/06/2026     10.23            789 google-services.json


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        05/06/2026     16.47                debug
d-----        05/06/2026     16.49                main
d-----        05/06/2026     16.47                profile


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\debug


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47            385 AndroidManifest.xml


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        05/06/2026     16.49                java
d-----        05/06/2026     16.47                kotlin
d-----        05/06/2026     16.47                res
-a----        06/06/2026     14.23           2377 AndroidManifest.xml


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\java


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        05/06/2026     16.49                io


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\java\io


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        05/06/2026     16.49                flutter


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\java\io\flutter


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        05/06/2026     16.49                plugins


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\java\io\flutter\plugins


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     13.05           3025 GeneratedPluginRegistrant.java


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\kotlin


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        05/06/2026     16.47                com


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\kotlin\com


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                example


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\kotlin\com\example


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                client_app
d-----        05/06/2026     16.47                myapp


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\kotlin\com\example\client_app


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        06/06/2026     14.23            129 MainActivity.kt


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\kotlin\com\example\myapp


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47            124 MainActivity.kt


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\res


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        05/06/2026     16.47                drawable
d-----        05/06/2026     16.47                drawable-v21
d-----        05/06/2026     16.47                mipmap-hdpi
d-----        05/06/2026     16.47                mipmap-mdpi
d-----        05/06/2026     16.47                mipmap-xhdpi
d-----        05/06/2026     16.47                mipmap-xxhdpi
d-----        05/06/2026     16.47                mipmap-xxxhdpi
d-----        05/06/2026     16.47                values
d-----        05/06/2026     16.47                values-night


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\res\drawable


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47            446 launch_background.xml


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\res\drawable-v21


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47            450 launch_background.xml


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\res\mipmap-hdpi


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47            544 ic_launcher.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\res\mipmap-mdpi


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47            442 ic_launcher.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\res\mipmap-xhdpi


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47            721 ic_launcher.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\res\mipmap-xxhdpi


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47           1031 ic_launcher.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\res\mipmap-xxxhdpi


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47           1443 ic_launcher.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\res\values


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47           1014 styles.xml


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\main\res\values-night


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47           1013 styles.xml


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\app\src\profile


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     13.09            835 AndroidManifest.xml


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\gradle


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                wrapper


    Directory: D:\MatrixSphereApp\apps\client_hotspot\android\gradle\wrapper


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        06/06/2026     14.23          53636 gradle-wrapper.jar
-a----        05/06/2026     16.47            206 gradle-wrapper.properties


    Directory: D:\MatrixSphereApp\apps\client_hotspot\build


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.58                3794fc4ff7dc06227a4e8d6139a265f9
d-----        11/06/2026     18.14                flutter_assets
-a----        11/06/2026     18.15       52535400 0ea6338a9744699c4765127c07d5f7ae.cache.dill.track.dill


    Directory: D:\MatrixSphereApp\apps\client_hotspot\build\3794fc4ff7dc06227a4e8d6139a265f9


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.14             26 gen_dart_plugin_registrant.stamp
-a----        11/06/2026     18.14             26 gen_localizations.stamp
-a----        11/06/2026     17.58             26 _composite.stamp


    Directory: D:\MatrixSphereApp\apps\client_hotspot\build\flutter_assets


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.14                fonts
d-----        11/06/2026     18.14                shaders
-a----        11/06/2026     18.14              2 AssetManifest.bin
-a----        11/06/2026     18.14              6 AssetManifest.bin.json
-a----        11/06/2026     18.14             82 FontManifest.json
-a----        11/06/2026     18.14        1353129 NOTICES


    Directory: D:\MatrixSphereApp\apps\client_hotspot\build\flutter_assets\fonts


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        02/06/2026     14.42        1645184 MaterialIcons-Regular.otf


    Directory: D:\MatrixSphereApp\apps\client_hotspot\build\flutter_assets\shaders


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     18.14           8890 ink_sparkle.frag
-a----        11/06/2026     18.14           6737 stretch_effect.frag


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.33                Flutter
d-----        06/06/2026     14.24                Runner
d-----        06/06/2026     14.23                Runner.xcodeproj
d-----        06/06/2026     14.23                Runner.xcworkspace
d-----        06/06/2026     14.23                RunnerTests
-a----        02/06/2026     15.57            603 .gitignore


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Flutter


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.33                ephemeral
-a----        02/06/2026     15.57            744 AppFrameworkInfo.plist
-a----        02/06/2026     15.57             31 Debug.xcconfig
-a----        11/06/2026     17.33            665 flutter_export_environment.sh
-a----        11/06/2026     17.33            626 Generated.xcconfig
-a----        02/06/2026     15.57             31 Release.xcconfig


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Flutter\ephemeral


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.14                Packages
-a----        11/06/2026     17.33            108 flutter_lldbinit
-a----        11/06/2026     17.33           1276 flutter_lldb_helper.py
-a----        11/06/2026     17.33            476 flutter_native_integration.env


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Flutter\ephemeral\Packages


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.14                .packages
d-----        11/06/2026     17.33                FlutterGeneratedPluginSwiftPackage


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Flutter\ephemeral\Packages\FlutterGeneratedPluginSwiftPackage


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.33                Sources
-a----        11/06/2026     18.14            596 Package.swift


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Flutter\ephemeral\Packages\FlutterGeneratedPluginSwiftPackage
    \Sources


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.33                FlutterGeneratedPluginSwiftPackage


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Flutter\ephemeral\Packages\FlutterGeneratedPluginSwiftPackage
    \Sources\FlutterGeneratedPluginSwiftPackage


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     17.33             38 FlutterGeneratedPluginSwiftPackage.swift


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                Assets.xcassets
d-----        06/06/2026     14.23                Base.lproj
-a----        02/06/2026     15.57            555 AppDelegate.swift
-a----        06/06/2026     14.24            378 GeneratedPluginRegistrant.h
-a----        11/06/2026     13.05           2312 GeneratedPluginRegistrant.m
-a----        06/06/2026     14.23           2288 Info.plist
-a----        02/06/2026     15.57             39 Runner-Bridging-Header.h
-a----        02/06/2026     15.57             82 SceneDelegate.swift


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner\Assets.xcassets


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                AppIcon.appiconset
d-----        06/06/2026     14.23                LaunchImage.imageset


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner\Assets.xcassets\AppIcon.appiconset


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        02/06/2026     15.57           2641 Contents.json
-a----        05/06/2026     18.06          10932 Icon-App-1024x1024@1x.png
-a----        05/06/2026     18.06            295 Icon-App-20x20@1x.png
-a----        05/06/2026     18.06            406 Icon-App-20x20@2x.png
-a----        05/06/2026     18.06            450 Icon-App-20x20@3x.png
-a----        05/06/2026     18.06            282 Icon-App-29x29@1x.png
-a----        05/06/2026     18.06            462 Icon-App-29x29@2x.png
-a----        05/06/2026     18.06            704 Icon-App-29x29@3x.png
-a----        05/06/2026     18.06            406 Icon-App-40x40@1x.png
-a----        05/06/2026     18.06            586 Icon-App-40x40@2x.png
-a----        05/06/2026     18.06            862 Icon-App-40x40@3x.png
-a----        05/06/2026     18.06            862 Icon-App-60x60@2x.png
-a----        05/06/2026     18.06           1674 Icon-App-60x60@3x.png
-a----        05/06/2026     18.06            762 Icon-App-76x76@1x.png
-a----        05/06/2026     18.06           1226 Icon-App-76x76@2x.png
-a----        05/06/2026     18.06           1418 Icon-App-83.5x83.5@2x.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner\Assets.xcassets\LaunchImage.imageset


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        02/06/2026     15.57            414 Contents.json
-a----        05/06/2026     18.06             68 LaunchImage.png
-a----        05/06/2026     18.06             68 LaunchImage@2x.png
-a----        05/06/2026     18.06             68 LaunchImage@3x.png
-a----        02/06/2026     15.57            340 README.md


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner\Base.lproj


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        02/06/2026     15.57           2414 LaunchScreen.storyboard
-a----        02/06/2026     15.57           1631 Main.storyboard


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner.xcodeproj


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                project.xcworkspace
d-----        06/06/2026     14.23                xcshareddata
-a----        06/06/2026     14.23          26258 project.pbxproj


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner.xcodeproj\project.xcworkspace


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                xcshareddata
-a----        02/06/2026     15.57            142 contents.xcworkspacedata


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner.xcodeproj\project.xcworkspace\xcshareddata


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        02/06/2026     15.57            246 IDEWorkspaceChecks.plist
-a----        02/06/2026     15.57            234 WorkspaceSettings.xcsettings


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner.xcodeproj\xcshareddata


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                xcschemes


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner.xcodeproj\xcshareddata\xcschemes


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        06/06/2026     14.23           4836 Runner.xcscheme


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner.xcworkspace


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                xcshareddata
-a----        02/06/2026     15.57            159 contents.xcworkspacedata


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\Runner.xcworkspace\xcshareddata


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        02/06/2026     15.57            246 IDEWorkspaceChecks.plist
-a----        02/06/2026     15.57            234 WorkspaceSettings.xcsettings


    Directory: D:\MatrixSphereApp\apps\client_hotspot\ios\RunnerTests


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        06/06/2026     14.23            297 RunnerTests.swift


    Directory: D:\MatrixSphereApp\apps\client_hotspot\lib


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.33                screens
-a----        11/06/2026     17.02           1477 main.dart
-a----        11/06/2026     16.35           1129 webview_safe.dart


    Directory: D:\MatrixSphereApp\apps\client_hotspot\lib\screens


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        10/06/2026     17.26           2513 dashboard_client.dart
-a----        11/06/2026     18.10           5151 Dashboard_Screen.dart
-a----        05/06/2026     18.02            464 test_page.dart


    Directory: D:\MatrixSphereApp\apps\client_hotspot\linux


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.33                flutter
d-----        06/06/2026     14.23                runner
-a----        02/06/2026     15.57             19 .gitignore
-a----        06/06/2026     14.23           4887 CMakeLists.txt


    Directory: D:\MatrixSphereApp\apps\client_hotspot\linux\flutter


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.03                ephemeral
-a----        02/06/2026     15.57           2903 CMakeLists.txt
-a----        06/06/2026     14.24            761 generated_plugins.cmake
-a----        06/06/2026     14.24            440 generated_plugin_registrant.cc
-a----        06/06/2026     14.24            303 generated_plugin_registrant.h


    Directory: D:\MatrixSphereApp\apps\client_hotspot\linux\flutter\ephemeral


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.03                .plugin_symlinks


    Directory: D:\MatrixSphereApp\apps\client_hotspot\linux\flutter\ephemeral\.plugin_symlinks


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----l        11/06/2026     18.03                device_info_plus
d----l        11/06/2026     18.03                file_selector_linux
d----l        11/06/2026     18.03                image_picker_linux


    Directory: D:\MatrixSphereApp\apps\client_hotspot\linux\runner


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        02/06/2026     15.57           1000 CMakeLists.txt
-a----        02/06/2026     15.57            186 main.cc
-a----        06/06/2026     14.23           5607 my_application.cc
-a----        02/06/2026     15.57            472 my_application.h


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.33                Flutter
d-----        06/06/2026     14.23                Runner
d-----        06/06/2026     14.23                Runner.xcodeproj
d-----        06/06/2026     14.23                Runner.xcworkspace
d-----        06/06/2026     14.23                RunnerTests
-a----        02/06/2026     15.57             96 .gitignore


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Flutter


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.33                ephemeral
-a----        02/06/2026     15.57             49 Flutter-Debug.xcconfig
-a----        02/06/2026     15.57             49 Flutter-Release.xcconfig
-a----        11/06/2026     13.05           1117 GeneratedPluginRegistrant.swift


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Flutter\ephemeral


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.14                Packages
-a----        11/06/2026     17.33            521 Flutter-Generated.xcconfig
-a----        11/06/2026     17.33            629 flutter_export_environment.sh
-a----        11/06/2026     17.33            449 flutter_native_integration.env


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Flutter\ephemeral\Packages


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.14                .packages
d-----        11/06/2026     17.33                FlutterGeneratedPluginSwiftPackage


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Flutter\ephemeral\Packages\FlutterGeneratedPluginSwiftPacka
    ge


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.33                Sources
-a----        11/06/2026     18.14            599 Package.swift


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Flutter\ephemeral\Packages\FlutterGeneratedPluginSwiftPacka
    ge\Sources


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.33                FlutterGeneratedPluginSwiftPackage


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Flutter\ephemeral\Packages\FlutterGeneratedPluginSwiftPacka
    ge\Sources\FlutterGeneratedPluginSwiftPackage


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        11/06/2026     17.33             38 FlutterGeneratedPluginSwiftPackage.swift


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                Assets.xcassets
d-----        06/06/2026     14.23                Base.lproj
d-----        06/06/2026     14.23                Configs
-a----        02/06/2026     15.57            324 AppDelegate.swift
-a----        02/06/2026     15.57            360 DebugProfile.entitlements
-a----        02/06/2026     15.57           1092 Info.plist
-a----        02/06/2026     15.57            403 MainFlutterWindow.swift
-a----        02/06/2026     15.57            248 Release.entitlements


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner\Assets.xcassets


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                AppIcon.appiconset


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner\Assets.xcassets\AppIcon.appiconset


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     18.06         102994 app_icon_1024.png
-a----        05/06/2026     18.06           5680 app_icon_128.png
-a----        05/06/2026     18.06            520 app_icon_16.png
-a----        05/06/2026     18.06          14142 app_icon_256.png
-a----        05/06/2026     18.06           1066 app_icon_32.png
-a----        05/06/2026     18.06          36406 app_icon_512.png
-a----        05/06/2026     18.06           2218 app_icon_64.png
-a----        02/06/2026     15.57           1359 Contents.json


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner\Base.lproj


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        02/06/2026     15.57          24072 MainMenu.xib


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner\Configs


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        06/06/2026     14.23            620 AppInfo.xcconfig
-a----        02/06/2026     15.57             79 Debug.xcconfig
-a----        02/06/2026     15.57             81 Release.xcconfig
-a----        02/06/2026     15.57            593 Warnings.xcconfig


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner.xcodeproj


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                project.xcworkspace
d-----        06/06/2026     14.23                xcshareddata
-a----        06/06/2026     14.23          28609 project.pbxproj


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner.xcodeproj\project.xcworkspace


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                xcshareddata


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner.xcodeproj\project.xcworkspace\xcshareddata


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        02/06/2026     15.57            246 IDEWorkspaceChecks.plist


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner.xcodeproj\xcshareddata


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                xcschemes


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner.xcodeproj\xcshareddata\xcschemes


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        06/06/2026     14.23           4697 Runner.xcscheme


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner.xcworkspace


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                xcshareddata
-a----        02/06/2026     15.57            159 contents.xcworkspacedata


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\Runner.xcworkspace\xcshareddata


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        02/06/2026     15.57            246 IDEWorkspaceChecks.plist


    Directory: D:\MatrixSphereApp\apps\client_hotspot\macos\RunnerTests


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        06/06/2026     14.23            302 RunnerTests.swift


    Directory: D:\MatrixSphereApp\apps\client_hotspot\test


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        09/06/2026     11.37           1870 widget_test.dart


    Directory: D:\MatrixSphereApp\apps\client_hotspot\web


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        05/06/2026     16.47                icons
-a----        05/06/2026     16.47            917 favicon.png
-a----        05/06/2026     16.47            941 manifest.json


    Directory: D:\MatrixSphereApp\apps\client_hotspot\web\icons


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     16.47           5292 Icon-192.png
-a----        05/06/2026     16.47           8252 Icon-512.png
-a----        05/06/2026     16.47           5594 Icon-maskable-192.png
-a----        05/06/2026     16.47          20998 Icon-maskable-512.png


    Directory: D:\MatrixSphereApp\apps\client_hotspot\windows


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     17.33                flutter
d-----        06/06/2026     14.23                runner
-a----        02/06/2026     15.57            308 .gitignore
-a----        06/06/2026     14.23           4264 CMakeLists.txt


    Directory: D:\MatrixSphereApp\apps\client_hotspot\windows\flutter


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.03                ephemeral
-a----        02/06/2026     15.57           3851 CMakeLists.txt
-a----        06/06/2026     14.24            817 generated_plugins.cmake
-a----        06/06/2026     14.24            837 generated_plugin_registrant.cc
-a----        06/06/2026     14.24            302 generated_plugin_registrant.h


    Directory: D:\MatrixSphereApp\apps\client_hotspot\windows\flutter\ephemeral


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        11/06/2026     18.03                .plugin_symlinks


    Directory: D:\MatrixSphereApp\apps\client_hotspot\windows\flutter\ephemeral\.plugin_symlinks


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----l        11/06/2026     18.03                cloud_firestore
d----l        11/06/2026     18.03                device_info_plus
d----l        11/06/2026     18.03                file_selector_windows
d----l        11/06/2026     18.03                firebase_auth
d----l        11/06/2026     18.03                firebase_core
d----l        11/06/2026     18.03                image_picker_windows


    Directory: D:\MatrixSphereApp\apps\client_hotspot\windows\runner


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        06/06/2026     14.23                resources
-a----        02/06/2026     15.57           1836 CMakeLists.txt
-a----        02/06/2026     15.57           2193 flutter_window.cpp
-a----        02/06/2026     15.57            961 flutter_window.h
-a----        06/06/2026     14.23           1306 main.cpp
-a----        02/06/2026     15.57            448 resource.h
-a----        02/06/2026     15.57            616 runner.exe.manifest
-a----        06/06/2026     14.23           3158 Runner.rc
-a----        02/06/2026     15.57           2237 utils.cpp
-a----        02/06/2026     15.57            691 utils.h
-a----        02/06/2026     15.57           8822 win32_window.cpp
-a----        02/06/2026     15.57           3624 win32_window.h


    Directory: D:\MatrixSphereApp\apps\client_hotspot\windows\runner\resources


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/06/2026     18.06          33772 app_icon.ico


PS D:\MatrixSphereApp\apps\client_hotspot>