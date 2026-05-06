<?php

/**
 * ボタンコンポーネント
 *
 * 使用例：
 * get_template_part("components/GradationButton", null, [
 *   "text" => "詳しく見る",
 *   "url"  => "/about", // 内部リンク（home_urlが自動付与される）
 *   "class" => "class-name",
 *   "target_blank" => true // 外部リンクならtrue
 * ]);
 */

$text  = $args["text"]  ?? "";
$url   = $args["url"]   ?? "#";
$class = $args["class"] ?? "";
$target_blank = $args["target_blank"] ?? false;

// URLが http または https で始まっているか判定（外部リンク）
if (preg_match("#^https?://#", $url)) {
  $final_url = $url; // 外部リンク → そのまま
} else {
  $final_url = home_url($url); // 内部リンク → home_url付与
}

// target, rel を条件で付与
$target_attr = $target_blank ? " target=\"_blank\" rel=\"noopener noreferrer\"" : "";
?>

<a class="gr-btn <?php echo esc_attr($class); ?>"
  href="<?php echo esc_url($final_url); ?>" <?php echo $target_attr; ?>>
  <span class="gr-btn-text"><?php echo esc_html($text); ?></span>
</a>