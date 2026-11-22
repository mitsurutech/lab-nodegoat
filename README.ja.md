# Docker Composeで動かすOWASP NodeGoatラボ：わざと安全でなく作ったNode.jsアプリでOWASP Top 10を練習する

[English](README.md) | [Français](README.fr.md) | [Español](README.es.md) | [日本語](README.ja.md) | [Deutsch](README.de.md)

[![check](https://github.com/mitsurutech/lab-nodegoat/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-nodegoat/actions/workflows/check.yml)

[MitsuruTechラーニングプラットフォーム](https://mitsurutech.co.uk/ja/learning)の、授業ですぐ使える**Webアプリケーションセキュリティのラボ**です。このプラットフォームでは、学校が生徒一人ひとりに自分のデータベース、コンテナ、ターミナルをブラウザで用意できます。生徒はそれぞれ**OWASP NodeGoat**の自分のコピーを受け取ります。これは**Node.jsとMongoDB**で書かれた老後の資産形成サイトで、**OWASP Top 10**の弱点が組み込まれており、**インジェクション、認証の不備、安全でない直接オブジェクト参照、クロスサイトスクリプティング**などを練習できます。それぞれの弱点の横には、修正したコードを見せるNodeGoat自身のチュートリアルがあります。何もインストールせず、ほかの人のマシンを危険にさらすこともありません。

`docker-compose`ファイル1つ、`compose.yaml`だけでできていて、自分のマシンでもプラットフォームでも同じように動きます。プラットフォームでは、生徒一人ひとりが、インターネットに出られない自分専用のコピーを使います。ヘルプマニュアルのこのラボのページは[mitsurutech.co.uk/help/lab-nodegoat](https://mitsurutech.co.uk/help/lab-nodegoat)です。

## ただ1つのルール

**攻撃するのは自分のコピーだけにしてください。** このラボのものはすべて自分専用のコピーの中で動き、そのコピーにはインターネットへの経路も、ほかの生徒への経路もありません。届くのは、ラボが自分のために起動したアプリケーションだけです。ラボでもそれ以外の場所でも、自分のものでないWebサイト、ネットワーク、マシンにツールを向けてはいけません。英国では[Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents)に基づく犯罪で、ほとんどの国に同じような法律があります。弱点の仕組みを学ぶことは、弱点のないソフトウェアを作る道です。授業の最初の話題には、このルールがなぜあるのか、責任ある開示とはどういうものかがちょうどよいでしょう。

## 中身

| サービス | イメージ | メモリ | 内容 |
| --- | --- | --- | --- |
| `nodegoat` | `ghcr.io/mitsurutech/nodegoat`、ダイジェストで固定 | 256 MB | OWASP NodeGoat。ポート4000のWebサイト |
| `mongo` | [`mongo:4.4.30`](https://hub.docker.com/_/mongo) | 512 MB | NodeGoatがユーザーと資産のデータを保存するデータベース |

イメージをダウンロード済みなら、NodeGoatは4秒ほどで起動し、2つのサービスは待機中に合わせて85 MBほどを使います。ラボは起動するたびに、NodeGoat自身の`artifacts/db-reset.js`でデータベースを初期化し、そのあとで準備完了を報告します。つまり「準備完了」は、サインインできるという意味です。

### NodeGoatのイメージの出どころ

**NodeGoatは自分のイメージを公開していない**ので、このリポジトリでビルドしています。元のプロジェクトの1つのコミット`c5cb68a7084e4ae7dcc60e6a98768720a81841e8`（2026年10月15日時点の`master`の先端で、バージョン1.3のあと）の[OWASP NodeGoat](https://github.com/OWASP/NodeGoat)を、**NodeGoat自身の`Dockerfile`**でビルドし、`.github/workflows/image.yml`のワークフローが`ghcr.io/mitsurutech/nodegoat:1.3.0-c5cb68a`として公開しています。composeファイルは**ダイジェストで**取得するので、レッスンとレッスンのあいだにクラスの足元で変わることはありません。

**変更は加えていません。** NodeGoatのソースコードもDockerfileも1行も変えておらず、動かすための変更の一覧は空です。足したのは、イメージのラベル（タイトル、ソース、リビジョン、ライセンス）と、ラボがそれを起動する方法だけで、後者はイメージではなく`compose.yaml`にあります。データベースを初期化してから`node server.js`を実行する起動コマンドと、ヘルスチェックです。NodeGoatは再配布を認める[Apache License 2.0](https://github.com/OWASP/NodeGoat/blob/master/LICENSE)でライセンスされています。その`LICENSE`は、イメージの中の`/home/node/app/LICENSE`と、ビルドの横の[`image/UPSTREAM-LICENSE`](image/UPSTREAM-LICENSE)にあります。元のプロジェクトは`NOTICE`ファイルを含んでいません。NodeGoatはOWASPコミュニティの成果物で、私たちの製品ではありません。このリポジトリは、それをラボで動かす手段にすぎません。

MongoDB自身の公開イメージをそのまま使っています。NodeGoatのDockerfileが指定するNode.jsのベースイメージは古い（Node 12）のですが、それもこのアプリケーションの一部です。更新するとアプリケーションが動かなくなるおそれがあり、クラスに必要なのは、アプリケーションがけっして変わらないラボです。

## プラットフォームでの使い方

[MitsuruTechラーニングプラットフォーム](https://mitsurutech.co.uk/ja/learning)は、すべての生徒にラボの専用コピーをブラウザで提供し、横にターミナルを用意します。

**試すには：**[コンテナのページ](https://mitsurutech.co.uk/ja/container)を開き、**Sample labs**でこのラボを探してStartを押します。試すだけならアカウントは必要ありません。

**クラスの課題にするには：**

1. モジュールで種類が**Lab**のタスクを作り、**In a GitHub repository**を選びます。
2. `https://github.com/mitsurutech/lab-nodegoat`とブランチ`main`を指定します。composeファイルは既定の`compose.yaml`です。ファイルを変更したい場合は、先にリポジトリをフォークしてください。
3. 公開します。生徒のコピーは公開したコミットから始まるので、あとでここが変わっても、すでに出したラボは変わりません。
4. 何を提出するかをタスクに書き（[教員の方へ](#教員の方へ)を参照）、ほかのタスクと同じように割り当てます。

ヘルプマニュアルの[セキュリティラボのガイド](https://mitsurutech.co.uk/ja/help/security-labs)と[コンテナラボのガイド](https://mitsurutech.co.uk/ja/help/labs)に、ほかのことが書いてあります。composeファイルに何を書けるか、コピーにどれだけのメモリが割り当てられるか、教員が生徒のコピーをどう開き、見守り、採点するかです。[ラボの一覧](https://mitsurutech.co.uk/ja/help/labs)には、ほかのサンプルラボも載っています。

まだ学校のアカウントがありませんか。生徒50人までなら[最初の1年は無料](https://mitsurutech.co.uk/ja/pricing)で、[登録](https://mitsurutech.co.uk/ja/signup)に必要なのはメールアドレスだけです。

## 自分のマシンで動かす

Composeプラグインつきのdockerが必要です。初回の起動でイメージをダウンロードします。

```bash
docker compose -f compose.yaml -f local.yaml up
```

<http://localhost:4000>を開き、`user1`、パスワード`User1_123`でサインインします。管理者は`admin`で`Admin_123`、`user2`は`User2_123`です。

`local.yaml`はポートを`127.0.0.1`にだけ公開するので、ラボには自分のコンピューターからしか届きません。`Ctrl-C`で止め、`docker compose -f compose.yaml -f local.yaml down -v`で削除します。アプリケーションはわざと安全でなく作ってあるので、攻撃の起点にしてかまわないマシンで動かしてください。

## 進め方

1. `user1`で**サインインします**。データベースはもうできているので、準備することはありません。NodeGoatのサインインページには、NodeGoat自身のチュートリアルへの**Tutorial Guide**リンクがあります。
2. **弱点を1つ選びます。** チュートリアルはOWASP Top 10に沿っています。インジェクション（ContributionsページでのサーバーサイドJavaScriptインジェクションを含む）、認証とセッション管理の不備、クロスサイトスクリプティング、安全でない直接オブジェクト参照（Allocationsのアドレスの末尾の数字を変えます）、セキュリティの設定ミス、機密データの露出、アクセス制御の欠如、クロスサイトリクエストフォージェリ、既知の脆弱性を持つコンポーネント、検証されていないリダイレクトで、さらにサーバーサイドリクエストフォージェリと正規表現によるサービス拒否のチュートリアルが2つあります。
3. **悪用してから、修正を読みます。** チュートリアルの各ページには脆弱なコードと修正したコードがあり、ソースコードでも弱点の横にコメントとして修正が書いてあります。
4. **いつでもやり直せます。** ラボを止めて起動し直すとデータベースが新しくなり、壊してしまったページから戻る方法にもなります。チュートリアルの正規表現によるサービス拒否のように、サーバーを痛めつけることが目的の演習もあります。

## 教員の方へ

このラボには自動採点はありません。生徒が証拠を提出し、ほかのラボと同じように教員が採点します。

**証拠は2つに分けて求めてください。** 1つめは作業の証拠です。使った弱点ごとのスクリーンショットで、ラボ自身のアドレスがブラウザに見えていて、本人のコピーだとはっきりわかるものです。2つめは理解です。弱点ごとに、その弱点が何か、使った入力そのものとそれが通った理由、攻撃者がそれで何をできるか、コードをどう書くべきだったかを、自分の言葉で書いた説明です。2つめを見れば、理解しているのか、解説から写したのかがわかります。より高いレベルの課題では、攻撃に加えて修正も求めてください。

**授業のどこに置くか。** NodeGoatは、Web開発やサイバーセキュリティの単元での、セキュアコーディングとOWASP Top 10に向いています。アクセス制御、認証、入力の扱い、出力のエンコードを、Webを学ぶ生徒が読めるJavaScriptのアプリケーションで扱えます。単元の法律と倫理の面、つまり許可と範囲、Computer Misuse Act 1990、責任ある開示にも役立ちます。正確な文言は、ご自身の資格認定機関の単元で確認してください。ここでは引用していません。

**誰が何を見られるか。** これらのラボは、16歳と17歳の生徒によく使われます。コピーは、それを起動した生徒だけのものです。そのモジュールを教える職員はコピーを開いて生徒の作業を見られますが、生徒の作業を開いたことはアクセスログに記録され、生徒もそのログを読めます。

## ラボでできないこと

ラボはインターネットにまったく出られません。Learning Resourcesのページは外部のWebサイトにリンクしていて、ラボから届くものは何も表示しません。インターネット上のアドレスを取りにいく演習（チュートリアルのサーバーサイドリクエストフォージェリのもの）は、ラボ自身のサービスにしか届きません。NodeGoatには256 MB、データベースには512 MBを割り当てています。データベースは保存されず、ラボを止めると何も残りません。

## トラブルシューティング

- **Startのあとすぐにはサインインページが出ない。** 数秒待ってからもう一度Openを押してください。ラボは、データベースができてから準備完了を報告します。
- **演習のあとサイトが応答しなくなった。** わざとサーバーを落とす演習があります。ラボを止めて起動し直せば、新しいコピーになります。
- **自分のマシンでポート4000がすでに使われている。** `local.yaml`の左側の数字を、たとえば`127.0.0.1:4001:4000`のように変えて、そのポートを開いてください。

## このラボについて

このラボは、[MitsuruTechラーニングプラットフォーム](https://mitsurutech.co.uk/ja/learning)を作っている[Mitsuru Technologies Ltd](https://mitsurutech.co.uk/ja)が作りました。このプラットフォームでは、教員がプログラミング、データベース、コンテナ、ラボの課題を出し、生徒が提出したものを採点できます。このリポジトリのうち私たちが書いたファイル（composeファイル、テスト、ワークフロー）はMITライセンスです。[LICENSE](LICENSE)を参照してください。OWASP NodeGoatはApache-2.0ライセンスで、その作者のものです。

同じシリーズのほかのラボです。それぞれが独自のリポジトリを持ち、[マニュアルのページ](https://mitsurutech.co.uk/ja/help/labs)があります。

- [lab-dvwa](https://github.com/mitsurutech/lab-dvwa)：DVWA（Damn Vulnerable Web Application）
- [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop)：OWASP Juice Shop
- [lab-webgoat](https://github.com/mitsurutech/lab-webgoat)：OWASP WebGoatとWebWolf
- [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin)：MySQLとphpMyAdmin
- [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea)：GitとGitea
- [lab-sample](https://github.com/mitsurutech/lab-sample)：PostgreSQLとPostgREST

## このリポジトリのパスワードについて

上のアカウント（`user1`、`user2`、`admin`）は、NodeGoat自身が公開しているデモ用アカウントです。自分のコンピューターかプラットフォームの中でしか動かないラボのためのフィクスチャで、本物の認証情報ではありません。わざとここに書いています。
