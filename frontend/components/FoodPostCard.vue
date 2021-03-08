<template>
  <v-card class="mx-auto" max-width="500" elevation="24">
    <v-system-bar color="indigo darken-2" dark> </v-system-bar>

    <v-toolbar color="indigo" dark>
      <v-app-bar-nav-icon></v-app-bar-nav-icon>

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
          <v-card color="grey darken-2">
            <v-img
              :src="
                food.image
                  ? food.image
                  : 'https://cdn.vuetifyjs.com/images/cards/house.jpg'
              "
              class="white--text align-start"
              gradient="to bottom, rgba(0,0,0,.1), rgba(0,0,0,.5)"
              height="200px"
            >
              <v-card-title
                v-text="food.attributes.product_name"
              ></v-card-title>
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
export default {
  props: {
    foods: Object,
  },
  data: () => ({
    cards: [
      {
        title: 'Pre-fab homes',
        src: 'https://cdn.vuetifyjs.com/images/cards/house.jpg',
        flex: 12,
      },
      {
        title: 'Favorite road trips',
        src: 'https://cdn.vuetifyjs.com/images/cards/road.jpg',
        flex: 6,
      },
      {
        title: 'Best airlines',
        src: 'https://cdn.vuetifyjs.com/images/cards/plane.jpg',
        flex: 6,
      },
    ],
  }),
}
</script>
