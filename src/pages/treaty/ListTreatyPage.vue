<template>
  <q-page padding class="river-width">
    <q-btn label="Create Treaty" @click="openCreateTreaty()" class="full-width" />
    <h6 class="q-mt-lg q-mb-lg q-pa-none text-center">Treaties</h6>
    <q-list class="row">
      <q-separator />
      <div v-for="treaty in treaties" :key="treaty.id" class="col col-shrink  info-card q-mb-lg">
        <TreatyCardComponent :treaty="treaty" />
      </div>
      <h3 class="q-ma-lg text-center" v-if="!treaties.length && !done">LOADING...</h3>
      <h3 class="q-ma-lg text-center" v-if="!treaties.length && done">No treaties found.</h3>
      <div v-if="!done" v-intersection="onIntersection" class="full-width text-center">
        <q-spinner-dots color="primary" size="40px" />
      </div>
    </q-list>
  <q-dialog v-model="createTreaty">
    <CreateTreaty class="z-top"
    :userOrganizationId="false"
    :conflictId="false"
    :reload="reload" />
  </q-dialog>
  </q-page>
</template>
<script>
import TreatyCardComponent from 'components/treaty/TreatyCardComponent.vue'
import CreateTreaty from 'components/treaty/CreateTreaty.vue'
export default {
  meta () {
    return {
      title: 'Treaties'
    }
  },
  name: 'ListTreatyPage',
  components: { CreateTreaty, TreatyCardComponent },
  data () {
    return {
      treaties: [],
      pointer: 0,
      limit: 10,
      done: false,
      loadNum: 0,
      createTreaty: false
    }
  },
  methods: {
    openCreateTreaty: function () {
      if (this.$errorHandler.loggedInCheck()) { this.createTreaty = true }
    },
    loadTreaties: async function () {
      const q = `${process.env.api}/treaties?filter={"skip":${this.pointer},
                                                     "limit":${this.limit}, 
                                                     "order":["create_date DESC"], 
                                                     "include": [{"relation": "organization"}, 
                                                                 {"relation":"creator"}, 
                                                                 {"relation":"votes"}, 
                                                                 {"relation": "ratings"}, 
                                                                 {"relation": "provisions"}, 
                                                                 {"relation": "conflict", "scope":{"include":[
                                                                                           {"relation":"organization_a"}, 
                                                                                           {"relation":"organization_b"}]}}]}`
      const treaties = await this.$axios.get(q)
      if (this.limit > treaties.data.length) {
        this.done = true
      }
      const obj = treaties.data.map((o) => {
        return {
          id: o.id,
          name: o.name,
          description: o.description,
          avatar_url: o.avatar_url,
          creator_name: o.creator.name,
          creator_organization_name: o.organization.name,
          conflict_id: o.conflict.id,
          organization_a: o.conflict.organization_a,
          organization_b: o.conflict.organization_b,
          grievances: o.conflict.grievances,
          offers: o.conflict.offers,
          yay_votes: o.votes ? o.votes.filter(function (elm) { return elm.vote_type === 1 }).reduce((total, next) => total + next.vote_type, 0) : 0,
          nay_votes: o.votes ? o.votes.filter(function (elm) { return elm.vote_type === 0 }).reduce((total, next) => total + next.vote_type, 0) : 0,
          votes: o.votes,
          provisions: o.provisions || [],
          rating: o.ratings ? Math.round(o.ratings.reduce((total, next) => total + next.value, 0) / o.ratings.length) : 0
        }
      })
      this.treaties = this.treaties.concat(obj)
    },
    reload: function () {
      this.treaties = []
      this.loadTreaties()
      this.createTreaty = false
    },
    onIntersection: function (index, done) {
      if (this.loadNum > 1) {
        this.pointer = this.pointer + this.limit
        this.loadTreaties()
      }
      this.loadNum++
    }
  },
  async created () {
    this.reload()
  },
  mounted () {}
}
</script>
