<template>
  <v-card v-if="currentUser !== null" class="mx-auto" max-width="320" tile>
    <ProfileImageDialog
      ref="imageDlg"
      :user="currentUser"
      @getUser="getUser"
    ></ProfileImageDialog>
    <v-img max-height="200px" height="100%" :src="currentUser.background_image">
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
            <v-img :src="currentUser.image"></v-img>
          </v-avatar>
        </v-col>
      </v-row>
      <v-row class="text-center">
        <v-col class="pa-1">
          <v-list-item color="rgba(0, 0, 0, .4)" dark>
            <v-list-item-content>
              <v-list-item-title class="font-weight-bold">
                {{ currentUser.name }}
              </v-list-item-title>
              <v-list-item-subtitle
                >{{ currentUser.profile.age }}歳
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </v-col>
      </v-row>
    </v-img>
    <div class="text-left">
      <v-card-subtitle class="pb-0"
        >身長：{{ currentUser.profile.height }}cm
      </v-card-subtitle>

      <v-card-text class="text--primary">
        <div>目標体重：{{ currentUser.profile.target_weight }}kg</div>

        <div>一言：{{ currentUser.profile.notes }}</div>
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
  data() {
    return {
      currentUser: null,
    }
  },
  watch: {
    user(val) {
      this.currentUser = val
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
