BASE_PATH = '/hubble/app'
CURRENT = File.join(BASE_PATH, 'current')

run_task = "NO_PROGRESS=1 LIMIT_NEW_BLOCKS=250 /usr/bin/nice -n 10 bin/rake :task --silent :output"
abort_task = 'echo "Not running, release is old."'

def log_path( name )
  File.join( BASE_PATH, 'shared/log', name+'.log' )
end

job_type :rake, [
  'cd :path', 'source ~/.env',
  %{ [ $(pwd) = $(readlink "#{CURRENT}") ] && #{run_task} || #{abort_task} }
].join( ' && ' )

every '* * * * *' do
  rake 'sync:cosmos', output: log_path('cosmos-sync')
  rake 'sync:terra', output: log_path('terra-sync')
  rake 'sync:iris', output: log_path('iris-sync')
  rake 'sync:kava', output: log_path('kava-sync')
  rake 'sync:emoney', output: log_path('emoney-sync')
  rake 'tezos:detect_events', output: log_path('tezos')
  rake 'common:alerts:users:instant', output: log_path('alerts')
end

every '*/10 * * * *' do
  rake 'sync:livepeer', output: log_path('livepeer-sync')
  rake 'tezos:cycle_report', output: log_path('tezos')
end

every '5 0 * * *' do
  rake 'common:logs:clean_dailies', output: log_path('clean-logs')
  rake 'common:alerts:users:daily', output: log_path('alerts')
end

every '0 0 * * *' do
  rake 'network_data:cosmos'
  rake 'network_data:terra'
  rake 'network_data:iris'
  rake 'network_data:kava'
  rake 'network_data:emoney'
end
