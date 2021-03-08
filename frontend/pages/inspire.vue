<template>
  <v-row>
    <v-col class="center">
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
        <v-col cols="12" sm="12" md="4" lg="4" xl="4">
          <v-row class="mt-5">
            <v-col cols="12">
              <profileCard :user="currentUser" @getUser="getUser" />
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="12" sm="12" md="8" lg="8" xl="8">
          <v-row class="mt-5">
            <v-col cols="12">
              <foodPostCard :foods="foodPosts" />
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-col>
  </v-row>
</template>
<script>
import FoodPostCard from '~/components/FoodPostCard.vue'
import ProfileCard from '~/components/ProfileCard.vue'

export default {
  components: {
    FoodPostCard,
    ProfileCard,
  },
  middleware: 'auth',
  // created() {
  //   if (process.client) {
  //     const ActionCable = require('actioncable')
  //
  //     const cable = ActionCable.createConsumer(
  //       process.env.NUXT_ENV_RAILS_URL + '/cable'
  //     )
  //     cable.subscriptions.create('MicropostChannel', {
  //       received: (data) => {
  //         const currentUserId = this.currentUser.user.id
  //         // 新規投稿をした場合にdata.user_idのユーザにブロードキャストする
  //         if (data.method === 'create') {
  //           // サーバ側から送られてきたuser_idとcurrent_userが一致する場合
  //           if (currentUserId === data.user_id) {
  //             // 投稿の一覧を再取得
  //             this.$axios
  //               .get('api/v1/microposts')
  //               .then((response) => (this.microposts = response.data))
  //           }
  //         }
  //         // 投稿を削除した場合にdata.user_idのユーザにブロードキャストする
  //         if (data.method === 'destroy') {
  //           // オブジェクトを配列にする
  //           const arr = this.microposts.data
  //           const micropostsArr = Object.entries(arr)
  //           // micropost_idが存在するか確認
  //           for (const v of micropostsArr) {
  //             Object.entries(v)
  //             // 存在した場合はaxiosでgetを行う
  //             if (v[1].id === data.micropost_id.toString()) {
  //               // 投稿の一覧を再取得
  //               this.$axios
  //                 .get('api/v1/microposts')
  //                 .then((response) => (this.microposts = response.data))
  //               break
  //             }
  //           }
  //         }
  //       },
  //     })
  //   }
  // },
  async asyncData({ $axios, redirect }) {
    try {
      const currentUser = await $axios.get('api/v1/sessions')
      const foodPosts = await $axios.get('api/v1/food_posts')
      // 配列で返ってくるのでJSONにして返却
      console.log(foodPosts.data)
      return { currentUser: currentUser.data, foodPosts: foodPosts.data }
    } catch (err) {
      return redirect('/')
    }
  },
  data() {
    return {
      currentUser: '',
      foodPosts: '',
    }
  },
  methods: {
    getUser() {
      this.$axios.get('api/v1/sessions').then((response) => {
        console.log(response.data)
        this.currentUser = response.data
      })
    },
  },
}
</script>
