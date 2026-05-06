<?php

/**
 * テーマのメイン functions.php
 *
 * @package WordPress
 */

// 直接アクセスを防ぐ
if (!defined('ABSPATH')) {
  exit;
}

/* ===============================================
 *  機能ファイルの読み込み
 =============================================== */

// スクリプトとスタイルシートの読み込み
require_once get_template_directory() . '/inc/enqueue.php';

// ファビコンの設定
require_once get_template_directory() . '/inc/favicon.php';

// テーマサポート設定
require_once get_template_directory() . '/inc/theme-support.php';

// フィルター・フック設定
require_once get_template_directory() . '/inc/filters.php';

// Contact Form 7の設定
require_once get_template_directory() . '/inc/contact-form.php';
