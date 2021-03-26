<template>
  <v-app>
    <v-container>
      <nuxt />
    </v-container>
  </v-app>
</template>
<script>
export default {
  mounted() {
    this.$vuetify.theme.dark = false
  },
}
</script>
<style scoped>
.v-application {
  background-color: cornsilk;
}
</style>
