#!/usr/bin/env ruby

## Garmin to Simple Weight Tracker ##
# Takes an export of Garmin Weight, and converts it to the backupfile
# of Simple Weight Tracker
# Log in to Garmin Connect, then go to the following webpage
# https://connect.garmin.com/modern/proxy/weight-service/weight/range/2014-01-01/<put todays date here>

require 'json'
file = File.read('garmin-weight.json')
garmin = JSON.parse(file)
swt = {'settings' => [{'key' => 'goal'}],'version' => 0,'weights' => []}
garmin['dailyWeightSummaries'].each do | blob |
  blob = blob['latestWeight']
  weight = blob['weight'].to_s.delete_suffix('00.0').insert(-2, '.').to_f
  date = blob['samplePk'] > 10000 ? blob['samplePk'] : blob['date']
  swt['weights'] << {
    'weight' => weight,
    'date' => date
  }
end

output = File.open( "swt-backup.json","w" )
output << swt.to_json
output.close
