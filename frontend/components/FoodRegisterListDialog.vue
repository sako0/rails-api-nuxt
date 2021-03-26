<template>
  <v-dialog v-model="isDisplay" width="600px">
    <v-card style="overflow-y: hidden">
      <v-card-title>どのバーコード情報を使用しますか？</v-card-title>
      <div v-if="!codeListOverlay">
        <v-list two-line>
          <template v-for="(item, index) in lists">
            <v-list-item :key="index" @click="selectItem(item)">
              <v-list-item-content>
                <v-list-item-title
                  class="green--text"
                  v-text="item.attributes.product_name"
                ></v-list-item-title>

                <v-list-item-subtitle
                  class="text--primary"
                  v-text="item.attributes.par"
                ></v-list-item-subtitle>

                <v-list-item-subtitle>
                  カロリー:{{ item.attributes.calorie }}kcal たんぱく質:{{
                    item.attributes.protein
                  }}g
                </v-list-item-subtitle>
                <v-list-item-subtitle>
                  脂質:{{ item.attributes.lipid }}g 炭水化物:{{
                    item.attributes.carbohydrate
                  }}g
                </v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>

            <v-divider
              v-if="index < lists.length - 1"
              :key="`second-${index}`"
            ></v-divider>
          </template>
        </v-list>
      </div>
      <div v-else>
        <v-card-text>
          <v-overlay absolute>
            <v-progress-circular indeterminate size="80"></v-progress-circular>
          </v-overlay>
        </v-card-text>
      </div>
      <v-card-actions>
        <v-row justify="center">
          <v-col cols="6">
            <v-btn @click="isDisplay = false">Close</v-btn>
          </v-col>
          <v-col cols="6" class="text-right"> </v-col>
        </v-row>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>
<script>
export default {
  props: {
    lists: Array,
  },
  data: () => ({
    isDisplay: false,
    codeListOverlay: false,
  }),
  methods: {
    selectItem(item) {
      this.isDisplay = false
      // 即座にdomを削除するとtransitionする前に消えてしまうので、200ms待つ
      setTimeout(() => {
        this.$emit('selectedItem', item)
      }, 200)
      this.reset()
    },
    reset() {
      Object.assign(this.$data, this.$options.data())
    },
  },
}
</script>
