<template>
  <v-row>
    <v-col class="center">
      <v-row>
        <v-col cols="12" class="mt-5">
          <v-card>
            <v-card-title>栄養分摂取量を登録する</v-card-title>
            <v-btn
              class="mx-2"
              fab
              dark
              color="indigo"
              @click="code_confirm_dialog"
            >
              <v-icon dark> mdi-plus </v-icon>
            </v-btn>
            <cameraDialog ref="cameraDlg" @cancel="cancel" @code="code" />
            <Dialog
              ref="dialog"
              type="foodRegister"
              @code_exist="cameraUp"
              @no_code="dlgUp"
            />
            <FoodRegisterDialog ref="dlg" :number="num" />
            <v-row justify="center">
              <v-col cols="4" sm="4" md="3" lg="3" xl="3">
                <kcalBarChart />
              </v-col>
              <v-col cols="7" sm="7" md="5" lg="5" xl="5">
                <gBarChart />
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </v-row>
    </v-col>
  </v-row>
</template>
<script>
import CameraDialog from '@/components/CameraDialog'
import FoodRegisterDialog from '@/components/FoodRegisterDialog'
import Dialog from '@/components/Dialog'
import KcalBarChart from '@/components/KcalBarChart'
import GBarChart from '@/components/GBarChart'
export default {
  components: {
    CameraDialog,
    FoodRegisterDialog,
    Dialog,
    KcalBarChart,
    GBarChart,
  },
  middleware: 'auth',
  data() {
    return {
      num: '',
    }
  },
  methods: {
    cancel() {},
    code(code) {
      this.num = code
      this.$refs.dlg.isDisplay = true
    },
    cameraUp() {
      this.$refs.cameraDlg.isDisplay = true
    },
    dlgUp() {},
    code_confirm_dialog() {
      this.$refs.dialog.isDisplay = true
    },
  },
}
</script>
