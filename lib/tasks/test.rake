task test: :environment do
  Rake::Task['parallel:spec'].invoke
end
