<template>
  <v-card class="mx-auto" color="#1F7087" dark>
    <Dialog ref="dlg" type="postDelete" @method="deletePost"></Dialog>
    <v-card-title>
      <v-list-item-avatar color="grey darken-3">
        <v-img
          class="elevation-6"
          alt=""
          :src="micropost.attributes.post_user_image"
        ></v-img>
      </v-list-item-avatar>
      <v-row>
        <v-col cols="2">
          <span class="title font-weight-light">{{
            micropost.attributes.user.name
          }}</span>
        </v-col>
        <v-col cols="10">
          <v-menu offset-y>
            <template #activator="{ on, attrs }">
              <v-btn text class="float-right" v-bind="attrs" v-on="on">
                <v-icon class="font-weight-regular">
                  mdi-dots-horizontal
                </v-icon>
              </v-btn>
            </template>
            <v-list>
              <v-list-item v-if="menu.delete" @click="openDisplay()">
                <v-list-item-title>投稿を削除する</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </v-col>
      </v-row>
    </v-card-title>

    <div class="d-flex">
      <v-card-text class="body-1 ml-2 text-left">
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
        <!--        <v-list-item-content> </v-list-item-content>-->
        <v-row align="center" justify="end">
          <v-col cols="8">
            <v-card-text>
              <v-text-field label="コメントフォーム"> </v-text-field>
            </v-card-text>
          </v-col>
          <v-col cols="2">
            <v-icon class="mr-1"> mdi-heart</v-icon>
            <span class="subheading mr-2">256</span>
          </v-col>
          <v-col cols="2">
            <v-icon class="mr-1"> mdi-share-variant</v-icon>
            <span class="subheading">45</span>
          </v-col>
        </v-row>
      </v-list-item>
    </v-card-actions>
  </v-card>
</template>
<script>
import Dialog from '@/components/dialog'
export default {
  components: {
    Dialog,
  },
  props: {
    // Object形に変換
    micropost: Object,
    current_user: Object,
  },
  data() {
    return {
      menu: {
        delete: false,
      },
    }
  },
  created() {
    if (this.micropost.attributes.user.id === this.current_user.user.id) {
      this.menu.delete = true
    }
  },
  mounted() {},
  methods: {
    deletePost() {
      this.$axios
        .delete('/api/v1/microposts/' + this.micropost.id, {
          content: this.content,
        })
        .then((response) => console.log(response))
        .catch((error) => console.log(error))
    },
    openDisplay() {
      this.$refs.dlg.isDisplay = true
    },
  },
}
</script>
