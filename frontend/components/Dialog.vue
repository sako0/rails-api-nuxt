<template>
  <v-dialog v-model="isDisplay" width="400px">
    <v-card>
      <v-card-title>{{ title }}</v-card-title>
      <v-card-text>{{ content }}</v-card-text>
      <v-row v-if="type === 'foodRegister'" justify="center">
        <v-col cols="5">
          <v-btn class="mx-2" dark color="indigo" @click="code_exist">
            <v-icon dark> mdi-barcode-scan </v-icon>
            バーコードあり
          </v-btn>
        </v-col>
        <v-col cols="6">
          <v-btn class="mx-2" dark color="indigo" @click="no_code">
            <v-icon dark> mdi-barcode-off </v-icon>
            バーコードなし
          </v-btn>
        </v-col>
      </v-row>
      <v-card-actions>
        <v-row justify="center">
          <v-col cols="6">
            <v-btn @click="isDisplay = false">Close</v-btn>
          </v-col>
          <v-col cols="6" class="text-right">
            <v-btn v-if="type === 'postDelete'" color="red" @click="submit"
              >OK</v-btn
            >
          </v-col>
        </v-row>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    type: String,
    content: String,
  },
  data: () => ({
    isDisplay: false,
    title: '',
  }),
  mounted() {
    if (this.type === 'postDelete') {
      this.title = '投稿を削除しますか？'
    }
    if (this.type === 'foodRegister') {
      this.title = 'バーコードはありますか？'
    }
  },
  methods: {
    submit() {
      this.isDisplay = false
      this.$emit('method')
    },
    closeDisplay() {
      this.isDisplay = false
    },
    code_exist() {
      this.isDisplay = false
      // 即座にdomを削除するとtransitionする前に消えてしまうので、200ms待つ
      setTimeout(() => {
        this.$emit('code_exist')
      }, 200)
    },
    no_code() {
      this.isDisplay = false
      this.$emit('no_code')
    },
  },
}
</script>
