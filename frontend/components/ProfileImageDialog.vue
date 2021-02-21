<template>
  <v-dialog v-model="isDisplay" width="820px">
    <v-card>
      <v-card-title>{{ title }}</v-card-title>
      <v-row>
        <v-col cols="6" class="text-center">
          <v-card-text>
            <profileCard :user="user" :preview-flg="true" />
          </v-card-text>
        </v-col>
        <v-col cols="6"></v-col>
      </v-row>
      <v-card-actions>
        <v-row justify="center">
          <v-col cols="6">
            <v-btn @click="isDisplay = false">Close</v-btn>
          </v-col>
          <v-col cols="6" class="text-right">
            <v-btn color="red" @click="submit">OK</v-btn>
          </v-col>
        </v-row>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import ProfileCard from '@/components/ProfileCard'

export default {
  // props: {
  //   type: String,
  // },
  components: {
    ProfileCard,
  },
  props: {
    // Object形に変換
    user: Object,
  },
  data: () => ({
    isDisplay: false,
    title: '',
  }),
  mounted() {
    this.title = 'プロフィール画像変更'
  },
  methods: {
    submit() {
      this.isDisplay = false
      this.$emit('method')
    },
    closeDisplay() {
      this.isDisplay = false
    },
  },
}
</script>
