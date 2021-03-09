<template>
  <v-row>
    <v-col class="center">
      <v-row>
        <v-col cols="12" class="mt-5">
          <v-card>
            <v-card-title>aaa</v-card-title>
            <cameraDialog ref="cameraDlg" @cancel="cancel" @code="code" />
          </v-card>
        </v-col>
      </v-row>
    </v-col>
  </v-row>
</template>
<script>
import CameraDialog from '@/components/CameraDialog'
export default {
  components: {
    CameraDialog,
  },
  middleware: 'auth',
  mounted() {
    this.$refs.cameraDlg.isDisplay = true
  },
  methods: {
    cancel() {},
    code(val) {
      console.log(val)
    },
  },
}
</script>
