<?php

/**
 * フィルター・フック設定
 *
 * @package WordPress
 */

// 直接アクセスを防ぐ
if (!defined('ABSPATH')) {
  exit;
}

/**
 * bodyタグに固定ページのスラッグをクラスとして追加
 *
 * @param array $classes 既存のbodyクラス配列
 * @return array 更新されたbodyクラス配列
 */
function add_slug_to_body_class($classes) {
  if (is_page()) {
    global $post;
    if (isset($post->post_name)) {
      $classes[] = 'page-' . $post->post_name;
    }
  }
  return $classes;
}
add_filter('body_class', 'add_slug_to_body_class');
