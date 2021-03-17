<script>
import { Bar, mixins } from 'vue-chartjs'
export default {
  mixins: [Bar, mixins.reactiveData],
  props: {
    calorie: Number,
  },
  data() {
    return {
      chartdata: {
        labels: ['カロリー'],
        datasets: [
          {
            label: ['摂取量'],
            backgroundColor: '#00a0ff',
            data: [this.calorie, 0],
          },
          {
            label: ['目安量'],
            backgroundColor: '#7e7e7e',
            data: [2000, 0],
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
    calorie(val) {
      this.chartdata.datasets[0].data = [val, 0]
      this.renderChart(this.chartdata, this.options)
    },
  },
  mounted() {
    this.renderChart(this.chartdata, this.options)
  },
}
</script>
