# Run apt-get update to create the stamp file.
execute "apt-get-update" do
    command "apt-get update"
    ignore_failure true
    not_if do ::File.exists?('/var/lib/apt/periodic/update-success-stamp') end
end

# For other recipes to call to force an update.
execute "apt-get update" do
    command "apt-get update"
    ignore_failure true
    action :nothing
end

# Provides /var/lib/apt/periodic/update-success-stamp on apt-get update.
package "update-notifier-common" do
    notifies :run, resources(:execute => "apt-get-update"), :immediately
end

execute "apt-get-update-periodic" do
    command "apt-get update"
    ignore_failure true
    only_if do
        File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
    end
end

#php packages for debian
node['php']['packages'] = ['php5-cli', 'php5-gd', 'php5-mysql']

include_recipe 'openpne3::common'

template '/etc/apache2/sites-enabled/openpne.conf' do
    user 'root'
    mode '0644'
    source 'openpne.conf.erb'
    not_if do ::File.exists?('/etc/apache2/sites-enabled/openpne.conf') end
end
