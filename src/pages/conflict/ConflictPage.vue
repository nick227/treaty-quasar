<template>
  <q-page class="full-width full-height">
    <div class="row full-width">
      <div class="bg-grey-2 col col-md-5 q-pl-md"> <a class="cursor-pointer" @click="$router.push('/organization/'+org_a.id)"><h6><q-avatar size="40px" square class="q-mr-md"><q-img rounded class="q-mt-none" :src="org_a.avatar_url"></q-img></q-avatar>{{ org_a.name }}</h6></a> </div>
      <div class="bg-grey-2 col col-md-2 text-center">
        <h6>vs.</h6> </div>
      <div class="bg-grey-2 col col-md-5 text-right q-pr-md"> <a class="cursor-pointer" @click="$router.push('/organization/'+org_b.id)"><h6><q-avatar size="40px" square class="q-mr-md"><q-img rounded class="q-mt-none" :src="org_b.avatar_url"></q-img></q-avatar>{{ org_b.name }}</h6></a> </div>
    </div>
    <q-card class="q-pa-lg full-width full-height">
      <q-expansion-item v-model="expanded" switch-toggle-side dense-toggle label="Edit Conflict" class="absolute-right z-top q-mr-lg q-mb-lg">
        <EditConflictWidget :name="name" :avatar_url="avatar_url" :description="description" :status="status" :id="id" :reload="reload" /> </q-expansion-item>
      <q-card-section horizontal class="full-width items-start">
        <div class="card-image" :style="'width:550px; height:350px; background-image:url('+avatar_url+');'"></div>
        <q-card-section class="q-pb-md q-pt-none">
          <h2>{{ name }}</h2>
          <p class="q-pt-none" style="max-width:60%;">{{ description }}</p>
          <div class="row">
            <q-badge color="secondary" v-if="user_organization_name" :label="'Commenting as: ' + user_organization_name" /> </div>
        </q-card-section>
      </q-card-section>
    </q-card>
    <q-separator />
    <!-- START TABS -->
    <div class="q-mb-lg" v-if="!loading">
      <q-tabs v-model="tab" dense class="bg-grey-3 text-grey-7" active-color="primary" indicator-color="purple" align="left">
        <q-tab name="grievances" label="Grievances'" />
        <q-tab name="offers" label="Offers" />
        <q-tab name="treaties" label="Treaties" />
      </q-tabs>
      <q-tab-panels v-model="tab" animated transition-prev="fade" transition-next="fade" class="">
        <q-tab-panel name="grievances">
          <!-- START GRIEVANCE / OFFER TABLES -->
          <div class="row full-width">
            <!-- org a grievances -->
            <div class="col col-6">
              <q-list bordered>
                <q-item-section>
                  <q-item-label class="text-uppercase text-center">
                    <q-avatar square size="400px" class="q-ma-md">
                      <q-img class="card-image" :src="org_a.avatar_url"></q-img>
                    </q-avatar>
                    <h6>{{ org_a.name }} Grievances</h6></q-item-label>
                </q-item-section>
                <AddConflictItem entityType="grievance" :userOrganizationId="user_organization_id" :conflictId="conflictId" :organizationId="org_a.id" :organizationName="org_a.name" :fn="reload" />
                <h6 class="text-center text-subtitle2 text-grey-9" v-if="!grievances[org_a.name].length">no grievances</h6>
                <div v-if="grievances[org_a.name].length">
                  <ConflictComponent v-for="grievance in grievances[org_a.name]" entityType="grievance" :key="grievance.id" :entityId="grievance.id" :title="grievance.title" :description="grievance.description" :organization="grievance.organization.name" :organizationId="grievance.organization.id" :organizationAvatarUrl="grievance.organization.avatar_url" :orgAname="org_a.name" :orgBname="org_b.name" :orgAid="org_a.id" :orgBid="org_b.id" /> </div>
              </q-list>
            </div>
            <!-- org b grievances -->
            <div class="col col-6">
              <q-list bordered>
                <q-item-section>
                  <q-item-label class="text-uppercase text-center">
                    <q-avatar square size="400px" class="q-ma-md">
                      <q-img class="card-image" :src="org_b.avatar_url"></q-img>
                    </q-avatar>
                    <h6>{{ org_b.name }} Grievances</h6></q-item-label>
                </q-item-section>
                <AddConflictItem entityType="grievance" :userOrganizationId="user_organization_id" :conflictId="conflictId" :organizationId="org_b.id" :organizationName="org_b.name" :fn="reload" />
                <h6 class="text-center text-subtitle2 text-grey-9" v-if="!grievances[org_b.name].length">no grievances</h6>
                <div v-if="grievances[org_b.name].length">
                  <ConflictComponent v-for="grievance in grievances[org_b.name]" entityType="grievance" :key="grievance.id" :entityId="grievance.id" :title="grievance.title" :description="grievance.description" :organization="grievance.organization.name" :organizationId="grievance.organization.id" :organizationAvatarUrl="grievance.organization.avatar_url" :orgAname="org_a.name" :orgBname="org_b.name" :orgAid="org_a.id" :orgBid="org_b.id" /> </div>
              </q-list>
            </div>
          </div>
        </q-tab-panel>
        <!--    OFFER WIDGETS    -->
        <q-tab-panel name="offers">
          <div class="row full-width">
            <div class="col col-6">
              <!-- org a offers -->
              <q-list bordered>
                <q-item-section>
                  <q-item-label class="text-uppercase text-center">
                    <q-avatar square size="400px" class="q-ma-md">
                      <q-img class="card-image" :src="org_a.avatar_url"></q-img>
                    </q-avatar>
                    <h6>{{ org_a.name }} Offers</h6></q-item-label>
                </q-item-section>
                <AddConflictItem entityType="offer" :userOrganizationId="user_organization_id" :conflictId="conflictId" :organizationId="org_a.id" :organizationName="org_a.name" :fn="reload" />
                <h6 class="text-center text-subtitle2 text-grey-9" v-if="!offers[org_a.name].length">no offers</h6>
                <div v-if="offers[org_a.name].length">
                  <ConflictComponent v-for="offer in offers[org_a.name]" entityType="offer" :key="offer.id" :entityId="offer.id" :title="offer.title" :description="offer.description" :organization="offer.organization.name" :organizationId="offer.organization.id" :organizationAvatarUrl="offer.organization.avatar_url" :orgAname="org_a.name" :orgBname="org_b.name" :orgAid="org_a.id" :orgBid="org_b.id" /> </div>
              </q-list>
            </div>
            <div class="col col-6">
              <!-- org b offers -->
              <q-list bordered>
                <q-item-section>
                  <q-item-label class="text-uppercase text-center">
                    <q-avatar square size="400px" class="q-ma-md">
                      <q-img class="card-image" :src="org_b.avatar_url"></q-img>
                    </q-avatar>
                    <h6>{{ org_b.name }} Offers</h6></q-item-label>
                </q-item-section>
                <AddConflictItem entityType="offer" :userOrganizationId="user_organization_id" :conflictId="conflictId" :organizationId="org_b.id" :organizationName="org_b.name" :fn="reload" />
                <h6 class="text-center text-subtitle2 text-grey-9" v-if="!offers[org_b.name].length">no offers</h6>
                <div v-if="offers[org_b.name].length">
                  <ConflictComponent v-for="offer in offers[org_b.name]" entityType="offer" :key="offer.id" :entityId="offer.id" :title="offer.title" :description="offer.description" :organization="offer.organization.name" :organizationId="offer.organization.id" :organizationAvatarUrl="offer.organization.avatar_url" :orgAname="org_a.name" :orgBname="org_b.name" :orgAid="org_a.id" :orgBid="org_b.id" /> </div>
              </q-list>
            </div>
          </div>
        </q-tab-panel>
        <q-tab-panel name="treaties">
          <TreatyListComponent
          :conflictId="conflictId"
           />
        </q-tab-panel>
      </q-tab-panels>
    </div>
    <q-dialog v-model="verify_org" persistent>
      <q-card>
        <q-card-section class="row items-center">
          <q-avatar icon="done_outline" color="primary" text-color="white" /> <span class="q-ml-sm">Choose ONE organization to comment as.</span> </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Cancel" color="primary" v-close-popup />
          <q-btn flat :label="org_a.name" color="primary" @click="setOrg(org_a)" v-close-popup />
          <q-btn flat :label="org_b.name" color="primary" @click="setOrg(org_b)" v-close-popup /> </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>
