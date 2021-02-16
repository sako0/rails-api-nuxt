<template>
  <v-tabs left>
    <v-tab>
      <v-icon>mdi-face</v-icon>
      {{ tab_name }}
    </v-tab>
    <v-tab>
      <v-icon>mdi-face</v-icon>
      Logo
    </v-tab>
    <v-tab>
      <v-icon>mdi-face</v-icon>
      Happy
    </v-tab>
  </v-tabs>
</template>
<script>
export default {
  name: 'Tab',
  props: ['tab_name'],
}
</script>
