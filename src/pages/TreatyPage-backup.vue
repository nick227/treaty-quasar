<template>
  <q-page padding class="river-column">
      <div class="q-pa-md q-gutter-sm">
        <div class="text-center">
      <q-badge :label="status" />
          <h3>{{name}}</h3>
          <h6>{{description}}</h6>
        </div>
        <div class="row full-width">
      <div class="bg-grey-2 col col-md-5 q-pl-md">
        <h6><q-avatar size="40px" square class="q-mr-md"><q-img rounded class="q-mt-none" :src="org_a.avatar_url"></q-img></q-avatar>{{ org_a.name }}</h6>
      </div>
      <div class="bg-grey-2 col col-md-2 text-center">
        <h6>vs.</h6>
      </div>
      <div class="bg-grey-2 col col-md-5 text-right q-pr-md">
        <h6><q-avatar size="40px" square class="q-mr-md"><q-img rounded class="q-mt-none" :src="org_b.avatar_url"></q-img></q-avatar>{{ org_b.name }}</h6>
      </div>
    </div>
    <q-img class="full-width q-mt-none" :src="avatar_url"></q-img>
    <p class="text-center">created by: {{ creator }}</p>
  </div>
  <!-- START TABS -->
  <div class="q-mb-lg" v-if="!loading">
    <q-tabs
          v-model="tab"
          dense
          class="bg-grey-3 text-grey-7"
          active-color="primary"
          indicator-color="purple"
          align="justify"
        >
          <q-tab name="grievance" label="Grievances" />
          <q-tab name="offer" label="Offers" />
        </q-tabs>
        <q-tab-panels
        v-model="tab"
        animated
        transition-prev="fade"
        transition-next="fade"
        class=""
        >
  <!-- START GRIEVANCE / OFFER TABLES -->
    <q-tab-panel name="grievance">
      <div class="row full-width">
        <div class="col col-6">
      <!-- org a grievances -->
      <q-list class="bg-grey-2">
        <q-item-section>
          <q-item-label class="text-uppercase text-center"><q-avatar square size="240px" class="q-mr-md"><q-img class="avatar" :src="org_a.avatar_url"></q-img></q-avatar><h6>{{ org_a.name }} Grievances</h6></q-item-label>
        </q-item-section>
        <AddTreatyItem
        entityType="grievance"
        :treatyId="treatyId"
        :organizationId="org_a.id"
        :fn="reload"
        />
        <h6 class="text-center text-subtitle2 text-grey-9" v-if="!grievances[org_a.name].length">no grievances</h6>
        <div v-if="grievances[org_a.name].length">
        <TreatyComponent
          v-for="grievance in grievances[org_a.name]"
           entityType="grievance"
          :key="grievance.id"
          :entityId="grievance.id"
          :title="grievance.title"
          :description="grievance.description"
          :organization="grievance.organization.name"
          :organizationId="grievance.organization.id"
          :organizationAvatarUrl="grievance.organization.avatar_url"
          :orgAname="org_a.name"
          :orgBname="org_b.name"
          :orgAid="org_a.id"
          :orgBid="org_b.id"
        />
        </div>
      </q-list>
    </div>
        <div class="col col-6">
      <!-- org b grievances -->
      <q-list bordered>
        <q-item-section>
          <q-item-label class="text-uppercase text-center"><q-avatar square size="140px" class="q-mr-md"><q-img class="avatar" :src="org_b.avatar_url"></q-img></q-avatar><h6>{{ org_b.name }} Grievances</h6></q-item-label>
        </q-item-section>
        <AddTreatyItem
        entityType="grievance"
        :treatyId="treatyId"
        :organizationId="org_b.id"
        :fn="reload"
        />
        <h6 class="text-center text-subtitle2 text-grey-9" v-if="!grievances[org_b.name].length">no grievances</h6>
        <div v-if="grievances[org_b.name].length">
        <TreatyComponent
          v-for="grievance in grievances[org_b.name]"
           entityType="grievance"
          :key="grievance.id"
          :entityId="grievance.id"
          :title="grievance.title"
          :description="grievance.description"
          :organization="grievance.organization.name"
          :organizationId="grievance.organization.id"
          :organizationAvatarUrl="grievance.organization.avatar_url"
          :orgAname="org_a.name"
          :orgBname="org_b.name"
          :orgAid="org_a.id"
          :orgBid="org_b.id"
        />
        </div>
      </q-list></div>
      </div>
      </q-tab-panel>
      <!--    OFFER WIDGETS    -->
      <q-tab-panel name="offer">
        <div class="row full-width">
          <div class="col col-6">
      <!-- org a offers -->
      <q-list bordered>
        <q-item-section>
          <q-item-label class="text-uppercase text-center"><h6>{{ org_a.name }} Offers</h6></q-item-label>
        </q-item-section>
        <AddTreatyItem
        entityType="offer"
        :treatyId="treatyId"
        :organizationId="org_a.id"
        :fn="reload"
        />
        <h6 class="text-center text-subtitle2 text-grey-9" v-if="!offers[org_a.name].length">no offers</h6>
        <div v-if="offers[org_a.name].length">
        <TreatyComponent
          v-for="offer in offers[org_a.name]"
           entityType="offer"
          :key="offer.id"
          :entityId="offer.id"
          :title="offer.title"
          :description="offer.description"
          :organization="offer.organization.name"
          :organizationId="offer.organization.id"
          :organizationAvatarUrl="offer.organization.avatar_url"
          :orgAname="org_a.name"
          :orgBname="org_b.name"
          :orgAid="org_a.id"
          :orgBid="org_b.id"
        />
        </div>
      </q-list>
    </div>
          <div class="col col-6">
      <!-- org b offers -->
      <q-list bordered>
        <q-item-section>
          <q-item-label class="text-uppercase text-center"><h6>{{ org_b.name }} Offers</h6></q-item-label>
        </q-item-section>
        <AddTreatyItem
        entityType="offer"
        :treatyId="treatyId"
        :organizationId="org_b.id"
        :fn="reload"
        />
        <h6 class="text-center text-subtitle2 text-grey-9" v-if="!offers[org_b.name].length">no offers</h6>
        <div v-if="offers[org_b.name].length">
        <TreatyComponent
          v-for="offer in offers[org_b.name]"
           entityType="offer"
          :key="offer.id"
          :entityId="offer.id"
          :title="offer.title"
          :description="offer.description"
          :organization="offer.organization.name"
          :organizationId="offer.organization.id"
          :organizationAvatarUrl="offer.organization.avatar_url"
          :orgAname="org_a.name"
          :orgBname="org_b.name"
          :orgAid="org_a.id"
          :orgBid="org_b.id"
        />
        </div>
      </q-list>
    </div>
        </div>
      </q-tab-panel>
      </q-tab-panels>
      </div>
  </q-page>
