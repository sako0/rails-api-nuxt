<template>
  <v-card class="mx-auto" max-width="320" elevation="24" tile>
    <v-hover v-slot="{ hover }" @input="overlay = true">
      <label>
        <input
          type="file"
          accept="image/jpeg,image/png,image/bmp"
          style="display: none"
          @change="backgroundGet"
        />
        <v-skeleton-loader
          v-if="pBackgraundLoading"
          :loading="pBackgraundLoading"
          type="image"
        >
        </v-skeleton-loader>
        <v-img
          v-if="!pBackgraundLoading"
          max-height="200px"
          height="100%"
          :src="pBackgroundUrl"
          :elevation="hover ? 24 : 2"
          :class="{ 'on-hover': hover }"
          @mouseenter="overlay = true"
          @mouseover="overlay = true"
        >
          <v-row>
            <v-col cols="3">
              <v-icon dark class="pt-4"> mdi-file-image-outline</v-icon>
            </v-col>
            <v-col cols="9"></v-col>
          </v-row>
          <v-row justify="center" class="text-center">
            <v-col class="pa-0" cols="12">
              <template>
                <div class="image-input">
                  <label>
                    <v-hover v-slot="{ hover }" @input="overlay = false">
                      <v-avatar
                        class="profile"
                        color="grey"
                        size="100"
                        style="z-index: 10"
                        :class="{ 'on-hover': hover }"
                        @mouseover="overlay = false"
                        @mousemove="overlay = false"
                        @mouseenter="overlay = false"
                        @mouseout="overlay = true"
                      >
                        <v-img v-if="!pImageUrlLoading" :src="pImageUrl">
                          <v-icon dark class="pt-4"> mdi-tooltip-image</v-icon>
                        </v-img>

                        <input
                          type="file"
                          accept="image/jpeg,image/png,image/bmp"
                          style="display: none"
                          @change="imageGet"
                        />
                        <v-fade-transition>
                          <v-overlay
                            v-if="hover"
                            absolute
                            color="orange lighten-2"
                          >
                          </v-overlay>
                          <v-overlay
                            v-if="hover === false"
                            absolute
                            :opacity="0"
                          >
                          </v-overlay>
                        </v-fade-transition>
                        <v-skeleton-loader
                          v-if="pImageUrlLoading"
                          :loading="pImageUrlLoading"
                          type="avatar"
                        >
                        </v-skeleton-loader>
                      </v-avatar>
                    </v-hover>
                  </label>
                </div>
              </template>
            </v-col>
          </v-row>
          <v-row class="text-center">
            <v-col class="pa-1">
              <v-list-item color="rgba(0, 0, 0, .4)" dark>
                <v-list-item-content>
                  <v-list-item-title class="title">
                    {{ user.name }}
                  </v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </v-col>
          </v-row>
          <v-fade-transition>
            <v-overlay
              v-if="hover"
              absolute
              :value="overlay"
              :z-index="1"
              color="orange lighten-2"
            >
            </v-overlay>
            <v-overlay v-if="hover === false" absolute :opacity="0">
            </v-overlay>
          </v-fade-transition>
        </v-img>
      </label>
    </v-hover>
    <div class="text-left">
      <v-card-text class="text--primary">
        <div>{{ user.profile.age }}歳</div>
        <div>身長：{{ user.profile.height }}cm</div>
        <div>目標体重：{{ user.profile.target_weight }}kg</div>

        <div>一言：{{ user.profile.notes }}</div>
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
  data() {
    return {
      overlay: true,
      pImageUrlLoading: false,
      pBackgraundLoading: false,
      previewImage: null,
      previewBackground: null,
    }
  },
  computed: {
    pBackgroundUrl: {
      get() {
        if (this.previewBackground) {
          return this.previewBackground
        } else if (this.user.background_image) {
          return this.user.background_image
        } else {
          return 'https://season-freeillust.com/img/others-haikei/03.jpg'
        }
      },
      set(val) {
        this.previewBackground = val
      },
    },
    pImageUrl: {
      get() {
        if (this.previewImage) {
          return this.previewImage
        } else if (this.user.image) {
          return this.user.image
        } else {
          return 'http://gahag.net/img/201510/04s/gahag-0010787309-1.jpg'
        }
      },
      set(val) {
        this.previewImage = val
      },
    },
  },
  methods: {
    openDisplay() {
      this.$refs.imageDlg.isDisplay = true
    },
    imageGet(e) {
      if (e.target.files[0]) {
        this.pImageUrlLoading = true
        const image = e.target.files[0]
        const url = `/api/v1/profiles`
        const data = new FormData()
        data.append('image', image)
        const headers = { 'content-type': 'multipart/form-data' }
        this.$axios
          .post(url, data, { headers })
          .then((response) => {
            this.pImageUrl = response.data
            this.$emit('imageFileGet', image)
            this.pImageUrlLoading = false
          })
          .catch((error) => console.log(error))
      } else {
        this.pImageUrl = this.user.image
        e.currentTarget.value = ''
        this.$emit('imageFileGet', false)
      }
    },
    backgroundGet(e) {
      if (e.target.files[0]) {
        this.pBackgraundLoading = true
        const image = e.target.files[0]
        const url = `/api/v1/profiles`
        const data = new FormData()
        data.append('background', image)
        const headers = { 'content-type': 'multipart/form-data' }
        this.$axios
          .post(url, data, { headers })
          .then((response) => {
            this.pBackgroundUrl = response.data
            this.$emit('backgroundFileGet', image)
            this.pBackgraundLoading = false
          })
          .catch((error) => console.log(error))
      } else {
        this.pBackgroundUrl = this.user.background_image
        e.currentTarget.value = ''
        this.$emit('backgroundFileGet', false)
      }
    },
  },
}
</script>
