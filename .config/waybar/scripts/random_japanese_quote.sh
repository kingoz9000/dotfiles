#!/bin/bash

TMP_FILE="/tmp/random_japanese_quote.txt"

declare -A japanese_quotes

japanese_quotes["これはペンです。"]="This is a pen.\nGrammar: です – Copula (to be); basic sentence ending."
japanese_quotes["あれは日本の車じゃないです。"]="That is not a Japanese car.\nGrammar: じゃないです – Negative polite form of です."
japanese_quotes["私は猫が好きです。"]="I like cats.\nGrammar: 〜が好き – Expressing likes; subject marked with が."
japanese_quotes["毎週土曜日にジムに行きます。"]="I go to the gym every Saturday.\nGrammar: に – Time particle; 行きます – polite form of 'go'."
japanese_quotes["公園に犬がいます。"]="There is a dog in the park.\nGrammar: 〜に〜がいます – Existence of animate objects."
japanese_quotes["テーブルの上に本があります。"]="There is a book on the table.\nGrammar: 〜に〜があります – Existence of inanimate objects."
japanese_quotes["ドアを閉めてください。"]="Please close the door.\nGrammar: 〜てください – Polite request form."
japanese_quotes["トイレに行ってもいいですか。"]="May I go to the bathroom?\nGrammar: 〜てもいいですか – Asking permission."
japanese_quotes["ここでたばこを吸ってはいけません。"]="You must not smoke here.\nGrammar: 〜てはいけません – Prohibition expression."
japanese_quotes["映画を見ましょう。"]="Let’s watch a movie.\nGrammar: 〜ましょう – Invitation form ('Let's do...')."
japanese_quotes["手伝いましょうか？"]="Shall I help you?\nGrammar: 〜ましょうか – Offering to do something politely."

# GENKI II
japanese_quotes["明日は雨が降るそうです。"]="It seems like it's going to rain tomorrow.\nGrammar: 〜そうです – Seems like."
japanese_quotes["このケーキはおいしそうですね。"]="This cake looks delicious.\nGrammar: 〜そう – Appears/seems like; based on observation."
japanese_quotes["音楽を聞きながら勉強します。"]="I study while listening to music.\nGrammar: 〜ながら – Two actions done simultaneously."
japanese_quotes["この店は安いし、おいしいし、よく行きます。"]="This restaurant is cheap, tasty, and I often go there.\nGrammar: 〜し〜し – Listing multiple reasons."
japanese_quotes["雨が降ったら、家にいます。"]="If it rains, I’ll stay home.\nGrammar: 〜たら – Conditional ('if/when')."
japanese_quotes["宿題を忘れてしまいました。"]="I (regretfully) forgot my homework.\nGrammar: 〜てしまいました – Completion or regret."
japanese_quotes["春になると、花が咲きます。"]="When spring comes, flowers bloom.\nGrammar: 〜と – Natural consequence; habitual result."
japanese_quotes["来年、日本に行こうと思っています。"]="I’m thinking of going to Japan next year.\nGrammar: 〜(よ)うと思っています – Expressing intention."

# Kansai
japanese_quotes["なんでやねん！"]="What the heck!\nGrammar: やねん – Emphatic Kansai sentence ender often used for comedic or emotional punch."
japanese_quotes["めっちゃうまいやん。"]="It’s super tasty, right?\nGrammar: めっちゃ – Kansai adverb meaning 'very'; やん – soft assertion, similar to じゃん in Kanto-ben."
japanese_quotes["あかん、忘れてたわ。"]="Crap, I forgot.\nGrammar: あかん – Kansai equivalent of だめ (not good); わ – casual sentence ending particle."
japanese_quotes["ほんまにありがと！"]="Really, thank you!\nGrammar: ほんま – Kansai equivalent of 本当 (really); used for sincerity or emphasis."
japanese_quotes["知らんわ、そんなもん。"]="I don’t know about that stuff.\nGrammar: 知らん – Kansai plain negative of 知る (to know); 〜もん – informal 'thing'; わ – emotional tone."
japanese_quotes["そんなん言わんといて。"]="Don’t say stuff like that.\nGrammar: 〜んといて – Kansai form of 'don’t do [verb]'; softer than 禁止形 (prohibitive form)."
japanese_quotes["行かへんわ。"]="I’m not going.\nGrammar: 行かへん – Kansai negative form of 行く (to go); replaces 〜ない."
japanese_quotes["なんぼするん？"]="How much is it?\nGrammar: なんぼ – Kansai word for 'how much'; more casual than いくら."
japanese_quotes["めっちゃ寒いなぁ。"]="It’s super cold, huh?\nGrammar: めっちゃ – 'Very'; なぁ – sentence-ending particle for reflection or agreement."
japanese_quotes["ちょっと待ってや。"]="Hold on a sec.\nGrammar: 〜てや – Kansai equivalent of 〜てよ; adds soft emphasis or friendliness."

# Andi-videoes
japanese_quotes["天気予報によると、明日は晴れるそうです。"]="According to the weather forecast(てんきよほう), it seems like it will be sunny tomorrow.\nGrammar: 〜によると – According to; 〜そうです – Seems like."
japanese_quotes["あの人は安藤さんの友達だそうです。"]="I heard that person is Ando-san's friend.\nGrammar: 〜そうです – Reported speech; hearsay."

# Transsivitive and Intransitive Verbs
japanese_quotes["携帯を落とさなかった！落ちたよ！"]="I didn't drop my phone! It fell!\nGrammar: 落とさなかった – Transitive verb (did not drop); 落ちた – Intransitive verb (fell)."




keys=("${!japanese_quotes[@]}")
random_key="${keys[RANDOM % ${#keys[@]}]}"
random_val="${japanese_quotes[$random_key]}"

# Escape quotes for JSON safety (basic handling)
escaped_jp=$(echo "$random_key" | sed 's/"/\\"/g')
escaped_en=$(echo "$random_val" | sed 's/"/\\"/g')

# Output clean JSON
printf '{"text":"%s","tooltip":"%s"}\n' "$escaped_jp" "$escaped_en"
