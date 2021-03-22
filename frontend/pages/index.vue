<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      <v-card>
        <v-card-title class="font-weight-bold">
          ダイエットリーダへようこそ！
        </v-card-title>
        <v-card-text> 日々の食事のカロリー等を記録するアプリです </v-card-text>
        <v-card-text>
          ダイエットをしよう！と決意したら必須になってくるのが、日々の食事の記録。私自身もこれまで何度か摂取カロリーを記録するアプリなどを試してきたのですが、毎回何かを食べるたびにカロリーや栄養素など記録するというのが結構手間で、長く続きませんでした・・・
        </v-card-text>
        <v-card-text>
          でもダイエットは成功させたいし・・・というわけでなるべくカロリー入力の手間をなくすというコンセプトで開発したのがこのアプリです！
        </v-card-text>
        <v-card-text> 使い方はこんな感じです↓ </v-card-text>
        <v-card-text>
          １.食品に記載されているバーコードをスマホのカメラで読み取る
        </v-card-text>
        <v-card-text> ２.カロリーなどの情報を入力して保存 </v-card-text>
        <v-card-text>
          一度入力したバーコードの情報は自分だけではなく全てのユーザが使えるようになります！
          誰かが同じ商品を登録していたら、
          <p class="font-weight-bold">
            カロリー等を入力しなくても、バーコード読み取り→保存だけで自動で栄養素等を登録できるようになります！
          </p>
        </v-card-text>
        <v-card-text>
          どんどん時短して浮いた時間でドーナツでも食べましょう！
        </v-card-text>

        <v-card-actions>
          <v-spacer />
          <v-btn dark color="green darken-1" nuxt to="/register">
            始める！
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
export default {
  auth: false,
}
</script>
