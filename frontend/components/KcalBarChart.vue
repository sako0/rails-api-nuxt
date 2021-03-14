<script>
import { Bar } from 'vue-chartjs'
export default {
  extends: Bar,
  data() {
    return {
      chartdata: {
        labels: ['カロリー'],
        datasets: [
          {
            label: ['摂取量'],
            backgroundColor: '#00a0ff',
            data: [3000, 0],
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
  mounted() {
    this.renderChart(this.chartdata, this.options)
  },
}
</script>
