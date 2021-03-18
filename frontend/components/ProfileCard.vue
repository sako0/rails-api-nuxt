<template>
  <v-card class="mx-auto" max-width="320" tile>
    <ProfileImageDialog
      ref="imageDlg"
      :user="user"
      @getUser="getUser"
    ></ProfileImageDialog>
    <v-img
      max-height="200px"
      height="100%"
      :src="userComputed.user.background_image"
    >
      <v-row>
        <v-col cols="2">
          <v-btn
            icon
            color="white"
            dark
            class="ma-2"
            elevation="24"
            max-height="20px"
            @click="openDisplay"
          >
            <v-icon dark> mdi-cog</v-icon>
          </v-btn>
        </v-col>
        <v-col cols="10"></v-col>
      </v-row>
      <v-row justify="center" class="text-center">
        <v-col class="pa-0" cols="12">
          <v-avatar class="profile" color="grey" size="100">
            <v-img :src="userComputed.user.image"></v-img>
          </v-avatar>
        </v-col>
      </v-row>
      <v-row class="text-center">
        <v-col class="pa-1">
          <v-list-item color="rgba(0, 0, 0, .4)" dark>
            <v-list-item-content>
              <v-list-item-title class="title">
                {{ userComputed.user.name }}
              </v-list-item-title>
              <v-list-item-subtitle
                >{{ userComputed.user.profile.url }}
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </v-col>
      </v-row>
    </v-img>
    <div class="text-left">
      <v-card-subtitle class="pb-0"
        >{{ userComputed.user.profile.url }}
      </v-card-subtitle>

      <v-card-text class="text--primary">
        <div>{{ userComputed.user.profile.trend }}</div>

        <div>{{ userComputed.user.profile.notes }}</div>
      </v-card-text>
    </div>
    <!--    <v-card-actions>-->
    <!--      <v-row class="text-center">-->
    <!--        <v-col cols="6">-->
    <!--          <v-btn color="orange" text> フォロー</v-btn>-->
    <!--        </v-col>-->
    <!--        <v-col col="6">-->
    <!--          <v-btn color="orange" text> DM</v-btn>-->
    <!--        </v-col>-->
    <!--      </v-row>-->
    <!--    </v-card-actions>-->
  </v-card>
</template>
<script>
export default {
  props: {
    // Object形に変換
    user: Object,
  },
  computed: {
    userComputed: {
      get() {
        return this.$props.user
      },
      set(value) {
        this.$emit('change', value)
      },
    },
  },
  methods: {
    openDisplay() {
      this.$refs.imageDlg.isDisplay = true
    },
    getUser() {
      this.$emit('getUser')
    },
  },
}
</script>
