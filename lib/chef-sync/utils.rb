require 'json'

module Chef::Sync::Utils
  def self.node_list(environment)
    exec_knife_node_list.split
  end

  def self.public_hostnames_by_role(role, environment)
    results = JSON.parse(exec_knife_node_search(role, environment))
    hostnames = Array(results['rows']).map {|node| node['ec2']['public_hostname'] }
    hostnames.sort
  end

  def self.update_stages_from_chef(stages_hash, synchronized_roles, &block)
    stages_hash.keys.each do |environment|
      synchronized_roles.each do |chef_role, cap_roles|
        cap_roles = Array(cap_roles)
        yield(cap_roles.join(' '), environment) if block_given?

        chef_server_list = public_hostnames_by_role(chef_role, environment).sort
        cap_roles.each {|cap_role| stages_hash[environment]['roles'][cap_role.to_s] = chef_server_list }
      end
    end
  end

  def self.update_mongo_from_chef(mongo_hash)
    excluded_keys = %w(defaults test development)
    (mongo_hash.keys - excluded_keys).each do |environment|
      chef_server_list = public_hostnames_by_role('mongo', environment)

      yield(environment) if block_given?

      mongo_hash[environment]['hosts'] = chef_server_list.map do |hostname|
        ["#{hostname}:27017"]
      end if chef_server_list.any?
    end
  end

private
  def self.exec_knife_node_search(role, environment)
    `knife search node 'role:#{ role } AND chef_environment:#{ environment }' -a ec2 -Fj`
  end

  def self.exec_knife_node_list(environment)
    `knife node list -E #{environment}`
  end
end