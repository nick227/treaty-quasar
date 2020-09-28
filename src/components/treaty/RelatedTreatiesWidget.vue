<template>
  <div v-if="links.length" class="text-left river-width q-mt-lg">
    <q-separator class="q-mt-md" />
    <h5>Related treaties:</h5>
    <q-separator class="q-mb-md" />
    <a class="cursor-pointer" v-for="link in links" :key="link.id" @click="goto(link.url)" replace>{{ link.text }}</a>
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
        return {
          url: '/treaty/' + obj.id,
          text: obj.name,
          id: obj.id
        }
      })
    }
  },
  methods: {
    goto: function (link) {
      window.location.href = link
    },
    getUrls: async function () {
      const q = `${process.env.api}/treaties?filter[where][and][0][conflict_id]=${this.conflictId}&filter[where][and][1][id][neq]=${this.currentId}&filter[fields][id]=true&filter[fields][name]=true&filter[limit]=${this.limit}`
      const treaties = await this.$axios.get(q)
      this.treaties = treaties.data
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
