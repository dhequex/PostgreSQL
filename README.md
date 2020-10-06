# データベース
### This was created during my time as a [Code Chrysalis](https://codechrysalis.io) Student

## 目次

1. [はじめに](＃introduction)
1. [達成目標](＃objectives)
1. [トピックの概要](＃overview-of-topics)
1. [達成目標と指示](＃objectives-and-instructions)
   1. [基本レベル](＃basic-requirements)
   2. [応用レベル](＃advanced-requirements)
1. [リソース](＃resources)
1. [コントリビューション](＃contributing)

## はじめに

このスプリントは、ウォークスルー形式であるという点で今までと少し異なります。また、新たに、SQL と呼ばれる、今までと全く異なるプログラミング言語を使用します。後半では、基本的な SQL の概念を理解した後、非常にシンプルなチャットアプリのバックエンドを作成します。

## 達成目標

- SQL を使用したデータベースとのやり取りに慣れる
- 基本的なデータベーススキーマの設計方法を理解する
- Postgres で基本的な CRUD 操作を行えるようになる
- リレーショナルデータベースと非リレーショナルデータベースの主な違いについて明確に定義できる

## トピックの概要

### データベースの概要

これまでのところ、今まで作成したすべてのアプリはデータをメモリに保持し、アプリを閉じるとそれらの情報はすべて消去されます。恐ろしいハック以外の方法で情報を保存できるようにするには、データベースが必要です。今日は、データベースの構造化（’スキーマ設計’）と、とても強力で柔軟なリレーショナルデータベースである Postgres を使用した基本的な CRUD（作成、読み取り、更新、削除）操作について学習します。

大まかに言うと、リレーショナルデータベースと非リレーショナルデータベースの 2 種類のデータベースが存在します。ハイブリッドタイプのデータベースもありますが、それらについてここでは解説しません。このスプリントでは、リレーショナルデータベースを使った課題をメインで行いますが、両者のデータベースについて簡単に解説します。

> ### 非リレーショナルデータベース

非リレーショナルデータベースは _ドキュメント_ を保存します。これらは、JSON のような（正直なところ、多くの種類が存在します）データの集合体であり、明確に定義されたスキーマ（データを一貫して構造化する方法）を持っている場合と持っていない場合があり、互いにリレーションを直接持ちません。通常、多くの制約なしにデータを高速に読み書きできます。以下に、いくつかの例とそのユースケースを示します：

