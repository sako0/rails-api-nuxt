<template>
  <v-row>
    <v-col class="center">
      <v-row>
        <v-col cols="12" class="mt-5">
          <v-card>
            <v-card-title>aaa</v-card-title>
            <FoodRegisterDialog ref="dlg" :number="num" />
            <cameraDialog ref="cameraDlg" @cancel="cancel" @code="code" />
          </v-card>
        </v-col>
      </v-row>
    </v-col>
  </v-row>
</template>
<script>
import CameraDialog from '@/components/CameraDialog'
import FoodRegisterDialog from '@/components/FoodRegisterDialog'
export default {
  components: {
    CameraDialog,
    FoodRegisterDialog,
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
