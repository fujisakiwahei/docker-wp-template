<?php

/**
 * ファビコンの設定
 *
 * @package WordPress
 */

// 直接アクセスを防ぐ
if (!defined('ABSPATH')) {
  exit;
}

/**
 * ファビコンとアップルタッチアイコンを設定
 */
function my_theme_favicons() {
?>
  <link rel="icon" href="<?php echo get_template_directory_uri(); ?>/favicon.ico" sizes="32x32">
  <link rel="apple-touch-icon" href="<?php echo get_template_directory_uri(); ?>/apple-touch-icon.png" sizes="180x180">
<?php
}
add_action('wp_head', 'my_theme_favicons');
