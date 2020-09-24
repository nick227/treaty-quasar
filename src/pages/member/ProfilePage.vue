<template>
  <q-page class="justify-center" :style="'background-image:url(' + this.user.profile_background_url + '); flex-center;display:flex;'">
    <div class="river-width self-center">
    <div class="row relative-position" v-if="isUser">
        <q-expansion-item v-model="expanded" switch-toggle-side dense-toggle label="Edit Profile" class="absolute-right z-top q-pr-lg q-mr-lg">
          <EditProfileWidget
           :name="user.name"
           :avatar_url="user.avatar_url"
           :location="user.location"
           :biography="user.biography"
           :profile_background_url="user.profile_background_url"
           :uid="user.id"
           :reload="reload"
           />
        </q-expansion-item>
    </div>
    <q-card class="q-pa-lg full-width full-height  bg-semi-trans">
      <q-card-section class="full-width">
      <transition
        appear
        enter-active-class="animated fadeIn"
        leave-active-class="animated fadeOut"
      >
      <q-avatar style="width:100%; height:400px;" square class="q-mr-md q-mb-lg items-start">
        <q-img
          :src="user.avatar_url"
        />
      </q-avatar>
    </transition>
        <q-card-section class="q-pb-md q-pt-none">
          <h2>{{ user.name }}</h2>
          <q-btn @click="openSendMessage" style="height:40px;" class="q-mb-md" square color="dark">
            <q-icon left size="2em" name="mail" />
            <div>Message</div>
          </q-btn>
          <h6 class="q-pa-none">Location: {{ user.location }}</h6>
          <p class="q-pa-none" style="max-width:98%;">{{ user.biography }}</p>
        </q-card-section>
      </q-card-section>
      <q-separator v-if="orgs.length" />
      <h6 class="q-mt-lg q-ml-lg">Member of:</h6>
    <div class="row q-pa-lg justify-start content-start">
      <p v-if="!orgs.length">No Groups</p>
      <div class="col col-shrink q-ma-sm" v-for="org in orgs" :key="org.id">
        <q-card class="org-card flex-break q-mr-md transparent">
      <div :style="'background-image:url(' + org.avatar_url + ')'" class="card-image"></div>
      <q-card-section>
        <div class="text-h6">{{ org.name }}</div>
      </q-card-section>
      <q-card-section class="q-pt-none">
        <q-btn :to="'/organization/'+org.id" class="full-width" color="dark">VISIT</q-btn>
      </q-card-section>
    </q-card>
      </div>
    </div>
      <q-separator />
    <CommentsWidget :key="'comments' + counter" v-if="user.id"
          :entityId="user.id"
          entityType="user"
    ></CommentsWidget>
    </q-card>
    <q-dialog v-model="sendMessage">
      <MessageWidget
      :senderUserId="visitorUserId"
      :receiverUserId="user.id"
      :receiverName="user.name"
      :done="closeMsg" />
    </q-dialog>
    </div>
    </q-page>
</template>
<script>
import MessageWidget from 'components/widgets/MessageWidget.vue'
import CommentsWidget from 'components/widgets/CommentsWidget.vue'
import EditProfileWidget from 'components/profile/EditProfileWidget.vue'
export default {
  meta () {
    return {
      title: this.user.name
    }
  },
  components: { EditProfileWidget, CommentsWidget, MessageWidget },
  name: 'Profile',
  data () {
    return {
      user: {},
      orgs: {},
      style: '',
      counter: 0,
      expanded: false,
      sendMessage: false,
      visitorUserId: this.$store.state.user.uid,
      isUser: false,
      testColor: 'green'
    }
  },
  async created () {
    this.getProfile()
    this.getOrganizations()
  },
  methods: {
    openSendMessage: function () {
      if (!this.$errorHandler.loggedInCheck()) { return false }
      this.sendMessage = true
    },
    closeMsg: function () {
      this.sendMessage = false
    },
    reload: async function () {
      this.expanded = false
      this.getProfile()
    },
    getProfile: async function () {
      const q = `${process.env.api}/users/${this.$route.params.id}`
      const user = await this.$axios.get(q)
      this.user = user.data
      this.isUser = this.$errorHandler.isLoggedInUser(this.user.id)
    },
    getOrganizations: async function () {
      const q = `${process.env.api}/users/${this.$route.params.id}/organizations`
      const orgs = await this.$axios.get(q)
      this.orgs = orgs.data
    }
  }
}
</script>
<style>
.q-page-container{
  padding-left:0 !important;
  padding-right:0 !important;
}
.q-page{
  width:100%;
}
</style>
