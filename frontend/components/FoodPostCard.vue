<template>
  <v-card class="mx-auto" max-width="500" elevation="24">
    <Dialog ref="dlg" @method="deletePost" />
    <v-system-bar color="green darken-1" dark> </v-system-bar>

    <v-toolbar color="green darken-1" dark>
      <v-btn icon>
        <v-icon>mdi-pencil-plus</v-icon>
      </v-btn>

      <v-toolbar-title>登録商品一覧</v-toolbar-title>

      <v-spacer></v-spacer>

      <v-btn icon>
        <v-icon>mdi-magnify</v-icon>
      </v-btn>
    </v-toolbar>

    <v-container fluid>
      <v-row dense>
        <v-col
          v-for="(food, index) in foods.data"
          :key="food.title"
          :cols="index === 0 ? 12 : 6"
        >
          <v-card color="grey darken-1" dark>
            <v-img
              :src="
                food.attributes.image
                  ? food.attributes.image
                  : 'https://cdn.vuetifyjs.com/images/cards/house.jpg'
              "
              class="white--text align-start"
              gradient="to bottom, rgba(0,0,0,.1), rgba(0,0,0,.5)"
              height="200px"
            >
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
                      <v-list-item @click="openDisplay()">
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
              </v-card-text>
            </v-img>

            <v-card-actions>
              <v-spacer></v-spacer>

              <v-btn icon>
                <v-icon>mdi-heart</v-icon>
              </v-btn>

              <v-btn icon>
                <v-icon>mdi-bookmark</v-icon>
              </v-btn>

              <v-btn icon>
                <v-icon>mdi-share-variant</v-icon>
              </v-btn>
            </v-card-actions>
          </v-card>
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
  }),
  methods: {
    openDisplay() {
      this.$refs.dlg.type = 'postDelete'
      this.$refs.dlg.isDisplay = true
    },
    deletePost() {
      this.$axios
        .delete('/api/v1/microposts/' + this.micropost.id, {
          content: this.content,
        })
        .then(this.closeDisplay)
        .catch((error) => console.log(error))
    },
    closeDisplay() {
      this.$refs.dlg.$emit('closeDisplay')
    },
  },
}
</script>
