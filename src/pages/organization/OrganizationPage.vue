<template>
  <q-page padding class="river-width">
    <div class="row relative-position" style="z-index:3" v-if="isUser">
        <q-expansion-item v-model="expanded" switch-toggle-side dense-toggle label="Edit Organization" style="height:40px;" class="dialog-width">
          <EditOrganizationWidget
           :organization="org"
           :reload="reload"
           />
        </q-expansion-item>
    </div>
    <div class="q-pa-md q-gutter-sm">
      <div class="text-center">
        <h3>{{org.name}}</h3>
        <h6>{{org.description}}</h6>
      </div>
  <q-btn class="full-width q-mb-md text-black" v-if="isMember" label="Member Chat" icon="login" color="lightgrey" :ripple="{ center: true }" @click="memberChat = true"></q-btn>
      <transition
  appear
  enter-active-class="animated fadeIn"
  leave-active-class="animated fadeOut"
>
    <q-img class="full-width q-mt-none" :src="org.avatar_url"></q-img>
    </transition>
  </div>
  <q-btn class="full-width q-mb-md" label="Create Conflict" color="accent" style="" :ripple="{ center: true }" @click="createConflict = true"></q-btn>
  <q-btn class="full-width q-mb-md" :label="!isMember ? 'Join' : 'Unjoin'" :color="!isMember ? 'primary' : 'secondary'" style="" :ripple="{ center: true }" @click="!isMember ? join(org.id) : unjoin(org.id)"></q-btn>
  <CommentsWidget v-if="org.id"
        :userOrganizationId="org.id"
        :entityId="org.id"
        entityType="organization"
  ></CommentsWidget>
  <div v-if="members.length" class="q-pa-md q-gutter-sm">
  <h6>Members {{ members.length }}</h6>
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
  <h6>Conflicts {{ conflicts.length }}</h6>
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
  <q-dialog class="z-max" v-model="memberChat">
    <OrganizationChatWidget class="z-max" :organization="org" />
  </q-dialog>
  <q-dialog v-model="createConflict">
    <CreateConflictWidget :defaultOrgName="org.name" />
  </q-dialog>
</q-page>
</template>
<script>
import OrganizationChatWidget from 'components/organization/OrganizationChatWidget.vue'
import EditOrganizationWidget from 'components/organization/EditOrganizationWidget.vue'
import CreateConflictWidget from 'components/conflict/CreateConflictWidget.vue'
import CommentsWidget from 'components/widgets/CommentsWidget.vue'
export default {
  meta () {
    return {
      title: this.org.name
    }
  },
  name: 'Organization',
  components: { CommentsWidget, CreateConflictWidget, EditOrganizationWidget, OrganizationChatWidget },
  data () {
    return {
      memberChat: false,
      isUser: false,
      expanded: false,
      org: {},
      members: [],
      conflicts: [],
      isMember: false,
      createConflict: false
    }
  },
  created () {
    this.reload()
  },
  methods: {
    reload: async function () {
      this.expanded = false
      this.loadOrg()
      this.loadMembers()
      this.loadConflicts()
    },
    join: async function (id) {
      if (!this.$errorHandler.loggedInCheck()) { return false }
      const q = `${process.env.api}/user-to-organizations`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        organization_id: id
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.reload()
    },
    unjoin: async function (id) {
      if (!this.$errorHandler.loggedInCheck()) { return false }
      let q = `${process.env.api}/user-to-organizations?filter[where][and][0][creator_user_id]=${this.$store.state.user.uid}&filter[where][and][1][organization_id]=${this.org.id}&filter[fields][id]=true`
      const obj = await this.$axios.get(q)
      q = `${process.env.api}/user-to-organizations/${obj.data[0].id}`
      await this.$axios.delete(q)
      this.reload()
    },
    loadOrg: async function () {
      const q = `${process.env.api}/organizations/${this.$route.params.id}`
      const org = await this.$axios.get(q)
      this.org = org.data
      this.isUser = this.$errorHandler.isLoggedInUser(this.org.creator_user_id)
    },
    loadMembers: async function () {
      const q = `${process.env.api}/organizations/${this.$route.params.id}/users`
      const members = await this.$axios.get(q)
      this.members = members.data
      this.isMember = this.members.filter((obj) => { return obj.id === this.$store.state.user.uid }).length > 0
    },
    loadConflicts: async function () {
      const q = `${process.env.api}/conflicts?filter[where][or][0][organization_a_id]=${this.$route.params.id}&filter[where][or][1][organization_b_id]=${this.$route.params.id}`
      const conflicts = await this.$axios.get(q)
      this.conflicts = conflicts.data
    }
  }
}
</script>
