<template>
  <v-card v-if="posts" class="mx-auto" max-width="500" elevation="24">
    <Dialog ref="dlg" @method="postDelete($event)" />
    <v-system-bar color="green darken-1" dark> </v-system-bar>

    <v-toolbar color="green darken-1" dark>
      <v-btn to="/register" icon>
        <v-icon>mdi-pencil-plus</v-icon>
      </v-btn>

      <v-toolbar-title>登録商品一覧</v-toolbar-title>

      <v-spacer></v-spacer>
    </v-toolbar>

    <v-container fluid>
      <v-row dense>
        <v-col
          v-for="(food, index) in foods.data"
          :key="food.title"
          :cols="index === 0 ? 12 : 6"
        >
          <v-lazy
            :options="{
              threshold: 0.5,
            }"
            min-height="200"
            transition="slide-y-reverse-transition"
          >
            <v-card elevation="2" outlined shaped tile>
              <v-row>
                <v-col cols="10">
                  <v-card-title
                    v-text="food.attributes.product_name"
                  ></v-card-title>
                </v-col>
                <v-col cols="2" class="text-right">
                  <v-menu offset-y>
                    <template #activator="{ on, attrs }">
                      <v-btn text class="float-right" v-bind="attrs" v-on="on">
                        <v-icon dark> mdi-dots-horizontal </v-icon>
                      </v-btn>
                    </template>
                    <v-list>
                      <v-list-item @click="openDisplay(food.attributes)">
                        <v-list-item-title>投稿を削除する</v-list-item-title>
                      </v-list-item>
                    </v-list>
                  </v-menu>
                </v-col>
              </v-row>

              <v-card-text>
                <div>
                  単位：{{ food.attributes.par }}
                  <br />
                  カロリー：{{ food.attributes.calorie }}kcal
                  <br />
                  タンパク質：{{ food.attributes.protein }}g
                  <br />
                  脂質：{{ food.attributes.lipid }}g
                  <br />
                  炭水化物：{{ food.attributes.carbohydrate }}g
                </div>
                <v-spacer></v-spacer>
              </v-card-text>
            </v-card>
          </v-lazy>
        </v-col>
      </v-row>
    </v-container>
  </v-card>
</template>
<script>
import Dialog from './Dialog'
export default {
  components: {
    Dialog,
  },
  props: {
    foods: Object,
  },
  data: () => ({
    cards: [],
    posts: [],
  }),
  watch: {
    foods(val) {
      this.posts = val
    },
  },
  methods: {
    openDisplay(post) {
      this.$refs.dlg.id = post.product_name
      this.$refs.dlg.post_id = post.post_id
      this.$refs.dlg.type = 'postDelete'
      this.$refs.dlg.isDisplay = true
    },
    postDelete(id) {
      console.log(id)
      const url = '/api/v1/food_posts/' + id
      const headers = { 'content-type': 'application/json' }
      this.$axios
        .delete(url, { headers })
        .then((response) => {})
        .finally((response) => {
          this.$emit('getPost')
        })
    },
    closeDisplay() {
      this.$refs.dlg.$emit('closeDisplay')
    },
  },
}
</script>
