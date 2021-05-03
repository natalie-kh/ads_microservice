# frozen_string_literal: true

namespace :db do
  desc 'Run database migrations'
  task :migrate, %i[version] => :settings do |_t, args|
    require 'sequel/core'
    Sequel.extension :migration

    Sequel.connect(Settings.db.to_hash) do |db|
      db.extension :schema_dumper
      migrations = File.expand_path('../../db/migrations', __dir__)
      version = args.version.to_i if args.version

      Sequel::Migrator.run(db, migrations, target: version)
      File.open('./db/schema.rb', 'w') { |file| file.write(db.dump_schema_migration) }
    end
  end
end
