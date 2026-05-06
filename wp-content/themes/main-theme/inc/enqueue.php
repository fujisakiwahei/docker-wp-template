<?php

/**
 * スクリプトとスタイルシートの読み込み
 *
 * @package WordPress
 */

// 直接アクセスを防ぐ
if (!defined('ABSPATH')) {
  exit;
}

/**
 * テーマのスクリプトとスタイルを読み込む
 */
function my_theme_scripts() {
  // Google Fonts
  wp_enqueue_style('googleIcons', "https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200");
  wp_enqueue_style('googleFonts', "https://fonts.googleapis.com/css2?family=Noto+Serif+JP:wght@200..900&display=swap");
  wp_enqueue_style('googleFonts2', "https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@100..900&family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap");

  // Swiper（スタイルとスクリプト）
  wp_enqueue_style('swiperStyle', "https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css");
  wp_enqueue_script('swiperScript', "https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js", array(), null, true);

  // assets
  wp_enqueue_style("mainStyle", get_theme_file_uri('/style.css'));
  wp_enqueue_script("mainJs", get_theme_file_uri('/assets/js/main.js'), array(), null, true);
  wp_enqueue_script("swiperJs", get_theme_file_uri('/assets/js/swiper.js'), array('swiperScript'), null, true);

  // GSAP
  // GSAP本体
  wp_enqueue_script(
    'gsap',
    'https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js',
    array(),
    '3.12.2',
    true
  );
}

add_action('wp_enqueue_scripts', 'my_theme_scripts');
