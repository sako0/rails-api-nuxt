<template>
  <v-dialog v-model="isDisplay" width="400px">
    <v-card>
      <v-tabs v-model="tab" background-color="transparent" color="basil" grow>
        <v-tabs-slider color="transparent"></v-tabs-slider>
        <v-tab v-for="item in items" :key="item"> </v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item v-for="item in items" :key="item">
          <v-card-title>{{ item }}</v-card-title>
          <v-card-text>{{ content }}</v-card-text>
          <v-row v-if="type === 'foodRegister'">
            <v-col cols="1" sm="1" md="1" lg="1" xl="1"> </v-col>
            <v-col cols="4" sm="4" md="4" lg="4" xl="4" class="text-center">
              <v-btn
                class="text-caption"
                dark
                color="indigo"
                @click="code_exist"
              >
                <v-icon dark> mdi-barcode-scan </v-icon>
                バーコードあり
              </v-btn>
            </v-col>
            <v-col cols="1" sm="1" md="1" lg="1" xl="1"> </v-col>
            <v-col cols="4" sm="4" md="4" lg="4" xl="4">
              <v-btn class="text-caption" dark color="indigo" @click="no_code">
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
        </v-tab-item>
      </v-tabs-items>
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
    tab: 0,
    items: [''],
  }),
  mounted() {
    if (this.type === 'postDelete') {
      this.items = ['投稿を削除しますか？']
    }
    if (this.type === 'foodRegister') {
      this.items = ['バーコードはありますか？']
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
