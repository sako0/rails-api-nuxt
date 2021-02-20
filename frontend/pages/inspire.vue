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
                @myEvent="postClick"
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
          console.log(data.method)
          console.log(currentUserId)
          if (data.method === 'create') {
            // 投稿者と投稿が見れる全員に対して行われる処理
            // サーバー側から受け取ったHTMLを一番上に加える
            if (currentUserId === data.user_id) {
              this.$axios
                .get('api/v1/microposts')
                .then((response) => (this.microposts = response.data))
            }
            // 投稿者の場合のみフォームをクリアする
            if (data.post_user_id === currentUserId) {
              // フォームのリセット処理をここに記載する
            }
          }
        },
      })
    }
  },
  mounted() {},
}
</script>
