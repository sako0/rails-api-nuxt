<template>
  <v-dialog v-model="isDisplay" width="400px">
    <v-card>
      <v-card-title>{{ title }}</v-card-title>
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
export default {
  props: {
    type: String,
  },
  data: () => ({
    isDisplay: false,
    title: '',
  }),
  mounted() {
    if (this.type === 'postDelete') {
      this.title = '投稿を削除しますか？'
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
  },
}
</script>
