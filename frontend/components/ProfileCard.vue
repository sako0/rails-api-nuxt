<template>
  <v-card v-if="user" class="mx-auto" max-width="320" tile>
    <ProfileImageDialog
      ref="imageDlg"
      :user="user"
      @getUser="getUser"
    ></ProfileImageDialog>
    <v-img max-height="200px" height="100%" :src="background_image">
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
            <v-img :src="image"></v-img>
          </v-avatar>
        </v-col>
      </v-row>
      <v-row class="text-center">
        <v-col class="pa-1">
          <v-list-item color="rgba(0, 0, 0, .4)" dark>
            <v-list-item-content>
              <v-list-item-title class="font-weight-bold">
                {{ user.name }}
              </v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-col>
      </v-row>
    </v-img>
    <div class="text-left">
      <v-card-text class="text--primary">
        <div>{{ user.profile.age }}歳</div>
        <div>身長：{{ user.profile.height }}cm</div>
        <div>目標体重：{{ user.profile.target_weight }}kg</div>
        <div>一言：{{ user.profile.notes }}</div>
      </v-card-text>
    </div>
  </v-card>
</template>
<script>
import ProfileImageDialog from '@/components/ProfileImageDialog'
export default {
  components: {
    ProfileImageDialog,
  },
  props: {
    // Object形に変換
    user: Object,
  },
  computed: {
    background_image() {
      if (this.user.background_image) {
        return this.user.background_image
      } else {
        return 'https://season-freeillust.com/img/others-haikei/03.jpg'
      }
    },
    image() {
      if (this.user.image) {
        return this.user.image
      } else {
        return 'http://gahag.net/img/201510/04s/gahag-0010787309-1.jpg'
      }
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