- MongoDB、[Expedia](https://www.mongodb.com/customers/expedia)で、百万人規模のユーザーが作成した自由形式の旅行プランを保存するために使われています。
- [ElasticSearch](https://www.elastic.co/use-cases) / [Lucene](https://lucene.apache.org/core/)、StackOverflow のような企業で、関連する質問や回答を見つけるために、ギガバイト規模のあいまい検索が必要な場合に使われています。また、アプリケーションログやそのインデックスを保存するために、多くのアプリで使用されています。これにより、あいまい検索を可能し、デバックの役に立っています。
- [Redis](https://redis.io/topics/whos-using-redis)、超高速のメモリ内データベースで、アプリケーションがリレーショナルデータベースに常時アクセスしないようにするためのキャッシュとして主に使用されます。

非リレーショナルデータベースには非常に多くの種類が存在し、特定のユースケースに適している傾向があります。ここでは、それらについて詳しく言及することはありません。なぜなら、それぞれがかなりのボリュームがあり、多くの学習コストを割く必要があるためです。

> ### リレーショナルデータベース

リレーショナルデータベースには、相互に関連付けることのできる _テーブル_ があります。これらは RDBMS（リレーショナルデータベース管理システム）とも呼ばれます。例として、MySQL、SQLite、Oracle、Postgres（私たちのお気に入りであり、今回使用するデータベース）などがあります。リレーショナルデータベースは、ビジネスロジックが依存する堅牢なデータセットを構築および維持するためのルールと制約を設定し、そのデータをクエリするのに最適です。任意のプラットフォームで使用するアプリの大部分には、何らかの種類のリレーショナルデータベースが背後にあると想定できます。

リレーショナルデータベースは通常、_標準 SQL 規格_ と呼ばれる理想的な仕様に準拠するようにできています。SQL は _Structured Query language_ の略で、データを得る方法ではなく、どのようなデータがほしいかを記述する[宣言型プログラミング言語](https://ja.wikipedia.org/wiki/%E5%AE%A3%E8%A8%80%E5%9E%8B%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0)です。大体のケースでは、それぞれのリレーショナルデータベースが持つ変わった方言を除いて、SQL を知っていれば、どのリレーショナルデータベースも操作する方法は同じです。

さまざまなリレーショナルデータベースの違いを把握しておくことも有用です。[こちら](https://www.digitalocean.com/community/tutorials/sqlite-vs-mysql-vs-postgresql-a-comparison-of-relational-database-management-systems)の資料を読んでみましょう。今回は、課題で Postgres を使用します。

## 達成目標と指示

### 基本レベル

#### テーブルの作成

リレーショナルデータベースはすべてテーブルで構成されていると前述しました。まず、いくつかのテーブルを作成しましょう。データベース内のテーブルとそれに関連するルールの集まりのことを、 _スキーマ_ と呼びます。過去、現在、未来に在籍する Code Chrysalis の生徒のスキーマを作成することを想定しましょう。ここでは、各生徒の名前、生年月日、性別、出身地を保存したいと思っています。今のところ、これを 1 つのテーブルで管理することとします。

- [ ] `psql` を開き、Postgres のコマンドラインを入力してください。`\q` を使用して終了することを確認しましょう。
- [ ] データベースを作成するための構文を調べ、`students` という名前のデータベースを作成し、`\c students` を使用して接続してみましょう。
  - アドバイス：SQL では、すべてのステートメントは `;` で終わる必要があります。ステートメントが実行されていない場合、いずれかのセミコロンが欠落している可能性があります。
- [ ] SQL でテーブルを作成するための構文を検索しましょう。
- [ ] `id`、`first_name`、`last_name`、`date_of_birth`、`gender`、`town_of_origin` の列を持つ `students` という名前のテーブルを作成しましょう。`id` には `SERIAL` 型を使用する必要がありますが、その他のケースは postgres のドキュメントを参照し([簡略版](https://www.techonthenet.com/postgresql/datatypes.php) | [詳細版](https://www.postgresql.jp/document/9.6/html/datatype.html))、各列に適切なデータ型を選択しましょう。
  - テーブルの各生徒に ID を割り当てます。これは、アプリの製作者である _私たち_ にとって、テーブル内のそれぞれの行を一意に識別できるものがあると便利だからです。そして、この ID を変更する理由は _決して_ ありません。
  - この目的のために、テーブルを作成するたびに ID として自動インクリメント整数を使用することがよくあります。この仕組みは `SERIAL` 型が行っています。
- [ ] テーブルを作成しましょう。
  - 誤って作成した場合は、`drop table student;` を使用してテーブルを削除できます。
  - postgres では、列名の大文字と小文字の区別は厄介な問題であることに注意してください。簡単のために、テーブル、列、データベース名には必ずスネークケースを使用するようにしてください。
- [ ] いくつかの便利なメモ：
  - `\dt` と入力して、データベース内のすべてのテーブルを表示します。
  - `\d name_of_your_table` と入力して、特定のテーブルの説明を取得します。
  - `\l` と入力して、接続できるすべてのデータベースを表示します。

#### データの挿入

- [ ] あなたの名前、性別、および誕生日のデータを、構文を調べて students テーブルに挿入しましょう。自分で `id` を挿入しないでください。ID は自動で挿入されます。
- [ ] `scripts/insertStudents.sql` ファイルの生徒のデータを見てみましょう。このファイルを修正して、各行を `insert` SQL ステートメントにしてください。次に、いくつかの `psql` のマジックを使用してファイル全体の SQL ステートメントを実行するので、それぞれを手動で挿入処理を実行する必要はありません。
- [ ] `scripts/insertStudents.sql` を見て、各行を正しい `insert` ステートメントに修正し、作成したテーブルに生徒のデータを挿入しましょう。またこのとき、便利なショートカットキーを使用して時間を節約しましょう！次のステップでは、実際にこのファイルを `psql` で実行します。
  - psql の CLI でたくさんの SQL を記述するのは苦痛です。一般に、実行したいコマンドをまとめた `.sql` ファイルを書いたほうがはるかに簡単です。たとえば、次に、 `psql -d students -f ./scripts/insertStudents.sql` を実行して、これらのコマンドを psql にパイプできます。`-d students` は psql に `students` データベースに接続するように指示し、`-f ./scripts/insertStudents.sql` は直接入力した場合と同様に `scripts/insertStudents.sql` のコマンドを実行するように指示します。
- [ ] ターミナルから、（`\q` を使用して）postgres CLI を終了し、`psql -d students -f scripts/insertStudents.sql` を実行して、実際にデータを挿入してみましょう。`INSERT 0 1` という行が約 100 回繰り返して表示されれば、正常に実行できています。 _それ以外_ が表示される場合はエラーが発生しています。何がうまくいかなかったかを理解し、修正しましょう。
  - このステップを実行不可能にするなんらかのミスをテーブル作成時に犯した場合、`drop table students;` を使用して作成したテーブルを削除し、やり直してみましょう。
  - ファイルを実行するには、postgres CLI を終了せずに、代わりに `\i` の後にファイルパスを指定する方法を使うこともできます。

#### データの抽出

以下の各ファイルで、これらのクエリの構文を調べ、`psql -d Students -f file_name` を使用して実行できるかどうかを確認しましょう。これらのクエリを `psql` 内で直接実行することもできます。これにより、プロトタイピングと内容の把握をはるかに高速に行うことができます。

- [ ] `scripts/selecting/allStudents.sql`：すべての生徒のデータを抽出しましょう。
- [ ] `scripts/selecting/fromSf.sql`：`San Francisco` 出身の生徒の全データを抽出しましょう（`where` 句を調べてみましょう）。
- [ ] `scripts/selecting/over25.sql`：25 歳以上の生徒の全データを抽出しましょう。
  - [ ] このとき、今日の日付をハードコーディングせずにデータを抽出してください。
- [ ] `scripts/selecting/studentsByAge`：年齢でソートし、すべての生徒の名前と苗字、生年月日のみを抽出しましょう。この時点で、生年月日の一部が間違っている可能性に気付くかもしれません。心配しないでください、これは後で修正します。

- SQL では、すべてのクエリはデータを含むテーブルを _必ず_ 返します。しかし、行をグループ化したい場合はどうなるでしょうか？
- それぞれの町から最年長者の生年月日を検索する場合、それぞれの町に対応する行が 1 行だけになるように、students テーブルの行をグループ化する必要があります。このように、町ごとに行をグループ化すると、テーブルとして取得できません。代わりに、次の例のようにネストされたリストのようなデータとして取得できます。

```
- Tokyo
  - Vilhelmina | F      | 1989-03-07
  - Hallie     | F      | 1988-05-01
  - Meris      | F      | 1973-07-04
  - Anneliese  | F      | 1975-01-29
  - Angie      | F      | 1970-06-21
- Sydney
  - Harriott   | F      | 1981-09-30
  - Tyne       | F      | 1975-03-09
  - Charlene   | F      | 1984-09-11
  - Ellie      | F      | 1978-11-15
  - Leela      | F      | 1979-03-26
```

- しかし、すべてのクエリは _必ず_ テーブルを返さなければいけません。ネストされたリストをテーブルに変換するには、[集約関数](https://www.postgresql.jp/document/9.6/html/functions-aggregate.html)を使い、それぞれの列をグループごとに単一の値に集計する必要があります。つまり、出身地（町）の情報がそれぞれ 1 行のみ存在するようにします。このクエリの最後に集約関数を使用します。文字列を _集約すること_ は間違えやすいコンセプトであることに注意してください。これが、生年月日（date_of_birth）と出身地（town_of_origin）のみを必要とした理由です。
- [ ] `scripts/selecting/oldestInTown`：それぞれの町で最も年長の生徒の生年月日と出身地のみを抽出してください（[group by](https://www.tutorialspoint.com/postgresql/postgresql_group_by.htm) を使用）

- 次の課題はオプションです（難しい）。もちろん、クエリで group-by から文字列の値を取得する必要がある場合があります。この問題を解決するために、Postgres には、2 つの便利な機能があります。[サブクエリ](http://www.postgresqltutorial.com/postgresql-subquery/)と[ウィンドウ関数](https://www.postgresql.jp/document/9.6/html/tutorial-window.html)です。
- [ ] `scripts/selecting/oldestInTownByGender`（チャレンジモード）：それぞれの町の最年長の男子生徒と女子生徒の名、生年月日、出身地、及び性別を抽出します。
  - [ヒント] この課題に取り組む方法の 1 つは、まず、すべての生徒のデータと、性別・町ごとの最年長者の生年月日を持つ追加の列を返すクエリを作成することです。これにはウィンドウ関数を使ってください。次に、作成したこのクエリをサブクエリとして扱います。
- これらのクエリのいずれかが実行できない場合、使用したデータ型が間違っている可能性があります。答えに詰まってしまった場合は、インストラクターに声をかけて確認しましょう。

#### データの更新

SQL では、行を更新するのではなく、テーブルを更新します。以下の課題では、1 つ以上の `where` 句を使用して、更新対象のテーブルのサブセットを抽出する必要があります。単一のクエリを使用して、以下を実行します。

- [ ] `scripts/updating/correctCase.sql`：気づいたかもしれませんが、一部の生徒は `Tokyo` 出身、他の生徒は `tokyo` 出身となっています（T が大文字か小文字かの違い）。`tokyo` 出身となっているすべての生徒のデータを更新して、`Tokyo` 出身の生徒に変更しましょう。
- [ ] `scripts/updating/correctdate_of_birth.sql`：データに別のエラーがあるようです。一部の生徒のデータには、実際の生年月日よりちょうど 100 年前の生年月日が記録されています。どの生徒が間違った生年月日を持っているか見つけて修正しましょう。このとき、実際に 100 歳以上の生徒はいないものと想定してください。

#### データの削除

`Anakin Skywalker` という生徒がいることに気づいたかもしれません。残念ながら、暗黒卿は Code Chrysalis に参加しませんでした。

- [ ] `scripts/deleting/lastJedi.sql`：`students` テーブルから `Anakin Skywalker` を削除しましょう。

#### 制約

- 上記の基本レベルの課題を完了することで、データベースからデータをクエリする方法のうち、約 80% を理解したことになります。これまでの内容は、音楽の演奏に置き換えると、C、F、G、F マイナーコードに相当する内容を、データベースについて学習してきたことになります。次に、テーブルをセットアップして整理する方法として、スキーマの設計を見ていきます。
- [ ] [制約に関する postgres のドキュメント](https://www.postgresql.jp/document/9.6/html/ddl-constraints.html)の最初の 2 つの段落を読んでください。
- 制約とは、不正なデータが挿入されないようにするために、データベース内のテーブルと列に設定する制限のことです。
- 通常、制約はテーブルの作成時に追加されますが、テーブル内のデータが作成しようとしている制約を破っていない場合は、テーブル作成後でも追加できます。興味がある場合は、[テーブル定義の変更に関する簡単なチュートリアル](http://www.postgresqltutorial.com/postgresql-alter-table/)を参照してみましょう。ただし、焦って心配する必要はありません。このスプリントの後半でも取り上げます。
- 一般的に、データベースに制約を定義して、決して変更してはならないルールを持たせておくことをお勧めします。たとえば、生年月日が未来日になっていないことを確認するなどの制約を定義するのが合理的です。

> ### 一意性制約

- `students` テーブルを作成したときのことを思い出してみると、すべての生徒に一意の ID を持たせるために、自動インクリメントの `id` 列を追加しました。重複した `id` を作成しようとするとどうなるでしょうか？
  - [ ] `students` テーブルに `id` が 1 である別の生徒を挿入してみましょう。生徒の残りの情報には適当な値を入れてください。
  - 何が起こったのか注目してください。最悪です！ `id` が 1 の生徒はすでに存在しています！ID における重要なポイントは、値が必ず一意であるということです。
    - `UNIQUE CONSTRAINT` というフレーズを含むエラーが返ってきた場合、あなたは確実に前進しています。`constraints` セクションの残りの部分を読むこともできますが、おそらくすでに理解した内容のはずです。
- Postgres ドキュメントで[一意性制約](https://www.postgresql.jp/document/9.6/html/ddl-constraints.html)を検索しましょう。
- [ ] students テーブルを削除（`drop table students`）し、今回は ID 列に一意性制約を定義して、students テーブルを再び作成しましょう。`scripts/insertStudents.sql` スクリプトを使用して、生徒のデータを再び挿入しましょう。
- [ ] 先ほどと同様に、`scripts/insertStudents.sql` スクリプトを使用して、生徒のデータを再び挿入してみましょう。
- [ ] 重複した ID を持つ生徒のデータをもう一度挿入してみましょう。その ID を持つ生徒が既に存在することを示すエラーが表示されることを確認してください。エラーが発生しない場合、一意性制約が正しく設定されていません。エラーが発生した場合は、おめでとうございます！最初の制約を作成することに成功しました！

> ### 非 NULL 制約

- [ ] `id` に明示的に `NULL` を設定した別の生徒のデータを `students`テーブルに挿入してみましょう。
  - 再び、何が起こったのか注目してください。馬鹿げていますね！一部の生徒が ID を _持たない_ 場合があるとすると、ID は無意味なものになってしまいます。
  - `NULL` 値は悪名高い落とし穴です。なぜなら、JavaScript とは異なり、`NULL` 値は SQL では計算できないため、一意性制約は `NULL` 値には適用されません。
  - プロフェッショナルからのヒント：SQL では、`NULL` 自体を含め、`NULL` に等しいものはありません。
    - クエリで `NULL` かどうか確認するには、`= NULL` または `!= NULL` を使用する代わりに、`IS NULL` または `IS NOT NULL` を使用します。
  - これらの問題を回避するために、非 NULL 制約を使用して、任意の列に `NULL` 値を許容しないように指定できます。
- [ ] Postgres ドキュメントで[非 NULL 制約](https://www.postgresql.jp/document/9.6/html/ddl-constraints.html)を検索しましょう。
- [ ] students テーブルを削除し（`drop table students`）、今回は ID 列に一意性制約と非 NULL 制約を定義して、students テーブルを再び作成しましょう。`scripts/insertStudents.sql` スクリプトを使用して、生徒のデータを再び挿入しましょう。
- [ ] 明示的に `NULL` の生徒 ID を持つ生徒をもう一度挿入してみましょう。エラーが発生することを確認してください。エラーが発生しなかった場合、非 NULL 制約が正しく設定されていません。

> ### 主キー

- 非常に多くの場合、テーブルの特定の列（この場合、`students` テーブルの `id` 列）が、そのテーブルの行のプライマリ識別子になります。このような ID は決して null であってはならず、常に一意である必要があります。ほとんどのデータベースは、この目的のために `主キー` 制約を提供します。主キー制約は、実質、一意性制約と非 NULL 制約の組み合わせです。
- [ ] Postgres で[主キー](https://www.postgresql.jp/document/9.6/html/ddl-constraints.html)のドキュメントを検索し、自分で確認してみましょう。
- 今後は、おそらく `主キー` 制約を使用する必要が出てきますが、それが実際、何を意味するのか正確に理解しておくことが重要です =)

#### 結合

> ### 1 対多のリレーションシップ

- 冒頭で、リレーショナルデータベースは、相互に関係を持ったデータテーブルの集まりであると述べました。さて、今のところテーブルは 1 つしかありませんが、心配しないでください。すぐに修正していきます！
- [ ] `scripts/insertCheckins.sql` を見てください。
  - ファイル内のステートメントはトランザクション内で書き込まれます（1 行目と 998 行目）。今のところ、トランザクションについて、トランザクション内でステートメントを実行した場合、すべてのステートメントが実行される、もしくはすべてが失敗するということを知っておきましょう。データの一部が挿入された後、処理が失敗し、その一部のデータが挿入されたままになることは _ありません_。
- [ ] `psql -d students -f scripts/insertCheckins.sql` を使用して `scripts/insertCheckins.sql` を実行してみましょう。
  - うまくいった場合は、次のステップに進みます。
  - うまくいかなかった場合は、`Key (student_id)=(60) is not present in table "students"` のようなエラーメッセージをチェックしてください。スクリプトからエラーの ID を持つ生徒のチェックインのデータを削除してください。約 20 行以下にする必要があります。便利なショートカットキーを使用して時間を節約しましょう！
  - スクリプトを再び実行してみましょう。スクリプトが機能するまで何度もスクリプトを実行しても特に害はありません。
- [ ] Postgres ドキュメントで[外部キー](https://www.postgresql.jp/document/9.6/html/ddl-constraints.html)を検索して、`scripts/insertCheckins.sql` の 5 行目で何を行っているかを理解しましょう。
  - 現在、students と checkins の 2 つのテーブルができているはずです。ここで、チェックインとは、生徒が Code Chrysalis の教室に出席した時間のことです。
  - データベースに関していくつかの点に注意してください。
    - それぞれの生徒は多数のチェックインを持つことができます
    - ID を除いて、生徒のデータは 2 つのテーブル間で複製されることはありません。
      - データベース内のすべてのエンティティには、_信頼できる唯一の情報源_ があります。students テーブルは生徒に関する唯一のデータソースであり、checkins テーブルはチェックインに関する唯一のデータソースです。
    - すべてのチェックインに対して、外部キー制約により、その ID を持つ生徒が _常に_ 存在するという確固たる保証が与えられます。checkins テーブルで使用されている ID を持つ生徒を削除しようとすると、データベースはエラーを発生させ、処理を停止させます。
    - これは参照整合性と呼ばれ、リレーショナルデータベースの重要な機能です。この機能のおかげで、リレーショナルデータベースは人気があり、その信頼性を高めています。
- [内部結合](https://www.tutorialspoint.com/postgresql/postgresql_using_joins.htm)の構文を検索し、次のスクリプトを完成させましょう。
  - [ ] `scripts/selecting/allStudentAndCheckin.sql`：単一のクエリで、すべての生徒のデータとそのチェックインのデータを抽出してください。
  - [ ] `scripts/selecting/allCheckinInOn.sql`：2016 年 6 月にチェックインしたすべての生徒について、checkins テーブルから対象の生徒データと `checked_in_at` のみを抽出してください。
    - [ ] チャレンジモード： `scripts/selecting/allCheckinInOn.sql` を拡張して、重複エントリを削除してください。結果として、2016 年 6 月にチェックインした各生徒は 1 回だけリストアップされ、`checked_in_at` は表示されないようにしてください。
      - ヒント：`DISTINCT`を参照しましょう。
  - このスプリントの後、空いている時間に[結合に関するチュートリアル](https://github.com/codechrysalis/sprint.database-part-1)（以下の`リソース`のセクションでも言及）の外部結合、左結合、および右結合について読むことをお勧めします。

> ### 多対多のリレーションシップ

- students と checkins テーブルの間に見られる関係は、1 対多のリレーションシップと呼ばれます。これは、各生徒（1 人）に対して多数のチェックインがあるためです。
- 可能なリレーションシップには、次の 3 種類があります。
  - 1 対 1
  - 1 対多
  - 多対多
- より詳細な説明については、この[リレーションシップに関するチュートリアル](https://support.airtable.com/hc/en-us/articles/218734758-A-beginner-s-guide-to-many-to-many-relationships)（おすすめの参考資料も含む）
- 多対多のリレーションシップを作成してみましょう。

  - [ ] `scripts/insertProjects.sql`を見て、何を行っているか理解しましょう。
  - [ ] `psql -d students -f scripts/insertProjects.sql` を使用して、いくつかのシードデータで `projects` テーブルを作成しましょう。
  - 各プロジェクトに、多くの生徒が参加しています。生徒は多くのプロジェクトに取り組んできたかもしれません。これが、多対多のリレーションシップです。
  - SQL でこれらを表す最も一般的な方法は、個別の _結合テーブル_ を持つことです。
    - `scripts/studentsToProjects.sql` には、`student_id` と `project_id` のリストが含まれています。それぞれの行は、特定のプロジェクトに取り組んでいる一人の生徒を表しています。
  - [ ] `scripts/studentsToProjects.sql` スクリプトで、SQL を追加して `students_to_projects` という名前の結合テーブルを作成しましょう。テーブルには次のものが必要です。
    - [ ] `students` テーブルに関連付けられた、外部キー制約を持つ `student_id` 列。
    - [ ] `projects` テーブルに関連付けられた、外部キー制約を持つ `project_id` 列。
    - [ ] 上の 2 つの列の組み合わせに対する一意性制約。これにより、生徒を 1 つのプロジェクトに複数回結び付けることができなくなります。
  - [ ] `scripts/studentsToProjects.sql` を編集し、対象のデータを使用して `students_to_projects` テーブルにデータを挿入します。
  - 問題が発生し、`Key (student_id)=(60) is not present in table "students"` といったエラーが表示された場合、単純に、エラーとなっている行を `scripts/studentsToProjects.sql` ファイルから削除してください。

- よくできました！最初の結合テーブルを作成しました！

- この新しいデータでいくつかのクエリを書いていきましょう！
  - [ ] `scripts/selecting/studentsOnProjectX.sql`：`id` が 5 であるプロジェクトに取り組んだすべての生徒の `first_name` と `last_name` を抽出しましょう。
  - [ ] `scripts/selecting/studentsOnProjectX.sql`：2016 年 6 月にチェックインした生徒が取り組んだ、すべてのプロジェクトの `name` を抽出しましょう。リストには重複がないはずです。
  - [ ] `scripts/selecting/studentsOnProjectX.sql`（チャレンジモード）：プロジェクトにまったく取り組んでいないすべての生徒の `first_name` と `last_name` を抽出しましょう。
    - ヒント：[サブクエリ](https://stackoverflow.com/questions/19363481/select-rows-which-are-not-present-in-other-table)を使用する必要があります。

#### スキーマ設計

- ペアで、次のシナリオのデータベーススキーマについて話し合い、お互いの意見を議論し合いましょう。以下のシナリオは、あなたのペアとの議論に火をつけるために意図的に曖昧にしてあります。
- それぞれのシナリオについて、[http：//dbdesigner.net/](http://dbdesigner.net/) のような視覚的なツールを使用してスキーマを設計してみましょう。例として、小さなプロジェクトのスキーマを以下に示します。
  ![CodeChrysalis-Database-1-schema](/assets/cc-db-1-schema.png?raw=true "CodeChrysalis Database Sprint I")
- [ ] 図書館（library）
  - 図書館（library）には、たくさんの本（book）があります
  - 図書館（library）には、多くのメンバー（member）がいます。
  - メンバー（member）は、本（book）をいくつでも借りることができます。
  - 図書館（library）は、すべての借入の履歴記録を保存する必要があります。
- [ ] Slack
  - Slack には、チャットをする多くのユーザー（user）がいます
  - Slack には、多くのチャンネル（channel）があります。
  - チャンネル（channel）には、多くのユーザー（user）が所属することができます。
  - ユーザー（user）は、独自のプライベートチャンネルを作成して、お互いに直接メッセージをやり取りすることもできます。
- [ ] チャレンジモード：ChrysalisBook - Code Chrysalis の生徒のためのソーシャルネットワーク
  - 多くの生徒が在籍しています。
  - すべての生徒が、友達リクエストを他の生徒に送信できます。
  - 友達リクエストを受け取った生徒は、それを受け入れる、拒否する、またはブロックすることができます。
  - ブロックされた生徒は、友達リクエストを送信できなくなりますが、ブロックされていることは相手に知らせないでください。

### 応用レベル

#### インデックス

- インデックスは、リレーショナルデータベースのコア機能です。データベースが一致する結果を見つけるのにかかる時間を劇的にスピードアップし、テーブルが大きくなるとより重要になります。
- 最も一般的なインデックス（多くの場合、デフォルト）は、[B+ 木](https://ja.wikipedia.org/wiki/B%2B%E6%9C%A8)です。これは、すでに馴染みのあるバイナリツリーのバリエーションの 1 つです。簡単に言えば、葉ノードが連結リストで接続されているツリーです。これについての詳細は、[データベースの実際の動作に関する概要](http://coding-geek.com/how-databases-work/)の `ハードコアな読み物` のセクションを参照してください。
- インデックスを追加するコストは、新しいデータの挿入が遅くなることです。そのため、すべての列にインデックスを追加することは、絶対に良い考えというわけでは必ずしもありません。
- 経験則として、比較的頻繁にフィルタリングまたは結合する予定のある列にのみ、インデックスを追加する必要があります。
- 列に一意性制約を追加すると、通常、その列にもインデックスが追加され、データを挿入するごとに、データベースが一意性を確認できるようになります。
- インデックスの追加は、列の入力可能な値（ブール値など）のバリエーションが非常に少ない場合に限定的に使用されます。
- [ ] students テーブルと checkins テーブルのどの列にインデックスを設定すべきかペアと話し合いましょう。
- [ ] [postgres ドキュメント](https://www.postgresql.jp/document/9.6/html/sql-createindex.html)でインデックスを追加するための構文を検索（`例` のセクションを検索）し、必要だと思う列にインデックスを追加しましょう。
  - 少なくとも、各テーブルの ID 列にインデックスを追加する必要があります。
  - Google と Stackoverflow を自由に使用しましょう。データベースに '正しく' インデックスを設定することは大きなトピックです！
  - 対象のテーブルに存在するインデックスは、`\d table_name;` を使用して psql で見つけることができます。

#### トランザクション

- トランザクションはデータベースに必須の機能です。あなたはすでに `scripts/insertProjects.sql` でそれを使っています。
- トランザクションは、いくつかの SQL クエリをまとめて、バッチ処理できるようにする方法です。
- これが必要な場合の典型的な例は、銀行振込の処理です。銀行が 1 つの口座から別の口座に送金しなければならない場合、通常 2 つのクエリを書く必要があります。1 つの口座から送金する金額を差し引くクエリと、別の口座にその金額を加算するクエリです。
  - 1 つのクエリが完了し、もう 1 つのクエリが完了していないときに、エラーまたは停電が発生した場合、結果は悲劇的です。銀行が業務を適切に遂行しようとするなら、お金を消失させることは _できません_。
  - トランザクション内にクエリをラップすると、データベースはすべてのクエリが副作用 _ゼロ_ で失敗する、もしくはすべて成功することが担保されます。
- 相互に依存する複数のクエリを記述するときは、常に、トランザクション内で実行することをお勧めします。
- [ ] トランザクションについて、[この短いチュートリアル](https://www.tutorialspoint.com/postgresql/postgresql_transactions.htm)を完了させましょう。

#### マイグレーション

- テーブルのスキーマを変更するたびに、マイグレーション内でその変更を行います。マイグレーションとは、何らかの方法でスキーマを変更し、新しいスキーマに適合するようにデータを変更する一連のクエリです。マイグレーションはトランザクション内で _常に_ 実行されるべきです。
- `students` テーブルで、各生徒の出身地の名前が、数回繰り返し出現していることに気づいたかもしれません。非常に丁寧に修正したにもかかわらず、いくつかのミスが発生していますね。より恒久的な解決策は、出身地（町）のデータを独自のテーブルに移動し、それぞれの生徒のデータに `towns` テーブルから出身地（町）の ID を参照させることです。

  - `.sql` ファイルを作成し、トランザクション内で次の内容を実行しましょう。
    - [ ] `id` 列と `name` 列だけで、出身地（町）の新しいテーブルを作成してください。
    - [ ] `students` テーブルに記載されているすべての出身地（町）を `towns` テーブルに挿入してください。
    - [ ] `town_id` という名前の列を `students` テーブルに追加してください
    - [ ] 生徒ごとに `town_id` を `students` テーブルに追加してください
    - [ ] `students` テーブルから `town_of_origin` 列を削除してください
  - できましたか？おめでとうございます！初めてのマイグレーションを作成しました！

- 名言・格言 API を覚えていますか？データベースとそのマイグレーションを行ってみましょう。この後の作業は簡単なはずです！

## リソース

### 必修の資料一覧

- [Postgres ドキュメント](https://www.postgresql.jp/document/9.6/html/index.html)
- [簡略版 postgres チュートリアル](http://www.postgresqltutorial.com/)

### 追加（推奨）の読み物と動画

- [リレーショナルデータベースの比較](https://www.digitalocean.com/community/tutorials/sqlite-vs-mysql-vs-postgresql-a-comparison-of-relational-database-management-systems)
- [整数の自動インクリメントが失敗する理由](https://www.youtube.com/watch?v=vA0Rl6Ne5C8&t=158s) (別名、'江南スタイルが"インターネットを破壊"した方法')
- [Postgres 制約の概要](https://www.postgresql.org/docs/current/static/ddl-constraints.html)
- [結合のチュートリアル](https://www.tutorialspoint.com/postgresql/postgresql_using_joins.htm)
- [リレーションシップの一般的チュートリアル](https://support.airtable.com/hc/en-us/articles/218734758-A-beginner-s-guide-to-many-to-many-relationships)

### ハードコアな読み物

- [データベースの動作原理に関する概要](http://coding-geek.com/how-databases-work/)
- [UCBerkeley CS186 データベースシステム入門講義](https://www.youtube.com/watch?v=G58q_y0vRpo&list=PL-XXv-cvA_iBVK2QzAV-R7NMA1ZkaiR2y)

## コントリビューション

なにか問題のある箇所を見つけましたか？ 改善すべき箇所がありましたか？[私たちのカリキュラムに貢献しよう](mailto:hello@codechrysalis.io)!
