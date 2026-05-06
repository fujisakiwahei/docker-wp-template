<?php

/**
 * Contact Form 7の設定
 *
 * @package WordPress
 */

// 直接アクセスを防ぐ
if (!defined('ABSPATH')) {
  exit;
}

/**
 * Contact Form 7で自動挿入されるPタグ、brタグを削除
 */
add_filter('wpcf7_autop_or_not', '__return_false');

/**
 * コンタクトフォーム内でのURLをhome_urlで使えるようにする
 *
 * @return string ホームURL
 */
function cf7_home_url_shortcode() {
  return home_url();
}
add_shortcode('home_url', 'cf7_home_url_shortcode');
