const fs = require("fs");
const path = require("path");

// テンプレートファイルのパス
const templatePath = path.join(__dirname, "package.template.json");
// 生成する package.json のパス
const targetPath = path.join(__dirname, "package.json");

// 現在のディレクトリ名を取得（これをプロジェクト名として使用）
const projectName = path.basename(process.cwd());

try {
  // テンプレートを読み込み
  if (!fs.existsSync(templatePath)) {
    console.error("エラー: package.template.json が見つかりません。");
    process.exit(1);
  }

  const packageData = JSON.parse(fs.readFileSync(templatePath, "utf8"));

  // プロジェクト名をディレクトリ名で上書き
  packageData.name = projectName;
  packageData.description = `WordPress theme for ${projectName}`;

  // package.json を書き出し
  fs.writeFileSync(targetPath, JSON.stringify(packageData, null, 2));

  console.log(`✅ ${targetPath} を作成しました。`);
  console.log(`📦 プロジェクト名: "${projectName}"`);

  // .stylelintignore を生成
  const stylelintIgnore = `node_modules/\nstyle.css\nstyle.css.map\n`;
  fs.writeFileSync(path.join(__dirname, ".stylelintignore"), stylelintIgnore);
  console.log("✅ .stylelintignore を作成しました。");

  // stylelint.config.js を生成（テンプレートからコピー）
  const stylelintConfigSrc = path.join(__dirname, "stylelint.config.template.js");
  const stylelintConfigDest = path.join(__dirname, "stylelint.config.js");
  if (fs.existsSync(stylelintConfigSrc)) {
    fs.copyFileSync(stylelintConfigSrc, stylelintConfigDest);
    console.log("✅ stylelint.config.js を作成しました。");
  }

  // --- クリーンアップ処理 ---
  console.log("🧹 不要なセットアップファイルを削除します...");

  try {
    fs.unlinkSync(templatePath); // package.template.json を削除
    console.log(`   - 削除: ${path.basename(templatePath)}`);

    // このスクリプト自身を削除
    // 注意: Windows環境などでロックされている場合は失敗する可能性がありますが、Node.jsでは通常実行中のファイル削除は可能です
    fs.unlinkSync(__filename);
    console.log(`   - 削除: ${path.basename(__filename)}`);
  } catch (cleanError) {
    console.warn("⚠️ クリーンアップ中にエラーが発生しましたが、package.json は作成されました。", cleanError.message);
  }
  // -----------------------

  console.log("✨ セットアップ完了！");
  console.log('👉 次に "npm install" を実行して依存関係をインストールします。');
} catch (error) {
  console.error("エラーが発生しました:", error);
}
