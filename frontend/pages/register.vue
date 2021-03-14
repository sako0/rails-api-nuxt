<template>
  <v-row>
    <v-col class="center">
      <v-row>
        <v-col cols="12" class="mt-5">
          <v-card>
            <v-card-title>栄養分摂取量を登録する</v-card-title>
            <FoodRegisterDialog ref="dlg" :number="num" />
            <v-row justify="center">
              <v-col cols="4" sm="4" md="3" lg="3" xl="3">
                <kcalBarChart />
              </v-col>
              <v-col cols="7" sm="7" md="5" lg="5" xl="5">
                <gBarChart />
              </v-col>
            </v-row>
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
import KcalBarChart from '@/components/KcalBarChart'
import GBarChart from '@/components/GBarChart'
export default {
  components: {
    CameraDialog,
    FoodRegisterDialog,
    KcalBarChart,
    GBarChart,
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
