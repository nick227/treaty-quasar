<template>
  <q-page padding class="river-column">
  <q-expansion-item switch-toggle-side dense-toggle label="Create Treaty">
    ok
  </q-expansion-item>
    <q-list padding>
      <q-separator />
    <div v-for="treaty in treaties" :key="treaty.id">
      <q-item class="full-width" tag="a" :to="'/conflict/'+treaty.conflict_id">
         <q-card class="full-width">
      <q-img rounded class="q-mt-none" :src="treaty.avatar_url"></q-img>
      <q-card-section>
        <div class="text-h6">{{ treaty.name }}</div>
      </q-card-section>
      <q-card-section class="q-pt-none">
        {{ treaty.description }}
      </q-card-section>
          <div class="row q-pt-none q-pl-md q-pr-md" style="">
            <div class="col">Created by: {{ treaty.creator_name }}</div><div class="col text-right">Organization: {{ treaty.creator_organization_name }}</div>
          </div>
          <q-separator />
          <div class="row q-pl-md q-pr-md" style="">
            <div class="col col-5"><h6>{{ treaty.organization_a.name }}</h6></div>
            <div class="col col-2 text-center"><h6>vs.</h6></div>
            <div class="col col-5 text-right"><h6>{{ treaty.organization_b.name }}</h6></div>
          </div>
          <q-separator />
          <div class="row q-pa-md" style="">
            <div class="col">{{ treaty.grievances.length }} Grievances | {{ treaty.offers.length }} Offers</div><div class="col text-center">Rated {{ treaty.rating }}/5</div><div class="col text-right">Votes ~ Yay: {{ treaty.yay_votes }} Nay: {{ treaty.nay_votes }}</div>
          </div>
    </q-card>
      </q-item>
      <q-separator />
    </div>
  <div v-if="!done" v-intersection="onIntersection" class="full-width text-center">
    <q-spinner-dots color="primary" size="40px" />
  </div>
  </q-list>
  </q-page>
</template>
<script>
export default {
  meta () {
    return {
      title: 'Treaties'
    }
  },
  name: 'ListTreatyPage',
  components: {},
  data () {
    return {
      treaties: [],
      pointer: 0,
      limit: 2,
      done: false,
      loadNum: 0
    }
  },
  methods: {
    onIntersection: function (index, done) {
      if (this.loadNum > 1) {
        this.pointer = this.pointer + this.limit
        this.loadtreaties()
      }
      this.loadNum++
    },
    loadTreaties: async function () {
      const q = `${process.env.api}/treaties?filter={"skip":${this.pointer},"limit":${this.limit},"order":["create_date DESC"], "include": [{"relation": "organization"}, {"relation":"creator"}, {"relation": "conflict", "scope":{"include":[{"relation":"offers"}, {"relation":"grievances"}, {"relation":"organization_a"}, {"relation":"organization_b"}]}}, {"relation":"votes"}, {"relation": "ratings"}]}`
      const treaties = await this.$axios.get(q)
      if (this.limit > treaties.data.length) {
        this.done = true
      }
      const obj = treaties.data.map((o) => {
        return {
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
          yay_votes: o.votes.filter(function (elm) { return elm.vote_type === 1 }).reduce((total, next) => total + next.vote_type, 0),
          nay_votes: o.votes.filter(function (elm) { return elm.vote_type === 0 }).reduce((total, next) => total + next.vote_type, 0),
          votes: o.votes,
          rating: Math.round(o.ratings.reduce((total, next) => total + next.value, 0) / o.ratings.length)
        }
      })
      this.treaties = this.treaties.concat(obj)
      console.log(this.treaties)
    }
  },
  async created () {
    this.loadTreaties()
  },
  mounted () {}
}
</script>
