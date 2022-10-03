# sinatra-memo

sinatraを使ったメモアプリのプログラムです。

# How to use

1. 作業PCの任意の作業ディレクトリにて git clone してください。
```
$ git clone https://github.com/自分のアカウント名/Sinatra-memo.git
```

2. メモアプリが実装しているブランチにチェックアウトしてください
```
$ git checkout -b sinatra-memo origin/sinatra-memo
```
3. rubyのバージョンは`.ruby-version`ファイルに書かれているものと合わせる。

4. Gemfileにリスト化したgemを一括インストール
```
$ bundle install
```
5. 4のインストールが失敗したときにはアップデートを行う
```
$ bundle update
```
6. アプリケーションを立ち上げます。
```
$ bundle exec ruby app.rb
```
7. `http://localhost:4567/`アクセスするとメモアプリのトップページが表示されます。