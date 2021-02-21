<template>
  <v-card class="mx-auto" max-width="320" elevation="24" tile>
    <ProfileImageDialog ref="imageDlg" :user="user"></ProfileImageDialog>
    <v-img height="100%" :src="user.user.background_image">
      <v-row>
        <v-col cols="2">
          <v-btn
            v-if="previewFlg === false"
            icon
            color="white"
            dark
            class="ma-2"
            elevation="24"
            @click="openDisplay"
          >
            <v-icon dark> mdi-cog </v-icon>
          </v-btn>
        </v-col>
        <v-col cols="10"> </v-col>
      </v-row>
      <v-row justify="center">
        <v-col class="pa-0" cols="12">
          <v-avatar class="profile" color="grey" size="100">
            <v-img :src="user.user.image"></v-img>
          </v-avatar>
        </v-col>
      </v-row>
      <v-row>
        <v-col class="pa-1">
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
    <v-card-subtitle class="pb-0">{{ user.user.profile.url }}</v-card-subtitle>

    <v-card-text class="text--primary">
      <div>{{ user.user.profile.skills }}</div>

      <div>{{ user.user.profile.notes }}</div>
    </v-card-text>

    <v-card-actions>
      <v-row>
        <v-col cols="6">
          <v-btn color="orange" text> フォロー </v-btn>
        </v-col>
        <v-col col="6">
          <v-btn color="orange" text> DM </v-btn>
        </v-col>
      </v-row>
    </v-card-actions>
  </v-card>
</template>
<script>
export default {
  props: {
    // Object形に変換
    user: Object,
    previewFlg: Boolean,
  },
  methods: {
    openDisplay() {
      this.$refs.imageDlg.isDisplay = true
    },
  },
}
</script>
