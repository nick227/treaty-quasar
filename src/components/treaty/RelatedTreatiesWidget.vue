<template>
  <div v-if="links.length" class="text-left river-width q-mt-lg">
    <q-separator class="q-mt-md" />
    <h5>Related treaties:</h5>
    <q-separator class="q-mb-md" />
    <div class="row justify-between full-width" v-for="link in links" :key="link.id">
      <div class="col col-9"><router-link :to="link.url" replace>{{ link.text }}</router-link></div>
      <div class="col text-right">Yay: {{ link.yay }} Nay: {{ link.nay }}</div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'RelatedTreatiesWidget',
  props: ['conflictId', 'currentId'],
  data () {
    return {
      treaties: [],
      limit: 5
    }
  },
  computed: {
    links: function () {
      return this.treaties.map((obj) => {
        if (typeof obj.votes !== 'object') {
          obj.votes = []
        }
        return {
          url: '/treaty/' + obj.id,
          text: obj.name,
          id: obj.id,
          yay: obj.votes.filter((i) => { return i.vote_type === 1 }).length,
          nay: obj.votes.filter((i) => { return i.vote_type === 0 }).length
        }
      })
    }
  },
  methods: {
    goto: function (link) {
      window.location.href = link
    },
    getUrls: async function () {
      const q = `${process.env.api}/treaties?filter[where][and][0][conflict_id]=${this.conflictId}&filter[where][and][1][id][neq]=${this.currentId}&filter[fields][id]=true&filter[fields][name]=true&filter[limit]=${this.limit}&filter[include][0][relation]=votes`
      const treaties = await this.$axios.get(q)
      this.treaties = treaties.data
      console.log(this.treaties)
    }
  },
  created () {
    this.getUrls()
  },
  beforeRouteUpdate (to, from, next) {
    console.log(to)
    next()
  }
}
</script>
