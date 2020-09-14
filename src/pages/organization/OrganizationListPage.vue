<template>
  <q-page padding class="river-column">
  <q-expansion-item switch-toggle-side dense-toggle label="Create Organization">
    <CreateOrganizationWidget />
  </q-expansion-item>
    <h6 class="q-mb-sm">Organizations</h6>
    <q-list padding>
      <q-separator />
    <div v-for="org in organizations" :key="org.id">
      <q-item class="full-width" tag="a" :to="'/organization/'+org.id">
         <q-card class="full-width">
      <q-img rounded class="q-mt-none" :src="org.avatar_url"></q-img>
      <q-card-section>
        <div class="text-h6">{{ org.name }}</div>
      </q-card-section>
      <q-card-section class="q-pt-none">
        {{ org.description }}
      </q-card-section>
      <div class="text-right q-pa-lg">
        <q-btn class="style=z-index:999;" :label="joinedList.indexOf(org.id) === -1 ? 'Join' : 'Unjoin'" :color="joinedList.indexOf(org.id) === -1 ? 'primary' : 'secondary'" style="width:100px" :ripple="{ center: true }" @click="joinedList.indexOf(org.id) === -1 ? join(org.id) : unjoin(org.id)"></q-btn>
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
import CreateOrganizationWidget from 'components/organization/CreateOrganizationWidget.vue'
export default {
  meta () {
    return {
      title: 'Organizations'
    }
  },
  components: { CreateOrganizationWidget },
  name: 'OrganizationList',
  data () {
    return {
      joined: [],
      joinedList: [],
      organizations: [],
      pointer: 0,
      limit: 4,
      done: false,
      loadNum: 0
    }
  },
  async created () {
    this.reload()
  },
  methods: {
    onIntersection: function (index, done) {
      if (this.loadNum > 1) {
        this.pointer = this.pointer + this.limit
        this.loadOrgs()
      }
      this.loadNum++
    },
    join: async function (id) {
      const q = `${process.env.api}/user-to-organizations`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        organization_id: id
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.reload()
    },
    unjoin: async function (id) {
      const relId = this.joined.filter((obj) => { return obj.organization_id === id })[0].id
      const q = `${process.env.api}/user-to-organizations/${relId}`
      await this.$axios.delete(q)
      this.reload()
    },
    reload: function () {
      this.loadJoined()
      this.loadOrgs()
    },
    loadJoined: async function () {
      const q = `${process.env.api}/user-to-organizations?filter[where][creator_user_id]=${this.$store.state.user.uid}`
      const joined = await this.$axios.get(q)
      this.joined = joined.data
      this.joinedList = joined.data.map((obj) => { return obj.organization_id })
    },
    loadOrgs: async function () {
      const q = `${process.env.api}/organizations?filter[order]=create_date%20DESC&filter[limit]=${this.limit}&filter[skip]=${this.pointer}`
      const organizations = await this.$axios.get(q)
      if (this.limit > organizations.data.length) {
        this.done = true
      }
      this.organizations = this.organizations.concat(organizations.data)
    }
  }
}

</script>
