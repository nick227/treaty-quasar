<template>
  <div class="text-right">
    <q-rating @click="postForm"
      v-model="ratingVal"
      size="2em"
      :max="5"
      color="primary"
    >
    <template v-slot:tip-1>
      <q-tooltip>Worst</q-tooltip>
    </template>
    <template v-slot:tip-2>
      <q-tooltip>Okay</q-tooltip>
    </template>
    <template v-slot:tip-3>
      <q-tooltip>Good</q-tooltip>
    </template>
    <template v-slot:tip-4>
      <q-tooltip>Great</q-tooltip>
    </template>
    <template v-slot:tip-5>
      <q-tooltip>Best</q-tooltip>
    </template>
  </q-rating>
    <div class="caption">{{ numRatings }} ratings</div>
  </div>
</template>
<script>
export default {
  name: 'RateTreatyWidget',
  props: ['treatyId', 'organizationId'],
  data () {
    return {
      ratingVal: 0,
      numRatings: 0,
      ratings: []
    }
  },
  mounted () {
    this.getRating()
  },
  methods: {
    getRating: async function () {
      const q = `${process.env.api}/treaty-ratings/?filterp[where][treaty_id]=${this.treatyId}&filter[fields][value]=true`
      const ratings = await this.$axios.get(q)
      this.ratings = ratings.data
      this.numRatings = this.ratings.length
      this.ratingVal = Math.round(this.ratings.reduce((total, next) => total + next.value, 0) / this.ratings.length)
    },
    postForm: async function (e) {
      const q = `${process.env.api}/treaty-ratings`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        treaty_id: parseInt(this.treatyId),
        organization_id: parseInt(this.organizationId),
        value: this.ratingVal
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
        .then((res) => {
          this.getRating()
          this.$q.notify({
            type: 'positive',
            message: 'Rating added'
          })
        })
        .catch((err) => {
          this.$q.notify({
            type: 'negative',
            message: err
          })
        })
    }
  }
}
</script>
