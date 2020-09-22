<template>
  <q-page class="full-height river-width">
    <ConflictHeaderSection v-if="conflict_creator_user_id" :creatorUserId="conflict_creator_user_id" :name="name" :avatar_url="avatar_url" :description="description" :status="status" :id="id" :reload="reload" :org_a="org_a" :org_b="org_b" :user_organization_name="user_organization_name" />
    <q-separator />
    <!-- START TABS -->
    <div class="q-ma-none" v-if="!loading">
      <q-tabs v-model="tab" dense class="q-mb-sm text-grey-7" active-color="primary" indicator-color="purple" align="left">
        <q-tab name="treaties" label="Treaties" />
        <q-tab name="grievances" label="Grievances" />
        <q-tab name="offers" label="Offers" />
        <q-tab name="debates" label="Debates" />
      </q-tabs>
      <!-- START PANELS -->
      <q-tab-panels v-if="user_organization_id" v-model="tab" animated transition-prev="fade" transition-next="fade" class="full-width q-pa-none q-mb-lg">
        <q-tab-panel name="grievances" class="q-pa-none bg-grey-2">
          <!-- org a grievances -->
          <q-btn-toggle
        v-model="menuOne"
        spread
        no-caps
        toggle-color="purple"
        color="white"
        text-color="black"
        :options="[
          {label: org_a.name, value: 'one'},
          {label: org_b.name, value: 'two'}
        ]"
      />
          <q-list bordered v-if="menuOne==='one'">
            <q-item-section>
              <q-item-label class="text-uppercase text-center">
                <h6 class="q-mt-lg">{{ org_a.name }} Grievances</h6>
                    <q-avatar square size="400px" class="q-ma-none">
                      <q-img class="card-image q-ma-none q-pt-none" :src="org_a.avatar_url"></q-img>
                    </q-avatar>
              </q-item-label>
            </q-item-section>
            <AddConflictItem
            entityType="grievance"
            :userOrganizationId="user_organization_id"
            :conflictId="conflictId"
            :organizationId="org_a.id"
            :organizationName="org_a.name"
            :fn="reload" />
            <h6 class="text-center text-subtitle2 text-grey-9" v-if="!grievances[org_a.name].length">no grievances</h6>
            <div v-if="grievances[org_a.name].length">
              <ConflictItemComponent v-for="grievance in grievances[org_a.name]"
              entityType="grievance"
              :key="grievance.id"
              :entityId="grievance.id"
              :creator="grievance.creator"
              :userOrganizationId="user_organization_id"
              :title="grievance.title"
              :description="grievance.description"
              :organization="grievance.organization.name"
              :organizationId="grievance.organization.id"
              :organizationAvatarUrl="grievance.organization.avatar_url"
              :orgAname="org_a.name"
              :orgBname="org_b.name"
              :orgAid="org_a.id"
              :orgBid="org_b.id" /> </div>
          </q-list>
          <!-- org b grievances -->
          <q-list bordered v-if="menuOne==='two'">
            <q-item-section>
              <q-item-label class="text-uppercase text-center">
                <h6 class="q-mt-lg">{{ org_b.name }} Grievances</h6>
                    <q-avatar square size="400px" class="q-ma-none">
                      <q-img class="card-image q-ma-none q-pt-none" :src="org_b.avatar_url"></q-img>
                    </q-avatar>
              </q-item-label>
            </q-item-section>
            <AddConflictItem
            entityType="grievance"
            :userOrganizationId="user_organization_id"
            :conflictId="conflictId"
            :organizationId="org_b.id"
            :organizationName="org_b.name"
            :fn="reload" />
            <h6 class="text-center text-subtitle2 text-grey-9" v-if="!grievances[org_b.name].length">no grievances</h6>
            <div v-if="grievances[org_b.name].length">
              <ConflictItemComponent v-for="grievance in grievances[org_b.name]"
              entityType="grievance"
              :key="grievance.id"
              :entityId="grievance.id"
              :creator="grievance.creator"
              :userOrganizationId="user_organization_id"
              :title="grievance.title"
              :description="grievance.description"
              :organization="grievance.organization.name"
              :organizationId="grievance.organization.id"
              :organizationAvatarUrl="grievance.organization.avatar_url"
              :orgAname="org_a.name"
              :orgBname="org_b.name"
              :orgAid="org_a.id"
              :orgBid="org_b.id" />
            </div>
          </q-list>
        </q-tab-panel>
          <!-- org a offers -->
        <q-tab-panel name="offers" class="q-pa-none bg-grey-2">
          <q-btn-toggle
        v-model="menuTwo"
        spread
        no-caps
        toggle-color="purple"
        color="white"
        text-color="black"
        :options="[
          {label: org_a.name, value: 'one'},
          {label: org_b.name, value: 'two'}
        ]"
      />
          <q-list bordered v-if="menuTwo==='one'">
            <q-item-section>
              <q-item-label class="text-uppercase text-center">
                <h6 class="q-mt-lg">{{ org_a.name }} Offers</h6>
                    <q-avatar square size="400px" class="q-ma-none">
                      <q-img class="card-image q-ma-none q-pt-none" :src="org_a.avatar_url"></q-img>
                    </q-avatar>
              </q-item-label>
            </q-item-section>
            <AddConflictItem entityType="offer"
            :userOrganizationId="user_organization_id"
            :conflictId="conflictId"
            :organizationId="org_a.id"
            :organizationName="org_a.name"
            :fn="reload" />
            <h6 class="text-center text-subtitle2 text-grey-9" v-if="!offers[org_a.name].length">no offers</h6>
            <div v-if="offers[org_a.name].length">
              <ConflictItemComponent v-for="offer in offers[org_a.name]"
              entityType="offer"
              :key="offer.id"
              :entityId="offer.id"
              :creator="offer.creator"
              :userOrganizationId="user_organization_id"
              :title="offer.title"
              :description="offer.description"
              :organization="offer.organization.name"
              :organizationId="offer.organization.id"
              :organizationAvatarUrl="offer.organization.avatar_url"
              :orgAname="org_a.name"
              :orgBname="org_b.name"
              :orgAid="org_a.id"
              :orgBid="org_b.id" /> </div>
          </q-list>
          <!-- org b offers -->
          <q-list bordered v-if="menuTwo==='two'">
            <q-item-section>
              <q-item-label class="text-uppercase text-center">
                <h6 class="q-mt-lg">{{ org_b.name }} Offers</h6>
                    <q-avatar square size="400px" class="q-ma-none">
                      <q-img class="card-image q-ma-none q-pt-none" :src="org_b.avatar_url"></q-img>
                    </q-avatar>
              </q-item-label>
            </q-item-section>
            <AddConflictItem entityType="offer"
            :userOrganizationId="user_organization_id"
            :conflictId="conflictId"
            :organizationId="org_b.id"
            :organizationName="org_b.name"
            :fn="reload" />
            <h6 class="text-center text-subtitle2 text-grey-9" v-if="!offers[org_b.name].length">no offers</h6>
            <div v-if="offers[org_b.name].length">
              <ConflictItemComponent v-for="offer in offers[org_b.name]"
              entityType="offer"
              :key="offer.id"
              :entityId="offer.id"
              :creator="offer.creator"
              :userOrganizationId="user_organization_id"
              :title="offer.title"
              :description="offer.description"
              :organization="offer.organization.name"
              :organizationId="offer.organization.id"
              :organizationAvatarUrl="offer.organization.avatar_url"
              :orgAname="org_a.name"
              :orgBname="org_b.name"
              :orgAid="org_a.id"
              :orgBid="org_b.id" /> </div>
          </q-list>
        </q-tab-panel>
          <!-- treaties panel -->
        <q-tab-panel name="treaties" class="q-pa-none bg-grey-2">
          <TreatyTableComponent
          :conflictId="conflictId"
          :userOrganizationId="user_organization_id" />
        </q-tab-panel>
          <!-- debates panel -->
        <q-tab-panel name="debates" class="q-pa-none bg-grey-2">
          <DebateTableComponent
          :conflictId="conflictId"
          :userOrganizationId="user_organization_id" />
        </q-tab-panel>
      </q-tab-panels>
      <!-- END PANELS -->
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
import ConflictHeaderSection from 'components/conflict/ConflictHeaderSection.vue'
import ConflictItemComponent from 'components/conflict/ConflictItemComponent.vue'
import AddConflictItem from 'components/conflict/AddConflictItem.vue'
import TreatyTableComponent from 'components/treaty/TreatyTableComponent.vue'
import DebateTableComponent from 'components/debate/DebateTableComponent.vue'
export default {
  meta () {
    return {
      title: this.name
    }
  },
  components: { ConflictItemComponent, AddConflictItem, TreatyTableComponent, ConflictHeaderSection, DebateTableComponent },
  async created () {
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
      let q = `${process.env.api}/conflicts/${this.$route.params.id}?filter={"order":["create_date DESC"], "include": [{"relation": "offers", "scope":{"include":[{"relation":"organization"}, {"relation":"creator"}]}}, {"relation":"grievances", "scope":{"include":[{"relation":"organization"}, {"relation":"creator"}]}}]}`
      console.log(q)
      const conflict = await this.$axios.get(q)
      this.conflictId = conflict.data.id
      this.name = conflict.data.name
      this.status = conflict.data.status
      this.conflict_creator_user_id = conflict.data.creator_user_id
      this.description = conflict.data.description
      this.avatar_url = conflict.data.avatar_url
      q = `${process.env.api}/organizations/?filter[where][or][0][id]=${conflict.data.organization_a_id}&filter[where][or][1][id]=${conflict.data.organization_b_id}`
      const orgs = await this.$axios.get(q)
      this.org_a = orgs.data[0]
      console.log('+++++++++')
      console.log(this.org_a)
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
        for (let i = obj.offers.length - 1; i >= 0; i--) {
          console.log(obj.offers[i])
          this.offers[obj.offers[i].organization.name].push(obj.offers[i])
        }
      }
    }
  },
  data () {
    return {
      id: this.$route.params.id,
      tab: 'offers',
      name: '',
      status: '',
      conflict_creator_user_id: null,
      description: '',
      avatar_url: '',
      org_a: {},
      org_b: {},
      grievances: {},
      offers: {},
      loading: true,
      user_organization_id: null,
      user_organization_name: 'n/a',
      org_obj: {},
      joinedList: [],
      verify_org: false,
      conflictId: null,
      menuOne: 'one',
      menuTwo: 'one'
    }
  }
}
</script>
