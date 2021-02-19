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
              <horizontalCards :microposts="microposts" />
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
  async asyncData({ $axios }) {
    const currentUser = await $axios.get('api/v1/sessions')
    const microposts = await $axios.get('api/v1/microposts')
    // 配列で返ってくるのでJSONにして返却
    return { currentUser: currentUser.data, microposts: microposts.data }
  },
  mounted() {
    console.log(this.microposts)
  },
  //   const url = 'api/v1/sessions'
  //   const token = this.$auth.strategy.token.get()
  //   // headerにログイン時に受け取ったtokenをセット
  //   this.$auth.strategy.token.set(token)
  //   // user情報を取得
  //   const currentUser = this.$axios.get(url).then((res) => {
  //     console.log(res)
  //   })
  //   console.log(currentUser)
  //   return { currentUser }
  // },
}
</script>
