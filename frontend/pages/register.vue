<template>
  <v-row>
    <v-col class="center">
      <v-row>
        <v-col cols="12" class="mt-5">
          <v-card>
            <v-card-title>aaa</v-card-title>
            <Dialog ref="dlg" type="cameraDialog" :content="num" />
            <cameraDialog ref="cameraDlg" @cancel="cancel" @code="code" />
          </v-card>
        </v-col>
      </v-row>
    </v-col>
  </v-row>
</template>
<script>
import CameraDialog from '@/components/CameraDialog'
import Dialog from '@/components/Dialog'
export default {
  components: {
    CameraDialog,
    Dialog,
  },
  middleware: 'auth',
  data() {
    return {
      num: '',
    }
  },
  mounted() {
    this.$refs.cameraDlg.isDisplay = true
  },
  methods: {
    cancel() {},
    code(code) {
      console.log(code)
      this.num = code
      this.$refs.dlg.isDisplay = true
    },
  },
}
</script>