<script>
import ConflictComponent from 'components/conflict/ConflictComponent.vue'
import TreatyListComponent from 'components/treaty/TreatyListComponent.vue'
import AddConflictItem from 'components/conflict/AddConflictItem.vue'
import EditConflictWidget from 'components/conflict/EditConflictWidget.vue'
export default {
  meta () {
    return {
      title: this.name
    }
  },
  components: { ConflictComponent, AddConflictItem, EditConflictWidget, TreatyListComponent },
  async mounted () {
    this.reload()
  },
  methods: {
    setOrg: function (obj) {
      this.user_organization_name = obj.name
      this.user_organization_id = obj.id
      this.reload()
    },
    getUserOrg: async function () {
      if (this.user_organization_id) {
        return true
      }
      const q = `${process.env.api}/user-to-organizations?filter[where][creator_user_id]=${this.$store.state.user.uid}`
      const joined = await this.$axios.get(q)
      this.joined = joined.data
      this.joinedList = joined.data.filter((obj) => { return obj.organization_id === this.org_a.id || obj.organization_id === this.org_b.id }).map((obj) => { return obj.organization_id })
      if (this.joinedList.length > 1) {
        this.verify_org = true
      }
      if (this.joinedList.length === 1) {
        this.user_organization_id = this.joinedList[0]
        this.user_organization_name = this.org_obj[this.user_organization_id]
      }
      if (this.joinedList.length === 0) {
        this.$q.notify({
          type: 'info',
          message: 'Please join organization to comment'
        })
      }
    },
    reload: async function () {
      let q = `${process.env.api}/conflicts/${this.$route.params.id}?filter={"order":["create_date DESC"], "include": [{"relation": "offers", "scope":{"include":[{"relation":"organization"}]}}, {"relation":"grievances", "scope":{"include":[{"relation":"organization"}]}}]}`
      const conflict = await this.$axios.get(q)
      this.conflictId = conflict.data.id
      this.name = conflict.data.name
      this.status = conflict.data.status
      this.description = conflict.data.description
      this.avatar_url = conflict.data.avatar_url
      q = `${process.env.api}/organizations/?filter[where][or][0][id]=${conflict.data.organization_a_id}&filter[where][or][1][id]=${conflict.data.organization_b_id}`
      const orgs = await this.$axios.get(q)
      this.org_a = orgs.data[0]
      this.org_b = orgs.data[1]
      this.org_obj[this.org_a.id] = this.org_a.name
      this.org_obj[this.org_b.id] = this.org_b.name
      this.loading = false
      this.updateOrgs(conflict.data)
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
      tab: 'treaties',
      name: '',
      status: '',
      description: '',
      avatar_url: '',
      org_a: {},
      org_b: {},
      grievances: {},
      offers: {},
      loading: true,
      expanded: false,
      user_organization_id: null,
      user_organization_name: 'n/a',
      org_obj: {},
      joinedList: [],
      verify_org: false,
      conflictId: null
    }
  }
}
</script>
