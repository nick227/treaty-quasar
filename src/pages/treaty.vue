<template>
  <q-page padding>
      <div class="q-pa-md q-gutter-sm">
        <div class="text-center">
      <q-badge :label="status" />
          <h3>{{name}}</h3>
          <h6>{{description}}</h6>
        </div>
        <div class="row full-width">
      <div class="bg-grey-2 col col-md-5 q-pl-md">
        <h6>{{ org_a.name }}</h6>
      </div>
      <div class="bg-grey-2 col col-md-2 text-center">
        <h6>vs.</h6>
      </div>
      <div class="bg-grey-2 col col-md-5 text-right q-pr-md">
        <h6>{{ org_b.name }}</h6>
      </div>
    </div>
    <q-img rounded class="full-width q-mt-none" :src="avatar_url"></q-img>
    <p class="text-center">created by: {{ creator }}</p>
  </div>
  <div class="q-mb-lg" v-if="!loading">
      <q-list bordered padding>
        <q-item-section>
          <q-item-label class="bg-grey-11 text-uppercase text-center"><h6>{{ org_a.name }} Grievances</h6></q-item-label>
        </q-item-section>
        <h6 class="text-center text-subtitle2 text-grey-9" v-if="!grievances[org_a.name].length">no grievances</h6>
        <GrievanceList
          v-for="grievance in grievances[org_a.name]"
          :key="grievance.id"
          :title="grievance.title"
          :description="grievance.description"
        />
      </q-list>
      <q-list bordered padding>
        <q-item-section>
          <q-item-label class="bg-grey-11 text-uppercase text-center"><h6>{{ org_b.name }} Grievances</h6></q-item-label>
        </q-item-section>
        <h6 class="text-center text-subtitle2 text-grey-9" v-if="!grievances[org_b.name].length">no grievances</h6>
        <GrievanceList
          v-for="grievance in grievances[org_b.name]"
          :key="grievance.id"
          :title="grievance.title"
          :description="grievance.description"
        />
      </q-list>
      </div>
  <div class="q-mb-lg" v-if="!loading">
      <q-list bordered padding>
        <q-item-section>
          <q-item-label class="bg-grey-11 text-uppercase text-center"><h6>{{ org_a.name }} Offers</h6></q-item-label>
        </q-item-section>
        <h6 class="text-center text-subtitle2 text-grey-9" v-if="!offers[org_a.name].length">no offers</h6>
        <OfferList
          v-for="offer in offers[org_a.name]"
          :key="offer.id"
          :title="offer.title"
          :description="offer.description"
        />
      </q-list>
      <q-list bordered padding>
        <q-item-section>
          <q-item-label class="bg-grey-11 text-uppercase text-center"><h6>{{ org_b.name }} Offers</h6></q-item-label>
        </q-item-section>
        <h6 class="text-center text-subtitle2 text-grey-9" v-if="!offers[org_b.name].length">no offers</h6>
        <OfferList
          v-for="offer in offers[org_b.name]"
          :key="offer.id"
          :title="offer.title"
          :description="offer.description"
        />
      </q-list>
      </div>
  </q-page>
</template>

<script>
import GrievanceList from 'components/GrievanceList.vue'
import OfferList from 'components/OfferList.vue'
export default {
  components: { GrievanceList, OfferList },
  async created () {
    let q = `http://localhost:3000/treaties/${this.$route.params.id}?filter={"include": [{"relation":"creator"}, {"relation": "offers", "scope":{"include":[{"relation":"organization"}]}}, {"relation":"grievances", "scope":{"include":[{"relation":"organization"}]}}, {"relation":"votes"}]}`
    const treaty = await this.$axios.get(q)
    this.name = treaty.data.name
    this.status = treaty.data.status
    this.description = treaty.data.description
    this.avatar_url = treaty.data.avatar_url
    this.creator = treaty.data.creator.name
    q = `http://localhost:3000/organizations/?filter[where][or][0][id]=${treaty.data.organization_a_id}&filter[where][or][1][id]=${treaty.data.organization_b_id}`
    const orgs = await this.$axios.get(q)
    this.org_a = orgs.data[0]
    this.org_b = orgs.data[1]
    this.grievances = {}
    this.grievances[this.org_a.name] = []
    this.grievances[this.org_b.name] = []
    for (let i = 0; i < treaty.data.grievances.length; i++) {
      this.grievances[treaty.data.grievances[i].organization.name].push(treaty.data.grievances[i])
    }
    this.offers = {}
    this.offers[this.org_a.name] = []
    this.offers[this.org_b.name] = []
    for (let i = 0; i < treaty.data.offers.length; i++) {
      this.offers[treaty.data.offers[i].organization.name].push(treaty.data.offers[i])
    }
    this.loading = false
  },
  data () {
    return {
      name: '',
      status: '',
      description: '',
      avatar_url: '',
      creator: '',
      org_a: {},
      org_b: {},
      grievances: {},
      offers: {},
      loading: true
    }
  }
}
</script>
