<template>
  <q-page padding class="river-width">
    <q-btn label="Create Treaty" @click="createTreaty = true" class="full-width" />
    <q-list padding>
      <div v-for="treaty in treaties" :key="treaty.id">
        <q-item class="full-width" tag="a" :to="'/conflict/'+treaty.conflict_id">
          <q-card class="full-width">
            <q-img rounded class="" :src="treaty.avatar_url"></q-img>
            <q-card-section class="q-pb-none">
              <div class="text-h4 q-mb-sm">{{ treaty.name }}</div>
              <div class="row " style="">
                <div class="col">Created by: {{ treaty.creator_name }} - A member of {{ treaty.creator_organization_name }}</div>
              </div>
            </q-card-section>
            <q-card-section class="q-pb-md">
              {{ treaty.description }}
            </q-card-section>
            <q-separator />
            <q-card-section class="bg-blue-grey-11">
              <div class="row " style="">
                <div class="col">{{ treaty.grievances.length }} Grievances | {{ treaty.offers.length }} Offers</div>
                <div class="col text-center">Rated {{ treaty.rating }}/5</div>
                <div class="col text-right">Yay: {{ treaty.yay_votes }} Nay: {{ treaty.nay_votes }}</div>
              </div>
            </q-card-section>
          </q-card>
        </q-item>
        <q-separator />
      </div>
      <div v-if="!done" v-intersection="onIntersection" class="full-width text-center">
        <q-spinner-dots color="primary" size="40px" />
      </div>
    </q-list>
  <q-dialog v-model="createTreaty">
    <CreateTreaty
    :userOrganizationId="false"
    :conflictId="false"
    :reset="reset" />
  </q-dialog>
  </q-page>
</template>
<script>
import CreateTreaty from 'components/treaty/CreateTreaty.vue'
export default {
  meta () {
    return {
      title: 'Treaties'
    }
  },
  name: 'ListTreatyPage',
  components: { CreateTreaty },
  data () {
    return {
      treaties: [],
      pointer: 0,
      limit: 2,
      done: false,
      loadNum: 0,
      createTreaty: false
    }
  },
  methods: {
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
          yay_votes: o.votes ? o.votes.filter(function (elm) { return elm.vote_type === 1 }).reduce((total, next) => total + next.vote_type, 0) : 0,
          nay_votes: o.votes ? o.votes.filter(function (elm) { return elm.vote_type === 0 }).reduce((total, next) => total + next.vote_type, 0) : 0,
          votes: o.votes,
          rating: o.ratings ? Math.round(o.ratings.reduce((total, next) => total + next.value, 0) / o.ratings.length) : 0
        }
      })
      this.treaties = this.treaties.concat(obj)
    },
    reset: function () {
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
    this.loadTreaties()
  },
  mounted () {}
}
</script>
