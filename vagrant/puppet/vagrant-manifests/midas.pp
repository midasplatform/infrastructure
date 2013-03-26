

exec { 'apt-get update':
    path => ['/usr/bin'],
}


$midas_git_repo = 'http://public.kitware.com/MIDAS/Midas3.git'
$doc_root = '/var/www'
$midas_dir = 'midas'
$midas_link_path = "${doc_root}/${midas_dir}"
$projects_root = '/projects'
$midas_path = "${projects_root}/${midas_dir}"

file { $projects_root:
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => 755,
}


# todo how to do the os casing in one place?
case $operatingsystem {
  centos: { $imagemagick = 'ImageMagick' }
  ubuntu: { $imagemagick = 'imagemagick' }
  default: { fail('Unrecognized OS') }
}

case $operatingsystem {
  centos: { $apache_user = 'apache' }
  ubuntu: { $apache_user = 'www-data' }
  default: { fail('Unrecognized OS') }
}

package { 'imagemagick':
  name => $imagemagick,
  ensure => installed,
  require => Exec['apt-get update'],
}

package { 'sendmail':
  ensure => installed,
  require => Exec['apt-get update'],
}


class {'apache': }
class {'apache::mod::php': }
#no support yet for mod_rewrite
apache::mod { 'rewrite': }


package { 'php5':
  ensure => installed,
  require => [Package['httpd'], Exec['apt-get update']],
  notify => Service['httpd'],
}
package { 'php5-ldap':
  ensure => installed,
  require => Package['php5'],
  notify => Service['httpd'],
}

package { 'php5-gd':
  ensure => installed,
  require => Package['php5'],
  notify => Service['httpd'],
}

## create a midas specific php configuration file
$phpConfPath = '/etc/php5/apache2/conf.d/midas.ini'
file { $phpConfPath:
  require => Package['php5'],
  ensure => present,
  owner => root, group => root, mode => 444,
  content => "post_max_size = 2047M\nupload_max_filesize = 2047M\nmemory_limit = 128M\nsession.gc_probability = 0",
  notify => Service['httpd'],
}

package { 'git':
  ensure => present,
  require => Exec['apt-get update'],
}


## TODO, think some thoughts about how to update the code of a repo
exec {
  'midas_git_clone':
    path => ['/usr/bin'],
    cwd => $projects_root,
    # creates ensures won't clone if this dir already exists
    creates => "${projects_root}/${midas_dir}",
    command => "git clone ${midas_git_repo} ${midas_dir}",
    require => [ Package['git'], File[$projects_root] ],
}


exec {
  'chown apache_user midas':
    require => Exec['midas_git_clone'],
    path => ['/bin'],
    command => "chown -R ${apache_user}:${apache_user} ${midas_path}",
}

file {
  "${midas_link_path}":
    require => [Package['httpd'], Exec['chown apache_user midas']],
    ensure  => 'link',
    target  => $midas_path,
}

$apache_conf_path = '/etc/apache2'
$sites_available_midas = "${apache_conf_path}/sites-available/midas"
$sites_enabled_midas = "${apache_conf_path}/sites-enabled/midas"
$sites_available_default = "${apache_conf_path}/sites-available/default"
$sites_enabled_default = "${apache_conf_path}/sites-enabled/default"



$midas_site_content = "<Directory /var/www/midas>\nOptions FollowSymLinks\nAllowOverride All\nOrder allow,deny\nallow from all\n</Directory>"
file { "${sites_available_midas}":
  require => Package['httpd'],
  ensure => present,
  owner => root, group => root, mode => 644,
  content => $midas_site_content,
}

file { "${sites_enabled_midas}":
  require => File[$sites_available_midas],
  ensure => 'link',
  target => $sites_available_midas,
  notify => Service['apache2'],
}

file { "${sites_enabled_default}":
  ensure => 'link',
  target => $sites_available_default,
  notify => Service['apache2'],
}





class { 'mysql': }
class { 'mysql::php':
  require => Package['php5'],
  notify => Service['httpd'],
}
class { 'mysql::server': }
mysql::db { 'midas db':
  ensure   => present,
  user     => 'midas',
  password => 'midas',
  host     => 'localhost',
  charset  => 'utf8',
  grant    => ['all'],
}

cron {
  'php_session_cleanup':
    command => "root [ -x /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find /var/lib/php5/ -depth -mindepth 1 -maxdepth 1 -type f -cmin +$(/usr/lib/php5/maxlifetime) ! -execdir fuser -s {} 2>/dev/null \\; -delete",
    user    => root,
    minute  => [09, 39],
}

# TODO
# then install from web
# configure needed modules

