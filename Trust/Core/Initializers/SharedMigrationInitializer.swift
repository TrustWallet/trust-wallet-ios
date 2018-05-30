// Copyright SIX DAY LLC. All rights reserved.

import Foundation
import RealmSwift

class SharedMigrationInitializer: Initializer {

    lazy var config: Realm.Configuration = {
        return RealmConfiguration.sharedConfiguration()
    }()

    init() { }

    func perform() {
        config.schemaVersion = 7
        config.migrationBlock = { migration, oldSchemaVersion in
            switch oldSchemaVersion {
            case 4...6:
                migration.deleteData(forType: CoinTicker.className)
            default:
                break
            }
        }
    }
}
