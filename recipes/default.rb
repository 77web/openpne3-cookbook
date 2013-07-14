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

node['mysql']['server_root_password'] = 'pass'
node['mysql']['server_repl_password'] = 'pass'
node['mysql']['server_debian_password'] = 'pass'

include_recipe 'mysql::client'
include_recipe 'mysql::server'
include_recipe 'database::mysql'
include_recipe 'apache2'
include_recipe 'git'

mysql_connection = ({ :host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password'] })
mysql_database node['openpne']['database_name'] do
    connection mysql_connection
    action :create
end
mysql_database_user node['openpne']['database_user'] do
    connection mysql_connection
    action :create
    password node['openpne']['database_password']
    database_name node['openpne']['database_name']
    privileges [:all]
    action [:create, :grant]
end

node['php']['packages'] = ['php5-cli', 'php5-gd', 'php5-mysql', 'libapache2-mod-php5']
include_recipe 'php'

execute "set date.timezone to 'Asia/Tokyo' in /etc/php5/apache2/php.ini?" do
  user "root"
  not_if "grep 'date.timezone = Asia/Tokyo' /etc/php5/apache2/php.ini"
  command "echo 'date.timezone = Asia/Tokyo' > /etc/php5/apache2/php.ini"
end

execute 'openpne3-prepare' do
    command "cd /var/www; git clone git://github.com/openpne/OpenPNE3; cd OpenPNE3; git checkout #{node['openpne']['version']}; cp config/OpenPNE.yml.sample config/OpenPNE.yml; cp config/ProjectConfiguration.class.php.sample config/ProjectConfiguration.class.php"
end

execute 'openpne3-add-fast-install' do
    command 'cd /var/www/OpenPNE3; wget https://raw.github.com/77web/OpenPNE3/web_installer_proposal_2/lib/task/openpneFastInstallTask.class.php -P lib/task; php symfony openpne:fast-install'
    not_if do ::File.exists?('/var/www/OpenPNE3/lib/task/openpneFastInstallTask.class.php') end
end

execute 'openpne3-install' do
    command "cd /var/www/OpenPNE3; php symfony openpne:fast-install  --dbms=mysql --dbuser=#{node['openpne']['database_user']} --dbpassword=#{node['openpne']['database_password']} --dbname=#{node['openpne']['database_name']} --dbhost=#{node['openpne']['database_host']}"
end

template '/etc/apache2/sites-enabled/openpne.conf' do
    user 'root'
    mode '0644'
    source 'openpne.conf.erb'
    not_if do ::File.exists?('/etc/apache2/sites-enabled/openpne.conf') end
end

service 'apache2' do
    supports :restart => true, :reload => true, :status => true
    action [:enable, :start]
end
