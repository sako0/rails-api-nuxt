<template>
  <v-row>
    <v-col class="center">
      <v-row>
        <v-col cols="12" sm="12" md="4" lg="4" xl="4">
          <v-row class="mt-5">
            <v-col cols="12">
              <ProfileCard :user="currentUser" @getUser="getUser" />
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="12" sm="12" md="8" lg="8" xl="8">
          <v-row class="mt-5">
            <v-col cols="12">
              <FoodPostCard :foods="foodPosts" @getPost="getPost" />
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-col>
  </v-row>
</template>
<script>
import FoodPostCard from '@/components/FoodPostCard'
import ProfileCard from '@/components/ProfileCard'

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
  data() {
    return {
      currentUser: null,
      foodPosts: null,
    }
  },
  created() {
    this.getPost()
    this.getUser()
  },
  methods: {
    getUser() {
      this.$axios.get('api/v1/sessions').then((response) => {
        this.currentUser = response.data.user
      })
    },
    getPost() {
      this.$axios.get('api/v1/food_posts').then((response) => {
        this.foodPosts = response.data
      })
    },
  },
}
</script>
