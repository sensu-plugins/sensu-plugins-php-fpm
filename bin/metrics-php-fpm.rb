#!/usr/bin/env ruby
#
# Pull php-fpm metrics from php-fpm status page
# ===
#
# Requires `json` gem to parse json.
#
# Copyright 2014 Ilari Makela ilari at i28.fi
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-plugin/metric/cli'
require 'net/https'
require 'uri'
require 'json'

class PhpfpmMetrics < Sensu::Plugin::Metric::CLI::Graphite
  option :url,
         short: '-u URL',
         long: '--url URL',
         description: 'Full URL to php-fpm status page, example: http://yoursite.com/php-fpm-status'

  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.php_fpm"

  option :agent,
         description: 'User Agent to make the request with',
         short: '-a USERAGENT',
         long: '--agent USERAGENT',
         default: 'Sensu-Agent'

  def run
    found = false
    attempts = 0
    # #YELLOW
    until found || attempts >= 10 # rubocop:disable Style/Next
      attempts += 1
      if config[:url]
        uri = URI.parse(config[:url])
        http = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https'
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        request = Net::HTTP::Get.new(uri.request_uri + '?json&full', 'User-Agent' => "#{config[:agent]}")
        response = http.request(request)
        if response.code == '200'
          found = true
        elsif !response.header['location'].nil?
          config[:url] = response.header['location']
        end
      end
    end # until

    stats = JSON.parse(response.body)
    # overall stats
    stat = %w(start_since
              accepted_conn
              listen_queue
              max_listen_queue
              listen_queue_len
              idle_processes
              active_processes
              total_processes
              max_active_processes
              max_children_reached
              slow_requests)
    stat.each do |name|
      output "#{config[:scheme]}.#{name}", stats[name.gsub(/_/,' ')]
    end
    # get the maxes for the processes
    proc_stat = %w(request_duration
              last_request_cpu
              last_request_memory)
    proc_stat.each do |name|
      stat_name = name.gsub(/_/,' ')
      max = 0
      min = -1
      total = 0
      count = 0
      stats['processes'].each do |proc|
        next unless proc['state'] == 'Idle'
        stat_value = proc[stat_name].to_f
        if max < stat_value
          max = proc[stat_name]
        end
        if min == -1 or min > stat_value
          min = proc[stat_name]
        end
        total += stat_value
        count += 1
      end
      output "#{config[:scheme]}.processes.#{name}.max", max
      output "#{config[:scheme]}.processes.#{name}.min", min
      if count == 0
        output "#{config[:scheme]}.processes.#{name}.avg", 0
      else
        output "#{config[:scheme]}.processes.#{name}.avg", total/count
      end
    end
    ok
  end
end
