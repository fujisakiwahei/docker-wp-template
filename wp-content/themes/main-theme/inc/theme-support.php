<?php

/**
 * テーマサポート設定
 *
 * @package WordPress
 */

// 直接アクセスを防ぐ
if (!defined('ABSPATH')) {
  exit;
}

/**
 * テーマの基本機能を有効化
 */
// サムネイルを有効化
add_theme_support('post-thumbnails');

// 必要に応じて他のテーマサポート機能を追加
// add_theme_support('title-tag');
// add_theme_support('html5', array('search-form', 'comment-form', 'comment-list', 'gallery', 'caption'));
