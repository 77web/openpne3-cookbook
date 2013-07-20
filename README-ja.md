[English version](https://github.com/77web/openpne3-cookbook/blob/master/README.md)

OpenPNE3 Cookbook
=====================

OpenPNEはオープンソースのSNSシステムです。
openpne3-cookbookはOpenPNE3をインストールするcookbookです。

利用可能なOS
---------------------

* Debian, Ubuntu

依存するcookbook
------------------

下記のOpscodeのcookbookを使用します。

* apache2
* database
* git
* mysql
* php

設定可能な項目
-----------------------

* node['openpne']['database_name'] - OpenPNE3をインストールするデータベース名。デフォルトでは"openpne"です。
* node['openpne']['database_user'] - OpenPNE3で使用するデータベースユーザー名。デフォルトでは"openpne"です。
* node['openpne']['database_password'] - データベースのパスワード。デフォルトでは"password"です。
* node['openpne']['database_sock'] - mysqlに接続するためのソケットパス。デフォルトでは空です。
* node['openpne']['database_host'] - mysqlに接続するためのホスト名。デフォルトでは"localhost"です。
* node['openpne']['version'] - インストールするOpenPNE3のバージョン。 公式レポジトリのブランチ名又はタグ名を使用して下さい。: https://github.com/openpne/OpenPNE3 デフォルトでは"stable-3.8.x"です。
* node['openpne']['path'] - OpenPNE3をインストールするパス。デフォルトでは"/var/www/OpenPNE3"です。

php, mysql, apache2のインストールにはOpscodeのクックブックを使用するので、各レシピの設定項目を利用してインストールをカスタマイズすることができます。

使い方
---------

0. クックブックのパスにこのレポジトリをcloneしてください。
1. run_listに"openpne3"を追加するか、別のレシピからinclude_recipe "openpne3"してください。

* 注意 *
openpne3-cookbookは、OpenPNE3の前にphp,mysql,apache2をインストールします。

phpmatsuri
-------------

このopenpne3-cookbookとopenpne3-vagrantはphpmatsuri 2013のハッカソンで作成しました。来年はあなたも参加して何か作ってみませんか？→[phpmatsuri](http://phpmatsuri.net)
