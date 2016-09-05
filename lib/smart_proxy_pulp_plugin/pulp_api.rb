require 'sinatra'
require 'smart_proxy_pulp_plugin/pulp_client'
require 'smart_proxy_pulp_plugin/disk_usage'
require 'smart_proxy_pulp_plugin/settings'

module PulpProxy
  class Api < Sinatra::Base
    helpers ::Proxy::Helpers

    get "/status" do
      content_type :json
      begin
        result = PulpClient.get("/api/v2/status/")
        return result.body if result.is_a?(Net::HTTPSuccess)
        log_halt result.code, "Pulp server at #{::PulpProxy::Settings.settings.pulp_url} returned an error: '#{result.message}'"
      rescue Errno::ECONNREFUSED => e
        log_halt 503, "Pulp server at #{::PulpProxy::Settings.settings.pulp_url} is not responding"
      rescue SocketError => e
        log_halt 503, "Pulp server '#{URI.parse(::PulpProxy::Settings.settings.pulp_url.to_s).host}' is unknown"
      end
    end

    get '/status/disk_usage' do
      size = (params[:size] && DiskUsage::SIZE.keys.include?(params[:size].to_sym)) ? params[:size].to_sym : :kilobyte
      monitor_dirs = Hash[::PulpProxy::Settings.settings.marshal_dump.select { |key, _| key == :pulp_dir || key == :pulp_content_dir || key == :mongodb_dir }]
      begin
        pulp_disk = DiskUsage.new({:path => monitor_dirs, :size => size})
        pulp_disk.to_json
      rescue ::Proxy::Error::ConfigurationError
        log_halt 500, 'Could not find df command to evaluate disk space'
      end
    end

    get '/status/puppet' do
      content_type :json
      {:puppet_content_dir => ::PulpProxy::Settings.settings.puppet_content_dir}.to_json
    end
  end
end
