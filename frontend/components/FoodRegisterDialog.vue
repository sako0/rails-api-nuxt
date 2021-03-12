<template>
  <v-dialog v-model="isDisplay" width="600px">
    <v-card>
      <v-card-title>{{ title }}</v-card-title>
      <v-card-text>{{ number }}</v-card-text>
      <v-row justify="center">
        <v-col cols="11" sm="11" md="11" lg="11" xl="11">
          <validation-provider
            v-slot="{ errors }"
            rules="required|max:35"
            name="商品名"
          >
            <v-text-field
              v-model="productName"
              append-icon="mdi-border-color"
              :error-messages="errors"
              :counter="35"
              label="商品名"
            ></v-text-field>
          </validation-provider>
        </v-col>
        <v-col cols="11" sm="11" md="11" lg="11" xl="11">
          <validation-provider
            v-slot="{ errors }"
            rules="required|max:35"
            name="個数・単位"
          >
            <v-text-field
              v-model="par"
              append-icon="mdi-beaker"
              :error-messages="errors"
              :counter="35"
              label="個数・単位"
            ></v-text-field>
          </validation-provider>
        </v-col>
        <v-col cols="3" sm="3" md="3" lg="3" xl="3">
          <validation-provider
            v-slot="{ errors }"
            rules="required|max:35"
            name="カロリー"
          >
            <v-text-field
              v-model.number="calorie"
              suffix="g"
              append-icon="mdi-food-fork-drink"
              :error-messages="errors"
              type="number"
              label="カロリー"
            ></v-text-field>
          </validation-provider>
        </v-col>
        <v-col cols="3" sm="3" md="3" lg="3" xl="3">
          <validation-provider
            v-slot="{ errors }"
            rules="required|max:35"
            name="たんぱく質"
          >
            <v-text-field
              v-model.number="protein"
              suffix="g"
              append-icon="mdi-food-turkey"
              :error-messages="errors"
              type="number"
              label="たんぱく質"
            ></v-text-field>
          </validation-provider>
        </v-col>
        <v-col cols="2" sm="2" md="2" lg="2" xl="2">
          <validation-provider
            v-slot="{ errors }"
            rules="required|max:35"
            name="脂質"
          >
            <v-text-field
              v-model.number="lipid"
              suffix="g"
              append-icon="mdi-food-steak"
              :error-messages="errors"
              type="number"
              label="脂質"
            ></v-text-field>
          </validation-provider>
        </v-col>
        <v-col cols="3" sm="3" md="3" lg="3" xl="3">
          <validation-provider
            v-slot="{ errors }"
            rules="required|max:35"
            name="炭水化物"
          >
            <v-text-field
              v-model.number="carbohydrate"
              suffix="g"
              append-icon="mdi-noodles"
              :error-messages="errors"
              type="number"
              label="炭水化物"
            ></v-text-field>
          </validation-provider>
        </v-col>
      </v-row>

      <v-card-actions>
        <v-row justify="center">
          <v-col cols="6">
            <v-btn @click="isDisplay = false">Close</v-btn>
          </v-col>
          <v-col cols="6" class="text-right">
            <v-btn color="red" @click="submit">OK</v-btn>
          </v-col>
        </v-row>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { required, max, regex } from 'vee-validate/dist/rules'
import { extend, ValidationProvider } from 'vee-validate'

extend('required', {
  ...required,
  message: '{_field_} は必ず入力して下さい',
})

extend('max', {
  ...max,
  message: '{_field_} は {length} 文字以内で入力して下さい',
})

extend('regex', {
  ...regex,
  message: '{_field_} を正しく入力して下さい',
})
export default {
  components: {
    ValidationProvider,
  },
  props: {
    number: String,
  },
  data: () => ({
    isDisplay: false,
    title: '',
    productName: null,
    par: null,
    calorie: null,
    protein: null,
    lipid: null,
    carbohydrate: null,
  }),
  watch: {
    isDisplay(val) {
      if (val) {
        console.log(this.$props.number)
        this.$axios
          .get('/api/v1/web_search/', { params: { id: this.$props.number } })
          .then((response) => {
            if (response.data) {
              this.title = '情報を入力して下さい'
              console.log(response.data)
              this.productName = response.data.product_name
              this.par = response.data.par
              this.calorie = response.data.calorie
              this.protein = response.data.protein
              this.lipid = response.data.lipid
              this.carbohydrate = response.data.carbohydrate
            } else {
              console.log(response)
            }
          })
      }
    },
  },
  methods: {
    submit() {
      this.isDisplay = false
      this.$emit('method')
    },
    closeDisplay() {
      this.isDisplay = false
    },
  },
}
</script>
