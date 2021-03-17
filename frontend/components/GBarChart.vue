<script>
import { Bar } from 'vue-chartjs'
export default {
  extends: Bar,
  props: {
    protein: Number,
    lipid: Number,
    carbohydrate: Number,
  },
  data() {
    return {
      chartdata: {
        labels: ['たんぱく質', '脂質', '炭水化物'],
        datasets: [
          {
            label: ['摂取量'],
            backgroundColor: '#00a0ff',
            data: [this.protein, this.lipid, this.carbohydrate, 0],
          },
          {
            label: ['目安量'],
            backgroundColor: '#7e7e7e',
            data: [60, 50, 40, 0],
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
      },
    }
  },
  watch: {
    protein(val) {
      this.chartdata.datasets[0].data = [val, this.lipid, this.carbohydrate, 0]
      this.renderChart(this.chartdata, this.options)
    },
    lipid(val) {
      this.chartdata.datasets[0].data = [
        this.protein,
        val,
        this.carbohydrate,
        0,
      ]
      this.renderChart(this.chartdata, this.options)
    },
    carbohydrate(val) {
      this.chartdata.datasets[0].data = [this.protein, this.lipid, val, 0]
      this.renderChart(this.chartdata, this.options)
    },
  },
  mounted() {
    this.renderChart(this.chartdata, this.options)
  },
}
</script>
