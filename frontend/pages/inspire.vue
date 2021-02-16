<template>
  <v-row>
    <v-col class="text-center">
      <tab :tab_name="tab_name" />
      <img src="/v.png" alt="Vuetify.js" class="mb-5" . />
      <parallax />
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
import Parallax from '~/components/Parallax.vue'

export default {
  components: {
    Tab,
    Parallax,
  },
  data() {
    return {
      tab_name: 'default',
    }
  },
  mounted() {
    const baseurl = 'http://localhost:3000/api/v1'
    axios
      .get(baseurl + '/users')
      .then((response) => (this.tab_name = response.data))
  },
}
</script>
