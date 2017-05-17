<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

/** enable SSL to Azure MySQL */
define('MYSQL_SSL_CA', '/etc/ssl/certs/Baltimore_CyberTrust_Root.pem');

/** The name of the database for WordPress */
define('DB_NAME', getenv('WORDPRESS_DB_NAME'));

/** MySQL database username */
define('DB_USER', getenv('WORDPRESS_DB_USER'));

/** MySQL database password */
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));

/** MySQL hostname */
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'd906bdec6cfddcd9d8f04fd8d31c846213efe91a');
define('SECURE_AUTH_KEY',  '1fe346ad7383bbd20f650b3a4ee54fdd05916c7a');
define('LOGGED_IN_KEY',    '846c675058d59afb856c4c00379d756636c94a8c');
define('NONCE_KEY',        '3738296ce77b993ac79ec31f14311706fabda535');
define('AUTH_SALT',        'bb6aee3fe97329436a4d9d1a4c7bd3a303dfd7e3');
define('SECURE_AUTH_SALT', '778c7c0d69afe590f42548a29cdd9e76ff60171c');
define('LOGGED_IN_SALT',   '590fda991530961594e9a3879be1c207573db2a7');
define('NONCE_SALT',       '538e202a218a7e65c206522c95829820dce88a81');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

// If we're behind a proxy server and using HTTPS, we need to alert Wordpress of that fact
// see also http://codex.wordpress.org/Administration_Over_SSL#Using_a_Reverse_Proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
	$_SERVER['HTTPS'] = 'on';
}

/** Enable x-arr-ssl header support for App Services for Linux */
if (isset($_SERVER['HTTP_X_ARR_SSL'])) {
	$_SERVER['HTTPS'] = 'on';
}

/** Force redirect to SSL */
if($_SERVER['HTTPS'] != 'on' && empty($_SERVER['HTTP_X_ARR_SSL'])){
    $redirect = 'https://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
    header('HTTP/1.1 301 Moved Permanently');
    header('Location: ' . $redirect);
    exit();
}


/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
