load Rails.root.join('db', 'seeds.rb')

namespace :db do
  namespace :seed do
    Seeds.methods(false).sort.each do |method_name|
      desc "Seed #{method_name}"
      seed_task = task method_name => :environment do
        Seeds.send(method_name)
      end
    end
  end

  task :seed => :environment do
    Seeds.methods(false).sort.each do |method_name|
      Seeds.send(method_name)
    end
  end
end
