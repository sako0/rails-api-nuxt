<template>
  <v-dialog v-model="commentDlgIsDisplay" width="50%" scrollable>
    <v-card>
      <v-card-title>投稿コメント</v-card-title>

      <v-card-text style="max-height: 600px">
        <v-card class="mx-auto" color="#1F7087" dark>
          <v-card-title>
            <v-row>
              <v-col cols="1" class="text-left">
                <v-menu
                  v-model="menu.profileIcon"
                  bottom
                  right
                  transition="scale-transition"
                  origin="top left"
                >
                  <template #activator="{ on, attrs }">
                    <v-btn icon v-bind="attrs">
                      <v-avatar color="grey darken-3" v-on="on">
                        <v-img
                          :src="micropost.attributes.post_user_image"
                        ></v-img>
                      </v-avatar>
                    </v-btn>
                  </template>
                  <v-card width="300">
                    <v-list dark>
                      <v-list-item>
                        <v-list-item-avatar>
                          <v-img
                            :src="micropost.attributes.post_user_image"
                          ></v-img>
                        </v-list-item-avatar>
                        <v-list-item-content>
                          <v-list-item-title>{{
                            micropost.attributes.user.name
                          }}</v-list-item-title>
                          <v-list-item-subtitle>{{
                            micropost.attributes.user.email
                          }}</v-list-item-subtitle>
                        </v-list-item-content>
                        <v-list-item-action>
                          <v-btn icon @click="menu.profileIcon = false">
                            <v-icon>mdi-close-circle</v-icon>
                          </v-btn>
                        </v-list-item-action>
                      </v-list-item>
                    </v-list>
                    <v-list>
                      <v-list-item @click="menu.profileIcon = false">
                        <v-list-item-action>
                          <v-icon>mdi-briefcase</v-icon>
                        </v-list-item-action>
                        <v-list-item-subtitle>{{
                          micropost.attributes.user.email
                        }}</v-list-item-subtitle>
                      </v-list-item>
                    </v-list>
                  </v-card>
                </v-menu>
              </v-col>
              <v-col cols="10" class="text-left pl-7">
                <span class="title font-weight-light">{{
                  micropost.attributes.user.name
                }}</span>
              </v-col>
              <v-col cols="1" class="text-right"> </v-col>
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
          <div v-for="(comment, i) in commentsData.data" :key="i">
            <comment :comment="comment" />
          </div>
        </v-card>
      </v-card-text>

      <v-card-actions>
        <v-row justify="center">
          <v-col cols="6">
            <v-text-field v-model="content" label="投稿用メッセージフォーム">
            </v-text-field>
          </v-col>
          <v-col cols="6" class="text-right">
            <v-btn
              class="mr-4"
              color="orange darken-3"
              @click="postCommentsGet"
            >
              更新
            </v-btn>
          </v-col>
        </v-row>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>
<script>
import Comment from '@/components/Comment'
export default {
  components: {
    Comment,
  },
  props: {
    // Object形に変換
    micropost: Object,
    current_user: Object,
  },
  data() {
    return {
      commentDlgIsDisplay: false,
      commentsData: '',
      menu: {
        profileIcon: false,
      },
      content: '',
    }
  },
  methods: {
    postCommentsGet() {
      this.$axios
        .post('/api/v1/post_comments', {
          content: this.content,
          micropost_id: this.micropost.id,
        })
        .then((request) => console.log(request))
        .catch((error) => console.log(error))
    },
  },
}
</script>
