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
  props: ['id'],
  data () {
    return {
      ratingVal: 0,
      numRatings: 0
    }
  },
  mounted () {},
  methods: {
    postForm: function (e) {
      console.log(this.ratingVal)
    }
  }
}
</script>
