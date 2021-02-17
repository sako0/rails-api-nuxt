<template>
  <v-row>
    <v-col class="text-center">
      <!--      <img src="/v.png" alt="Vuetify.js" class="mb-5" />-->
      <v-parallax
        height="100"
        src="https://cdn.vuetifyjs.com/images/parallax/material2.jpg"
      >
        <blockquote class="blockquote">
          &#8220;First, solve the problem. Then, write the code.&#8221;

          <footer>
            <small>
              <em>&mdash;John Johnson</em>
            </small>
          </footer>
        </blockquote>
      </v-parallax>
      <v-row>
        <v-col cols="4">
          <v-row class="mt-5">
            <v-col cols="12">
              <profileCard />
            </v-col>
            <v-col cols="12">
              <CardImage />
            </v-col>
          </v-row>
        </v-col>
        <v-col cols="8">
          <v-row class="mt-5">
            <v-col cols="12">
              <horizontalCards />
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-col>
  </v-row>
</template>
<script>
import CardImage from '~/components/Card_image.vue'
import HorizontalCards from '~/components/HorizontalCards.vue'
import ProfileCard from '~/components/ProfileCard.vue'

export default {
  components: {
    CardImage,
    HorizontalCards,
    ProfileCard,
  },
}
</script>
