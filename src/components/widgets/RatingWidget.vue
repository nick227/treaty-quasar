<template>
  <div class="text-right">
    <div class="caption">{{ numRatings }} ratings</div>
    <q-rating @click="postForm"
      v-model="ratingVal"
      size="2em"
      :max="5"
      color="primary"
      :readonly="readonly"
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
  </div>
</template>
<script>
export default {
  name: 'RatingWidget',
  props: ['entityId', 'userOrganizationId', 'entityType', 'readonly'],
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
      const q = `${process.env.api}/${this.entityType}-ratings/?filter[where][${this.entityType}_id]=${this.entityId}&filter[fields][value]=true`
      const ratings = await this.$axios.get(q)
      this.ratings = ratings.data
      this.numRatings = this.ratings.length
      this.ratingVal = Math.round(this.ratings.reduce((total, next) => total + next.value, 0) / this.ratings.length)
    },
    postForm: async function (e) {
      if (!this.$errorHandler.organizationCheck(this.userOrganizationId)) { return false }
      const q = `${process.env.api}/${this.entityType}-ratings`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        organization_id: parseInt(this.userOrganizationId),
        value: this.ratingVal
      }
      payload[this.entityType + '_id'] = parseInt(this.entityId)
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
