#
# Cookbook Name:: riak-cs
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
bash "install_riak_cs_from_packagecloud" do
  code <<-EOH
  curl -s https://packagecloud.io/install/repositories/basho/riak-cs/script.rpm.sh | bash
  yum install riak-cs-#{node['riak-cs']['major_number']}.#{node['riak-cs']['minor_number']}.#{node['riak-cs']['incremental']}-#{node['riak-cs']['build']}.el7.centos.x86_64 -y
  EOH
  not_if "which riak-cs"
end

template "/etc/riak-cs/riak-cs.conf" do
  source "default/riak-cs.conf.erb"
  owner 'root'
  group 'root'
  mode '0644'
  variables({
    :ip => node['ipaddress'],
    :admin_key => node['riak-cs']['admin_key'],
    :admin_secret => node['riak-cs']['admin_secret'],
    :root_host => node['riak-cs']['root_host']
  })
end


template "/etc/riak-cs/advanced.conf" do
  source "default/advanced.config.erb"
  owner 'root'
  group 'root'
  mode '0644'
end

service "riak" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  only_if "which riak"
end

service "stanchion" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  only_if "which stanchion"
end

service "riak-cs" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  only_if "which riak-cs"
end
