<template>
  <v-card class="mx-auto" max-width="350" elevation="24" tile>
    <v-img height="100%" :src="user.user.background_image">
      <v-row align="end" class="fill-height">
        <v-col align-self="start" class="pa-10" cols="12">
          <v-avatar class="profile" color="grey" size="100">
            <v-img :src="user.user.image"></v-img>
          </v-avatar>
        </v-col>
        <v-col class="py-0">
          <v-list-item color="rgba(0, 0, 0, .4)" dark>
            <v-list-item-content>
              <v-list-item-title class="title">
                {{ user.user.name }}
              </v-list-item-title>
              <v-list-item-subtitle>{{
                user.user.profile.job
              }}</v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </v-col>
      </v-row>
    </v-img>
  </v-card>
</template>
<script>
export default {
  props: {
    // Object形に変換
    user: Object,
  },
}
</script>
