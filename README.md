[日本語版はこちら](https://github.com/77web/openpne3-cookbook/blob/master/README-ja.md)

OpenPNE3 Cookbook
=====================

OpenPNE is a social network platform.
With this cookbook, you can install OpenPNE3 easily.

Supported platform
---------------------

* Debian, Ubuntu

Dependency
--------------

Opscode cookbooks listed below are required.

* apache2
* database
* git
* mysql
* php

If you use openpne3::single directory, it will not require any dependent cookbooks.

Attribute parameters
-----------------------

* node['openpne']['database_name'] - Name of database to install OpenPNE3. "openpne" by default.
* node['openpne']['database_user'] - Name of database user for OpenPNE3. "openpne" by default.
* node['openpne']['database_password'] - Password for database_user. "password" by default.
* node['openpne']['database_sock'] - Socket for mysql connection. Empty by default.
* node['openpne']['database_host'] - Host name or ip for mysql connection. "localhost" by default.
* node['openpne']['version'] - OpenPNE3 version to install. Branch or tag for official repository: https://github.com/openpne/OpenPNE3 "stable-3.8.x" by default.
* node['openpne']['path'] - Path to install OpenPNE3. "/var/www/OpenPNE3" by default.

This cookbook uses php, apache2, mysql cookbooks by opscode, you can configure these middlewares by their attributes.

Usage
------

0. Clone this repository into your cookbook directory.
1. Add "openpne3" to run_list, or include_recipe "openpne3" from your recipe.

* ATTENTION *
This recipe will install php, mysql, apache2 before OpenPNE3 installation.
If you have already built up your environment and just want to install OpenPNE3, please use "openpne3::single" recipe.

phpmatsuri
-------------

I made up openpne3-cookbook and openpne3-vagrant during phpmatsuri 2013, a hackathon event in Japan. This is an annual event, why don't you join us next year? For details: [phpmatsuri](http://phpmatsuri.net).
