<template>
  <q-page padding class="river-width">
    <div class="q-pa-md q-gutter-sm">
      <div class="text-center">
        <h3>{{org.name}}</h3>
        <h6>{{org.description}}</h6>
      </div>
    <q-img class="full-width q-mt-none" :src="org.avatar_url"></q-img>
  </div>
  <q-btn class="full-width" :label="!isMember ? 'Join' : 'Unjoin'" :color="!isMember ? 'primary' : 'secondary'" style="width:100px" :ripple="{ center: true }" @click="!isMember ? join(org.id) : unjoin(org.id)"></q-btn>
  <div v-if="members.length" class="q-pa-md q-gutter-sm">
  <h6>Members</h6>
    <q-list>
      <q-item v-for="member in members" :key="member.id" clickable v-ripple :to="'/profile/' + member.id">
          <q-item-section avatar>
            <q-avatar rounded>
              <img :src="member.avatar_url">
            </q-avatar>
          </q-item-section>
          <q-item-section class="">
            <div class="">{{ member.name }}<BR />{{ member.location }}</div>
          </q-item-section>
        </q-item>
    </q-list>
   </div>
   <q-separator />
  <div v-if="conflicts.length" class="q-pa-md q-gutter-sm">
  <h6>Conflicts</h6>
    <q-list>
      <q-item v-for="conflict in conflicts" :key="conflict.id" clickable v-ripple :to="'/conflict/' + conflict.id">
          <q-item-section avatar>
            <q-avatar rounded>
              <img :src="conflict.avatar_url">
            </q-avatar>
          </q-item-section>
          <q-item-section class="">
            <div class="">{{ conflict.name }}<BR /><span class="ellipsis-2-lines">{{ conflict.description }}</span></div>
          </q-item-section>
        </q-item>
    </q-list>
   </div>
</q-page>
</template>
<script>
export default {
  meta () {
    return {
      title: this.org.name
    }
  },
  name: 'Organization',
  data () {
    return {
      org: {},
      members: [],
      conflicts: [],
      isMember: false
    }
  },
  async mounted () {
    this.reload()
  },
  methods: {
    reload: async function () {
      this.loadOrg()
      this.loadMembers()
      this.loadConflicts()
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
      let q = `${process.env.api}/user-to-organizations?filter[where][and][0][creator_user_id]=${this.$store.state.user.uid}&filter[where][and][1][organization_id]=${this.org.id}&filter[fields][name]=true&filter[fields][description]=true&filter[fields][avatar_url]=true`
      const obj = await this.$axios.get(q)
      q = `${process.env.api}/user-to-organizations/${obj.data[0].id}`
      await this.$axios.delete(q)
      this.reload()
    },
    loadOrg: async function () {
      const q = `${process.env.api}/organizations/${this.$route.params.id}`
      const org = await this.$axios.get(q)
      this.org = org.data
    },
    loadMembers: async function () {
      const q = `${process.env.api}/organizations/${this.$route.params.id}/users`
      const members = await this.$axios.get(q)
      this.members = members.data
      const uidList = this.members.map((obj) => { return obj.id })
      this.isMember = uidList.includes(this.$store.state.user.uid)
    },
    loadConflicts: async function () {
      const q = `${process.env.api}/conflicts?filter[where][or][0][organization_a_id]=${this.$route.params.id}&filter[where][or][1][organization_b_id]=${this.$route.params.id}`
      const conflicts = await this.$axios.get(q)
      this.conflicts = conflicts.data
    }
  }
}
</script>
