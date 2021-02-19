<template>
  <v-card max-width="600" class="mx-auto" elevation="24">
    <v-system-bar color="orange darken-4" dark>
      <v-spacer></v-spacer>
    </v-system-bar>

    <v-app-bar dark color="orange darken-3">
      <v-toolbar-title>投稿一覧</v-toolbar-title>
      <v-spacer></v-spacer>
    </v-app-bar>
    <v-card-text>
      <v-text-field v-model="content" label="投稿用メッセージフォーム">
      </v-text-field>
    </v-card-text>
    <v-card-actions>
      <v-btn text @click="submit">送信する</v-btn>
      <span v-if="success">送信成功！</span>
    </v-card-actions>
    <v-divider></v-divider>
    <v-container>
      <v-row dense>
        <v-col
          v-for="(micropost, i) in micropostsComputed.data"
          :key="i"
          cols="12"
        >
          <twitterCard :micropost="micropost" :current_user="current_user" />
        </v-col>
      </v-row>
    </v-container>
  </v-card>
</template>

<script>
// import axios from '@/plugins/axios'
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
  data() {
    return {
      content: '',
      // 送信が成功したかどうかのフラグ
      success: false,
    }
  },
  computed: {
    micropostsComputed: {
      get() {
        return this.microposts
      },
      set(value) {
        this.$emit('input', this.microposts) // おやでは @input に書いたメソッドがよばれる。引数にvalue
      },
    },
  },
  mounted() {
    console.log(this.microposts.data)
  },
  methods: {
    submit() {
      this.success = true
      this.$axios
        .post('/api/v1/microposts', {
          content: this.content,
        })
        .then((response) => this.$emit('myEvent', 'success'))
        .catch((error) => console.log(error))
    },
  },
}
</script>
