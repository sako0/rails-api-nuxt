<template>
  <v-row>
    <v-col class="text-center">
      <!--      <img src="/v.png" alt="Vuetify.js" class="mb-5" />-->
      <v-parallax
        height="100"
        src="https://cdn.vuetifyjs.com/images/parallax/material2.jpg"
      >
        <blockquote class="blockquote text-left">
          Welcome. {{ currentUser.user.name }}.
        </blockquote>
      </v-parallax>
      <v-row>
        <v-col cols="4">
          <v-row class="mt-5">
            <v-col cols="12">
              <profileCard :user="currentUser" />
            </v-col>
            <v-col cols="12">
              <CardImage />
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="8">
          <v-row class="mt-5">
            <v-col cols="12">
              <horizontalCards
                :microposts="microposts"
                :current_user="currentUser"
              />
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-col>
  </v-row>
</template>
<script>
import CardImage from '~/components/Card_image.vue'
import HorizontalCards from '~/components/HorizontalCards.vue'
import ProfileCard from '~/components/ProfileCard.vue'

export default {
  components: {
    CardImage,
    HorizontalCards,
    ProfileCard,
  },
  middleware: 'auth',
  async asyncData({ $axios, $auth }) {
    $auth.$storage.removeState('user_id')
    const currentUser = await $axios.get('api/v1/sessions')
    $auth.$storage.setState('user_id', currentUser.data.user.id)
    const microposts = await $axios.get('api/v1/microposts')
    console.log(microposts)
    // 配列で返ってくるのでJSONにして返却
    return { currentUser: currentUser.data, microposts: microposts.data }
  },
  created() {
    if (process.client) {
      const ActionCable = require('actioncable')

      const cable = ActionCable.createConsumer('http://localhost:3000/cable')
      cable.subscriptions.create('MicropostChannel', {
        received: (data) => {
          const currentUserId = this.currentUser.user.id
          // 新規投稿をした場合にdata.user_idのユーザにブロードキャストする
          if (data.method === 'create') {
            // サーバ側から送られてきたuser_idとcurrent_userが一致する場合
            if (currentUserId === data.user_id) {
              // 投稿の一覧を再取得
              this.$axios
                .get('api/v1/microposts')
                .then((response) => (this.microposts = response.data))
            }
          }
          // 投稿を削除した場合にdata.user_idのユーザにブロードキャストする
          if (data.method === 'destroy') {
            // オブジェクトを配列にする
            const arr = this.microposts.data
            const micropostsArr = Object.entries(arr)
            // micropost_idが存在するか確認
            for (const v of micropostsArr) {
              Object.entries(v)
              // 存在した場合はaxiosでgetを行う
              if (v[1].id === data.micropost_id.toString()) {
                // 投稿の一覧を再取得
                this.$axios
                  .get('api/v1/microposts')
                  .then((response) => (this.microposts = response.data))
                break
              }
            }
          }
        },
      })
    }
  },
  mounted() {},
}
</script>
