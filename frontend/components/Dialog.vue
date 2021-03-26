<template>
  <v-dialog v-model="isDisplay" width="400px">
    <v-card style="overflow-y: hidden">
      <v-card-title>{{ title }}</v-card-title>
      <v-card-text v-if="type === 'postDelete'">
        「{{ this.id }}」をデータベースから削除しますか？
      </v-card-text>
      <v-card-text v-if="type === 'foodRegister'">
        <v-container>
          {{ content }}
          <v-row justify="center">
            <v-col cols="6" sm="6" md="6" lg="6" xl="6" class="text-center">
              <v-btn
                class="font-weight-light"
                dark
                color="green darken-1"
                @click="code_exist"
              >
                <v-icon dark> mdi-barcode-scan </v-icon>
                あり！
              </v-btn>
            </v-col>
            <v-col cols="6" sm="6" md="6" lg="6" xl="6" class="text-center">
              <v-btn
                class="font-weight-light"
                dark
                color="green darken-1"
                @click="no_code"
              >
                <v-icon dark> mdi-barcode-off </v-icon>
                なし！
              </v-btn>
            </v-col>
          </v-row>
        </v-container>
      </v-card-text>
      <v-card-actions>
        <v-container>
          <v-row justify="center">
            <v-col cols="6">
              <v-btn @click="isDisplay = false">Close</v-btn>
            </v-col>
            <v-col cols="6" class="text-right">
              <v-btn
                v-if="type === 'postDelete'"
                dark
                color="red"
                @click="submit"
                >OK</v-btn
              >
              <v-btn
                v-if="type === 'eatDelete'"
                dark
                color="red"
                elevation="6"
                @click="eatSubmit"
                >OK</v-btn
              >
            </v-col>
          </v-row>
        </v-container>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    content: String,
  },
  data: () => ({
    isDisplay: false,
    title: '',
    id: null,
    post_id: null,
    type: null,
  }),
  watch: {
    type(val) {
      switch (val) {
        case 'postDelete':
          this.title = '削除'
          break
        case 'foodRegister':
          this.title = 'バーコードはありますか？'
          break
        case 'eatDelete':
          this.title = '削除しますか？'
          break
      }
    },
  },
  methods: {
    submit() {
      this.isDisplay = false
      console.log(this.post_id)
      this.$emit('method', this.post_id)
      this.reset()
    },
    closeDisplay() {
      this.reset()
      this.isDisplay = false
    },
    code_exist() {
      this.isDisplay = false
      // 即座にdomを削除するとtransitionする前に消えてしまうので、200ms待つ
      setTimeout(() => {
        this.$emit('code_exist')
      }, 200)
      this.reset()
    },
    no_code() {
      this.isDisplay = false
      // 即座にdomを削除するとtransitionする前に消えてしまうので、200ms待つ
      setTimeout(() => {
        this.$emit('no_code')
      }, 200)
      this.reset()
    },
    eatSubmit() {
      this.isDisplay = false
      this.$emit('eatDelete', this.id)
      this.reset()
    },
    reset() {
      Object.assign(this.$data, this.$options.data())
    },
  },
}
</script>
