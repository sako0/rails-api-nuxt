<template>
  <v-card max-width="600" class="mx-auto" elevation="24">
    <v-system-bar color="orange darken-4" dark>
      <v-spacer></v-spacer>
    </v-system-bar>

    <v-app-bar dark color="orange darken-3">
      <v-toolbar-title>投稿一覧</v-toolbar-title>
      <v-spacer></v-spacer>
    </v-app-bar>

    <v-container>
      <v-row dense>
        <v-col v-for="(micropost, i) in microposts.data" :key="i" cols="12">
          <twitterCard :micropost="micropost" :current_user="current_user" />
        </v-col>
      </v-row>
    </v-container>
  </v-card>
</template>

<script>
import TwitterCard from '~/components/TwitterCard.vue'

export default {
  components: {
    TwitterCard,
  },
  props: {
    // Object形に変換
    microposts: Object,
    current_user: Object,
  },
  mounted() {
    console.log(this.microposts.data)
  },
}
</script>
