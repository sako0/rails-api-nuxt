<template>
  <v-row>
    <v-col class="text-center">
      <tab />
      <img src="/v.png" alt="Vuetify.js" class="mb-5" . />
      <blockquote class="blockquote">
        &#8220;First, solve the problem. Then, write the code.&#8221;
        <footer>
          <small>
            <em>&mdash;John Johnson</em>
          </small>
        </footer>
      </blockquote>
    </v-col>
  </v-row>
</template>
<script>
import axios from 'axios'
import Tab from '~/components/Tab.vue'

export default {
  components: {
    Tab,
  },
  mounted() {
    const baseurl = 'http://localhost:3000/api/v1'
    axios.get(baseurl + '/users').then((response) => console.log(response.data))
  },
}
</script>
