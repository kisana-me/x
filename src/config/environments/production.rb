require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.assets.compile = false
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }
  config.active_storage.service = :local
  config.assume_ssl = true
  config.force_ssl = true
  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.logger = Logger.new("log/production.log", "daily")
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]
  config.silence_healthcheck_path = "/up"
  config.cache_store = :mem_cache_store

  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # Enable DNS rebinding protection and other `Host` header attacks.
  config.hosts = [
    "x.amiverse.net"
  ]
  # Cloudflare IP Ranges(https://www.cloudflare.com/ips/)
  config.action_dispatch.trusted_proxies = [
    # IPv6
    IPAddr.new("2400:cb00::/32"),
    IPAddr.new("2606:4700::/32"),
    IPAddr.new("2803:f800::/32"),
    IPAddr.new("2405:b500::/32"),
    IPAddr.new("2405:8100::/32"),
    IPAddr.new("2a06:98c0::/29"),
    IPAddr.new("2c0f:f248::/32"),
    # IPv4
    IPAddr.new("103.21.244.0/22"),
    IPAddr.new("103.22.200.0/22"),
    IPAddr.new("103.31.4.0/22"),
    IPAddr.new("104.16.0.0/13"),
    IPAddr.new("104.24.0.0/14"),
    IPAddr.new("108.162.192.0/18"),
    IPAddr.new("131.0.72.0/22"),
    IPAddr.new("141.101.64.0/18"),
    IPAddr.new("162.158.0.0/15"),
    IPAddr.new("172.64.0.0/13"),
    IPAddr.new("173.245.48.0/20"),
    IPAddr.new("188.114.96.0/20"),
    IPAddr.new("190.93.240.0/20"),
    IPAddr.new("197.234.240.0/22"),
    IPAddr.new("198.41.128.0/17"),
  ]
end
