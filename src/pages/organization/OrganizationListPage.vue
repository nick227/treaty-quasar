<template>
  <q-page padding class="river-width">
  <q-expansion-item switch-toggle-side dense-toggle v-model="expanded" label="Create Organization">
    <CreateOrganizationWidget :reload="reload" />
  </q-expansion-item>
    <h6 class="q-mb-sm text-center">Organizations</h6>
    <q-list class="row">
      <h3 class="q-ma-lg text-center" v-if="!organizations.length && !done">LOADING...</h3>
      <h3 class="q-ma-lg text-center" v-if="!organizations.length && done">No organizations found.</h3>
    <div v-for="org in organizations" class="col col-shrink info-card q-mb-lg" :key="org.id">
    <q-card class="flex-break q-ma-lg">
  <router-link :to="'/organization/'+org.id"><div :style="'background-image:url(' + org.avatar_url + ')'" class="card-image"></div></router-link>
      <q-card-section>
        <router-link :to="'/organization/'+org.id"><div class="text-h6 cursor-pointer">{{ org.name }}</div></router-link>
      </q-card-section>
      <q-card-section class="q-pt-none">
        {{ org.description }}
      </q-card-section>
      <q-card-section class="q-pt-none">
        <q-btn :label="joinedList.indexOf(org.id) === -1 ? 'Join' : 'Unjoin'" :color="joinedList.indexOf(org.id) === -1 ? 'primary' : 'secondary'" class="full-width" :ripple="{ center: true }" @click="joinBtn(org.id)"></q-btn>
      </q-card-section>
      </q-card>
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
      expanded: false,
      pointer: 0,
      limit: 10,
      done: false,
      loadNum: 0
    }
  },
  async created () {
    this.reload()
  },
  methods: {
    goto: function (url) {
      this.$router.push({ path: url })
    },
    onIntersection: function (index, done) {
      if (this.loadNum > 1) {
        this.pointer = this.pointer + this.limit
        this.loadOrgs()
      }
      this.loadNum++
    },
    joinBtn: function (id) {
      if (this.joinedList.includes(id)) {
        this.unjoin(id)
      } else {
        this.join(id)
      }
    },
    join: async function (id) {
      if (!this.$errorHandler.loggedInCheck()) { return false }
      const q = `${process.env.api}/user-to-organizations`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        organization_id: id
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.joinedList = []
      this.loadJoined()
    },
    unjoin: async function (id) {
      const relId = this.joined.filter((obj) => { return obj.organization_id === id })[0].id
      const q = `${process.env.api}/user-to-organizations/${relId}`
      await this.$axios.delete(q)
      this.joinedList = []
      this.loadJoined()
    },
    reload: function () {
      this.expanded = false
      this.joined = []
      this.joinedList = []
      this.organizations = []
      this.loadJoined()
      this.loadOrgs()
    },
    loadJoined: async function () {
      if (!this.$store.state.user.uid) { return false }
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
