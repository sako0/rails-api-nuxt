<template>
  <div>
    <v-row>
      <v-col cols="12">
        <v-divider class="mx-4"></v-divider>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="1" class="text-right pl-7">
        <v-menu
          v-model="menu.profileIcon"
          bottom
          right
          transition="scale-transition"
          origin="top left"
        >
          <template #activator="{ on, attrs }">
            <v-btn icon v-bind="attrs">
              <v-avatar color="grey darken-3" size="40" v-on="on">
                <v-img :src="comment.attributes.comment_user_image"></v-img>
              </v-avatar>
            </v-btn>
          </template>
          <v-card width="300">
            <v-list dark>
              <v-list-item>
                <v-list-item-avatar>
                  <v-img :src="comment.attributes.comment_user_image"></v-img>
                </v-list-item-avatar>
                <v-list-item-content>
                  <v-list-item-title>{{
                    comment.attributes.user.name
                  }}</v-list-item-title>
                  <v-list-item-subtitle>{{
                    comment.attributes.user.email
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
                  comment.attributes.user.email
                }}</v-list-item-subtitle>
              </v-list-item>
            </v-list>
          </v-card>
        </v-menu>
      </v-col>
      <v-col cols="9" class="text-left pt-5 pl-6">
        <span class="title font-weight-light text-body-1">{{
          comment.attributes.user.name
        }}</span>
      </v-col>
      <v-col cols="2" class="text-right">
        <v-btn icon @click="deleteComment"><v-icon>mdi-delete</v-icon></v-btn>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12">
        <v-card-text>
          <p>{{ comment.attributes.content }}</p>
        </v-card-text>
      </v-col>
    </v-row>
  </div>
</template>
<script>
export default {
  props: {
    comment: Object,
  },
  data() {
    return {
      menu: {
        profileIcon: false,
      },
      content: '',
    }
  },
  methods: {
    deleteComment() {
      this.$axios
        .delete('/api/v1/post_comments/' + this.comment.id)
        .then((request) => console.log(request))
        .catch((error) => console.log(error))
    },
  },
}
</script>
