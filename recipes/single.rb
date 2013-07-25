#mysql setting
node['mysql']['server_root_password'] = 'pass'
node['mysql']['server_repl_password'] = 'pass'
node['mysql']['server_debian_password'] = 'pass'

include_recipe 'mysql::client'
include_recipe 'mysql::server'
include_recipe 'database::mysql'
include_recipe 'apache2'
include_recipe 'apache2::mod_rewrite'
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

include_recipe "php::#{node['php']['install_method']}"
include_recipe "apache2::mod_php5"

execute "set date.timezone to 'Asia/Tokyo' in #{node['php']['conf_dir']}/php.ini" do
  user "root"
  not_if "grep 'date.timezone = Asia/Tokyo' #{node['php']['conf_dir']}/php.ini"
  command "echo 'date.timezone = Asia/Tokyo' > #{node['php']['conf_dir']}/php.ini"
end

execute 'openpne3-path' do
    command "mkdir #{node['openpne']['path']}"
    not_if do ::File.exists?("#{node['openpne']['path']}") end
end

execute 'openpne3-clone' do
    command "cd #{node['openpne']['path']}; git init; git remote add origin git://github.com/openpne/OpenPNE3; git fetch origin; git checkout #{node['openpne']['version']}"
    not_if do ::File.exists?("#{node['openpne']['path']}/symfony") end
end

execute 'openpne3-copy-OpenPNE.yml' do
    command "cd #{node['openpne']['path']}; cp config/OpenPNE.yml.sample config/OpenPNE.yml"
    not_if do ::File.exists?("#{node['openpne']['path']}/config/OpenPNE.yml") end
end

execute 'openpne3-copy-ProjectConfiguration' do
    command "cd #{node['openpne']['path']}; cp config/ProjectConfiguration.class.php.sample config/ProjectConfiguration.class.php"
    not_if do ::File.exists?("#{node['openpne']['path']}/config/ProjectConfiguration.class.php") end
end

execute 'openpne3-add-fast-install' do
    command "cd #{node['openpne']['path']}; wget https://raw.github.com/77web/OpenPNE3/web_installer_proposal_2/lib/task/openpneFastInstallTask.class.php -P lib/task; php symfony openpne:fast-install"
    not_if do ::File.exists?("#{node['openpne']['path']}/lib/task/openpneFastInstallTask.class.php") end
end

execute 'openpne3-install' do
    command "cd #{node['openpne']['path']}; php symfony openpne:fast-install  --dbms=mysql --dbuser=#{node['openpne']['database_user']} --dbpassword=#{node['openpne']['database_password']} --dbname=#{node['openpne']['database_name']} --dbhost=#{node['openpne']['database_host']}"
end

service 'apache2' do
    supports :restart => true, :reload => true, :status => true
    action [:enable, :start]
end
