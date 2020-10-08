<template>
  <q-page class="full-height river-width">
    <ConflictHeaderSection v-if="conflict_creator_user_id" :creatorUserId="conflict_creator_user_id" :name="name" :avatar_url="avatar_url" :description="description" :status="status" :id="id" :reload="reload" :org_a="org_a" :org_b="org_b" :user_organization_name="user_organization_name" />
    <q-separator />
    <ConflictPanelsSection :key="counter"  v-if="!loading" :userOrganizationId="user_organization_id" :orgA="org_a" :orgB="org_b" :conflictId="conflictId" :title="name" :reload="reload" />
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
import ConflictPanelsSection from 'components/conflict/ConflictPanelsSection.vue'
export default {
  meta () {
    return {
      title: this.name
    }
  },
  components: { ConflictPanelsSection, ConflictHeaderSection },
  data () {
    return {
      id: this.$route.params.id,
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
      counter: 0
    }
  },
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
        this.$q.notify({
          type: 'info',
          message: 'You are logged in as: ' + this.user_organization_name
        })
      }
      if (this.joined.length === 0) {
        this.$q.notify({
          type: 'error',
          message: 'Please join organization to comment'
        })
      }
    },
    reload: async function () {
      let q = `${process.env.api}/conflicts/${this.$route.params.id}?filter={"order":["create_date DESC"]}`
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
      this.org_b = orgs.data[1]
      this.org_obj[this.org_a.id] = this.org_a.name
      this.org_obj[this.org_b.id] = this.org_b.name
      this.updateOrgs(conflict.data)
      this.getUserOrg()
      this.loading = false
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
          this.offers[obj.offers[i].organization.name].push(obj.offers[i])
        }
      }
    }
  }
}
</script>
