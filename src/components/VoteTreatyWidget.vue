<template>
  <div class="row">
    <div class="col col-6">
      <q-card></q-card>
    </div>
    <div class="col col-6"></div>
  </div>
</template>
<script>
export default {
  name: 'VoteTreatyWidget',
  props: ['id'],
  data () {
    return {
      ratingVal: 0
    }
  },
  mounted () {
    console.log('kdkdjl')
    console.log(process.env.api)
  },
  methods: {}
}
</script>
