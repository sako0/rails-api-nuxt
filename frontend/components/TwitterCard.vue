<template>
  <v-card class="mx-auto" color="#1F7087" dark>
    <v-card-title>
      <v-list-item-avatar color="grey darken-3">
        <v-img
          class="elevation-6"
          alt=""
          :src="micropost.user.image_url"
        ></v-img>
      </v-list-item-avatar>
      <span class="title font-weight-light">Twitter</span>
    </v-card-title>

    <div class="d-flex flex-no-wrap justify-space-between">
      <v-card-text class="body-1">
        "Turns out semicolon-less style is easier and safer in TS because most
        gotcha edge cases are type invalid as well."
      </v-card-text>
      <v-avatar class="ma-3" size="125" tile>
        <v-img src="https://cdn.vuetifyjs.com/images/cards/foster.jpg"></v-img>
      </v-avatar>
    </div>

    <v-card-actions>
      <v-list-item class="grow">
        <v-list-item-avatar color="grey darken-3">
          <v-img
            class="elevation-6"
            alt=""
            src="https://avataaars.io/?avatarStyle=Transparent&topType=ShortHairShortCurly&accessoriesType=Prescription02&hairColor=Black&facialHairType=Blank&clotheType=Hoodie&clotheColor=White&eyeType=Default&eyebrowType=DefaultNatural&mouthType=Default&skinColor=Light"
          ></v-img>
        </v-list-item-avatar>

        <v-list-item-content>
          <v-list-item-title>Evan You</v-list-item-title>
        </v-list-item-content>

        <v-row align="center" justify="end">
          <v-icon class="mr-1"> mdi-heart</v-icon>
          <span class="subheading mr-2">256</span>
          <span class="mr-1">·</span>
          <v-icon class="mr-1"> mdi-share-variant</v-icon>
          <span class="subheading">45</span>
        </v-row>
      </v-list-item>
    </v-card-actions>
  </v-card>
</template>
<script>
export default {
  props: {
    // Object形に変換
    micropost: Object,
  },
  mounted() {
    console.log(this.micropost)
  },
}
</script>
