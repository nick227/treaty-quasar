<template>
  <q-page padding>
  <q-expansion-item switch-toggle-side dense-toggle label="Create Organization">
    <CreateOrganizationWidget />
  </q-expansion-item>
    <h6 class="q-mb-sm">Organizations</h6>
    <q-list padding>
      <q-separator />
    <div v-for="org in organizations" :key="org.id">
      <q-item>
         <q-item-section top avatar>
          <q-item class="q-mr-md" tag="a" :to="'/organization/'+org.id"><q-avatar size="240px" square class=""><q-img rounded class="q-mt-none" :src="org.avatar_url"></q-img></q-avatar></q-item>
        </q-item-section>
        <q-item-section>
          <q-item class="q-pa-sm" tag="a" :to="'/organization/'+org.id"><q-item-label>{{ org.name }}</q-item-label></q-item>
          <q-item-label class="q-pa-sm" caption lines="2">{{ org.description }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-btn :label="joinedList.indexOf(org.id) === -1 ? 'Join' : 'Unjoin'" :color="joinedList.indexOf(org.id) === -1 ? 'primary' : 'secondary'" style="width:100px" :ripple="{ center: true }" @click="joinedList.indexOf(org.id) === -1 ? join(org.id) : unjoin(org.id)"></q-btn>
        </q-item-section>
      </q-item>
      <q-separator />
      </div>
    </q-list>
  </q-page>
</template>
<script>
import CreateOrganizationWidget from 'components/CreateOrganizationWidget.vue'
export default {
  components: { CreateOrganizationWidget },
  name: 'OrganizationList',
  data () {
    return {
      joined: [],
      joinedList: [],
      organizations: []
    }
  },
  async created () {
    this.reload()
  },
  methods: {
    join: async function (id) {
      const q = 'http://localhost:3000/user-to-organizations'
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        organization_id: id
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.reload()
    },
    unjoin: async function (id) {
      const relId = this.joined.filter((obj) => { return obj.organization_id === id })[0].id
      const q = `http://localhost:3000/user-to-organizations/${relId}`
      await this.$axios.delete(q)
      this.reload()
    },
    reload: function () {
      this.loadJoined()
      this.loadOrgs()
    },
    loadJoined: async function () {
      const q = `http://localhost:3000/user-to-organizations?filter[where][creator_user_id]=${this.$store.state.user.uid}`
      const joined = await this.$axios.get(q)
      this.joined = joined.data
      this.joinedList = joined.data.map((obj) => { return obj.organization_id })
    },
    loadOrgs: async function () {
      const q = 'http://localhost:3000/organizations?filter[order]=create_date%20DESC'
      const organizations = await this.$axios.get(q)
      this.organizations = organizations.data
    }
  }
}

</script>
