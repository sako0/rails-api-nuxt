<template>
  <v-card class="mx-auto" max-width="320" elevation="24" tile>
    <v-hover v-slot="{ hover }" @input="overlay = true">
      <label>
        <input type="file" style="display: none" @change="backgroundGet" />
        <v-skeleton-loader
          v-if="pBackgraundLoading"
          :loading="pBackgraundLoading"
          type="image"
        >
        </v-skeleton-loader>
        <v-img
          v-if="!pBackgraundLoading"
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
                    {{ user.user.name }}
                  </v-list-item-title>
                  <v-list-item-subtitle
                    >{{ user.user.profile.job }}
                  </v-list-item-subtitle>
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
      <v-card-subtitle class="pb-0"
        >{{ user.user.profile.url }}
      </v-card-subtitle>

      <v-card-text class="text--primary">
        <div>{{ user.user.profile.skills }}</div>

        <div>{{ user.user.profile.notes }}</div>
      </v-card-text>
    </div>
    <v-card-actions>
      <v-row class="text-center">
        <v-col cols="6">
          <v-btn color="orange" text> フォロー</v-btn>
        </v-col>
        <v-col col="6">
          <v-btn color="orange" text> DM</v-btn>
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
  },
  data() {
    return {
      overlay: true,
      pImageUrl: this.user.user.image,
      pBackgroundUrl: this.user.user.background_image,
      pImageUrlLoading: false,
      pBackgraundLoading: false,
      imageFile: '',
      backgroundFile: '',
    }
  },
  methods: {
    openDisplay() {
      this.$refs.imageDlg.isDisplay = true
    },
    imageGet(e) {
      if (e.target.files[0]) {
        this.pImageUrlLoading = true
        const image = e.target.files[0]
        // ここでdataにimageFileを格納する
        this.imageFile = image
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
        this.pImageUrl = this.user.user.image
        e.currentTarget.value = ''
        this.imageFile = ''
        this.$emit('imageFileGet', false)
      }
    },
    backgroundGet(e) {
      if (e.target.files[0]) {
        this.pBackgraundLoading = true
        const image = e.target.files[0]
        // ここでdataにbackgroundファイルを格納する
        this.backgroundFile = image
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
        this.pBackgroundUrl = this.user.user.background_image
        e.currentTarget.value = ''
        this.backgroundFile = ''
        this.$emit('backgroundFileGet', false)
      }
    },
  },
}
</script>
