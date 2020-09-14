<template>
  <q-page class="full-width full-height">
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
  <q-card class="q-pa-lg full-width full-height">
        <q-expansion-item v-model="expanded" switch-toggle-side dense-toggle label="Edit Treaty" class="absolute-right z-top q-mr-lg q-mb-lg">
          <EditTreatyWidget
           :name="name"
           :avatar_url="avatar_url"
           :description="description"
           :status="status"
           :id="id"
           :reload="reload"
           />
        </q-expansion-item>
      <q-card-section horizontal class="full-width items-start">
      <q-avatar size="250px" class="q-mr-md q-mb-lg items-start">
        <q-img
          :src="avatar_url"
          style="max-height:80vh"
        />
      </q-avatar>
        <q-card-section class="q-pb-md q-pt-none">
          <h2>{{ name }}</h2>
          <p class="">created by: {{ creator }}</p>
          <p class="q-pt-none" style="max-width:60%;">{{ description }}</p>
          <div class="row">
            <q-badge class="q-mr-md" :label="'status: ' + status" />
            <q-badge color="secondary" v-if="user_organization_name" :label="'Commenting as: ' + user_organization_name" />
          </div>
        </q-card-section>
      </q-card-section>
      <RateTreatyWidget class="absolute-bottom-right q-mr-lg q-pb-lg z-top"
      :organizationId="user_organization_id"
      :treatyId="treatyId"
      />
    </q-card>
      <q-separator />
  <!-- START TABS -->
  <div class="q-mb-lg" v-if="!loading">
    <q-tabs
          v-model="tab"
          dense
          class="bg-grey-3 text-grey-7"
          active-color="primary"
          indicator-color="purple"
          align="left"
        >
          <q-tab name="grievance" label="Grievances" />
          <q-tab name="offer" label="Offers" />
          <q-tab name="vote" label="Voting" />
        </q-tabs>
        <q-tab-panels
        v-model="tab"
        animated
        transition-prev="fade"
        transition-next="fade"
        class=""
        >
  <!-- START VoteTreatyWidget -->
    <q-tab-panel name="vote">
      <VoteTreatyWidget
           :id="id"
           :organizationId="user_organization_id" />
    </q-tab-panel>
  <!-- START GRIEVANCE / OFFER TABLES -->
    <q-tab-panel name="grievance">
      <div class="row full-width">
      <!-- org a grievances -->
        <div class="col col-6">
      <q-list bordered>
        <q-item-section>
          <q-item-label class="text-uppercase text-center"><q-avatar square size="400px" class="q-mr-md"><q-img class="avatar" :src="org_a.avatar_url"></q-img></q-avatar><h6>{{ org_a.name }} Grievances</h6></q-item-label>
        </q-item-section>
        <AddTreatyItem
        entityType="grievance"
        :treatyId="treatyId"
        :organizationId="org_a.id"
        :organizationName="org_a.name"
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
      <!-- org b grievances -->
        <div class="col col-6">
      <q-list bordered>
        <q-item-section>
          <q-item-label class="text-uppercase text-center"><q-avatar square size="400px" class="q-mr-md"><q-img class="avatar" :src="org_b.avatar_url"></q-img></q-avatar><h6>{{ org_b.name }} Grievances</h6></q-item-label>
        </q-item-section>
        <AddTreatyItem
        entityType="grievance"
        :treatyId="treatyId"
        :organizationId="org_b.id"
        :organizationName="org_b.name"
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
          <q-item-label class="text-uppercase text-center"><q-avatar square size="240px" class="q-mr-md"><q-img class="avatar" :src="org_a.avatar_url"></q-img></q-avatar><h6>{{ org_a.name }} Offers</h6></q-item-label>
        </q-item-section>
        <AddTreatyItem
        entityType="offer"
        :treatyId="treatyId"
        :organizationId="org_a.id"
        :organizationName="org_a.name"
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
          <q-item-label class="text-uppercase text-center"><q-avatar square size="240px" class="q-mr-md"><q-img class="avatar" :src="org_b.avatar_url"></q-img></q-avatar><h6>{{ org_b.name }} Offers</h6></q-item-label>
        </q-item-section>
        <AddTreatyItem
        entityType="offer"
        :treatyId="treatyId"
        :organizationId="org_b.id"
        :organizationName="org_b.name"
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
    <q-dialog v-model="verify_org" persistent>
      <q-card>
        <q-card-section class="row items-center">
          <q-avatar icon="done_outline" color="primary" text-color="white" />
          <span class="q-ml-sm">Choose ONE organization to comment as.</span>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Cancel" color="primary" v-close-popup />
          <q-btn flat :label="org_a.name" color="primary" @click="setOrg(org_a.name)" v-close-popup />
          <q-btn flat :label="org_b.name" color="primary" @click="setOrg(org_b.name)" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
    </q-page>
</template>

<script>
import TreatyComponent from 'components/TreatyComponent.vue'
import AddTreatyItem from 'components/AddTreatyItem.vue'
import EditTreatyWidget from 'components/EditTreatyWidget.vue'
import RateTreatyWidget from 'components/RateTreatyWidget.vue'
import VoteTreatyWidget from 'components/VoteTreatyWidget.vue'
export default {
  meta () {
    return {
      title: this.name
    }
  },
  components: { TreatyComponent, AddTreatyItem, EditTreatyWidget, RateTreatyWidget, VoteTreatyWidget },
  async mounted () {
    this.reload()
  },
  methods: {
    setOrg: function (res) {
      this.user_organization_name = res
    },
    getUserOrg: async function () {
      const q = `${process.env.api}/user-to-organizations?filter[where][creator_user_id]=${this.$store.state.user.uid}`
      const joined = await this.$axios.get(q)
      this.joined = joined.data
      this.joinedList = joined.data.filter((obj) => { return obj.organization_id === this.org_a.id || obj.organization_id === this.org_b.id }).map((obj) => { return obj.organization_id })
      if (this.joinedList.length > 1) {
        this.verify_org = true
      } else {
        this.user_organization_id = this.joinedList[0]
        this.user_organization_name = this.org_obj[this.user_organization_id]
      }
    },
    reload: async function () {
      let q = `${process.env.api}/treaties/${this.$route.params.id}?filter={"order":["create_date DESC"], "include": [{"relation":"creator"}, {"relation": "offers", "scope":{"include":[{"relation":"organization"}]}}, {"relation":"grievances", "scope":{"include":[{"relation":"organization"}]}}, {"relation":"votes"}]}`
      console.log(q)
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
      this.org_obj[this.org_a.id] = this.org_a.name
      this.org_obj[this.org_b.id] = this.org_b.name
      this.loading = false
      this.updateOrgs(treaty.data)
      this.getUserOrg()
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
      id: this.$route.params.id,
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
      loading: true,
      expanded: false,
      user_organization_id: null,
      user_organization_name: 'unknown',
      org_obj: {},
      joinedList: [],
      verify_org: false,
      treatyId: null
    }
  }
}
</script>
