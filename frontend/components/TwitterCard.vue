<template>
  <v-card class="mx-auto" color="#1F7087" dark>
    <v-card-title class="d-flex">
      <v-list-item-avatar color="grey darken-3">
        <v-img
          class="elevation-6"
          alt=""
          :src="micropost.attributes.post_user_image"
        ></v-img>
      </v-list-item-avatar>
      <span class="title font-weight-light">{{
        micropost.attributes.user.name
      }}</span>
    </v-card-title>

    <div class="d-flex flex-no-wrap justify-space-between">
      <v-card-text class="body-1 text-left">
        {{ micropost.attributes.content }}
      </v-card-text>
      <v-avatar class="d-flex ma-3" size="" tile>
        <v-img :src="micropost.attributes.image"></v-img>
      </v-avatar>
    </div>

    <v-card-actions>
      <v-list-item class="grow">
        <v-list-item-avatar color="grey darken-3">
          <v-img
            class="elevation-6"
            alt=""
            :src="current_user.user.image"
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
    current_user: Object,
  },
  mounted() {
    console.log(this.micropost)
  },
}
</script>
