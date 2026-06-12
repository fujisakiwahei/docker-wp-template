# CLAUDE.md

## スクリーンショットの保存先（必須ルール）

ブラウザ操作ツールで撮影したスクリーンショットは、**すべてプロジェクトルートの `screenshots/` に保存する**こと。
保存先が分散すると確認できないため、レスポンス添付のみ・別ディレクトリへの保存は禁止。
`screenshots/` の中身は Git 管理外（`.gitkeep` のみ追跡）。

### Chrome DevTools MCP（`take_screenshot`）

必ず `filePath` を指定する。指定しないとファイルに残らない。

```
filePath: "screenshots/<名前>.png"
```

### Playwright MCP（`browser_take_screenshot`）

`filename` にも必ず `screenshots/` プレフィックスを付ける。
（注意: ファイル名だけを渡すと `--output-dir` ではなくカレントディレクトリ基準で保存され、プロジェクトルート直下に散らばる。検証済みの実挙動。）

```
filename: "screenshots/<名前>.png"
```

`filename` を省略した場合は自動命名で `screenshots/` に保存されるが、後から判別できないため原則名前を付けること。

### Playwright CLI / スクリプト

出力先を明示的に `screenshots/` 配下にする。

```sh
npx playwright screenshot <url> screenshots/<名前>.png
```

`page.screenshot()` を使う場合も `path: "screenshots/<名前>.png"` を指定する。

### ファイル名の付け方

`<ページ>-<状態>.png` の形式を推奨（例: `top-page.png`, `contact-form-error.png`, `top-page-sp.png`）。