</template>

<script>
import TreatyComponent from 'components/TreatyComponent.vue'
import AddTreatyItem from 'components/AddTreatyItem.vue'
export default {
  components: { TreatyComponent, AddTreatyItem },
  async created () {
    this.reload()
  },
  methods: {
    reload: async function () {
      let q = `${process.env.api}/treaties/${this.$route.params.id}?filter={"order":["create_date DESC"], "include": [{"relation":"creator"}, {"relation": "offers", "scope":{"include":[{"relation":"organization"}]}}, {"relation":"grievances", "scope":{"include":[{"relation":"organization"}]}}, {"relation":"votes"}]}`
      const treaty = await this.$axios.get(q)
      this.treatyId = treaty.data.id
      this.name = treaty.data.name
      this.status = treaty.data.status
      this.description = treaty.data.description
      this.avatar_url = treaty.data.avatar_url
      this.creator = treaty.data.creator.name
      q = `${process.env.api}/organizations/?filter[where][or][0][id]=${treaty.data.organization_a_id}&filter[where][or][1][id]=${treaty.data.organization_b_id}`
      const orgs = await this.$axios.get(q)
      this.org_a = orgs.data[0]
      this.org_b = orgs.data[1]
      this.loading = false
      this.updateOrgs(treaty.data)
    },
    updateOrgs: function (obj) {
      this.grievances = {}
      this.grievances[this.org_a.name] = []
      this.grievances[this.org_b.name] = []
      if (typeof obj.grievances === 'object') {
        for (let i = obj.grievances.length - 1; i >= 0; i--) {
          this.grievances[obj.grievances[i].organization.name].push(obj.grievances[i])
        }
      }
      this.offers = {}
      this.offers[this.org_a.name] = []
      this.offers[this.org_b.name] = []
      if (typeof obj.offers === 'object') {
        for (let i = 0; i < obj.offers.length; i++) {
          this.offers[obj.offers[i].organization.name].push(obj.offers[i])
        }
      }
    }
  },
  data () {
    return {
      tab: 'grievance',
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
